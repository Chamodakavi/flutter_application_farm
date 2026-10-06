import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../data/chat_repository.dart';
import '../../data/chat_store.dart';
import '../../domain/chat_message.dart';

/// `createdAt` of bubbles rebuilt from the server history, which carries no
/// timestamps; the UI hides the time for these.
final chatHistoryEpoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

/// Everything the chat screen renders.
class ChatState {
  const ChatState({
    this.messages = const [],
    this.earlier = const [],
    this.restoring = false,
    this.waiting = false,
    this.rateLimited = false,
    this.canLoadEarlier = false,
    this.loadingEarlier = false,
    this.sentCount = 0,
  });

  /// The conversation kept on the device — at most
  /// [ChatController.maxMessages], oldest first.
  final List<ChatMessage> messages;

  /// Older messages fetched from the server with "Load earlier" (not saved).
  final List<ChatMessage> earlier;

  /// True until the saved conversation has been read.
  final bool restoring;

  /// A question is on its way — show the typing indicator.
  final bool waiting;

  /// The last question was refused with 429.
  final bool rateLimited;

  final bool canLoadEarlier;
  final bool loadingEarlier;

  /// Questions answered so far for this user (feedback prompt after the 5th).
  final int sentCount;

  List<ChatMessage> get all => [...earlier, ...messages];
  bool get isEmpty => messages.isEmpty && earlier.isEmpty;

  ChatState copyWith({
    List<ChatMessage>? messages,
    List<ChatMessage>? earlier,
    bool? restoring,
    bool? waiting,
    bool? rateLimited,
    bool? canLoadEarlier,
    bool? loadingEarlier,
    int? sentCount,
  }) => ChatState(
    messages: messages ?? this.messages,
    earlier: earlier ?? this.earlier,
    restoring: restoring ?? this.restoring,
    waiting: waiting ?? this.waiting,
    rateLimited: rateLimited ?? this.rateLimited,
    canLoadEarlier: canLoadEarlier ?? this.canLoadEarlier,
    loadingEarlier: loadingEarlier ?? this.loadingEarlier,
    sentCount: sentCount ?? this.sentCount,
  );
}

/// Works out which rows of the server history are older than what is already
/// on screen. The history has no ids in common with the local messages, so
/// rows are matched by role and text, walking both from the newest end.
class HistoryAligner {
  HistoryAligner(Iterable<ChatMessage> onScreen)
    : _local = [
        for (final m in onScreen)
          if (m.status == ChatStatus.sent) m,
      ] {
    _cursor = _local.length - 1;
  }

  final List<ChatMessage> _local;
  late int _cursor;

  /// How far back in the local list a server row is searched for, to step
  /// over local messages the server never stored.
  static const _lookBack = 6;

  /// After this many server rows in a row that match nothing on screen, the
  /// two lists clearly do not line up (the workflow stores other text):
  /// everything further back is then treated as older.
  static const _maxUnmatched = 20;
  int _unmatched = 0;

  static String _fold(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');

  static bool _same(ChatHistoryEntry entry, ChatMessage message) {
    if (entry.role != message.role) return false;
    final a = _fold(entry.text);
    final b = _fold(message.text);
    // The workflow may wrap the farmer's question in extra instructions.
    return a == b || (message.isUser && b.length >= 8 && a.contains(b));
  }

  /// Takes the next page ([newestFirst]) and returns the rows that are older
  /// than every message on screen, still newest first.
  List<ChatHistoryEntry> older(List<ChatHistoryEntry> newestFirst) {
    final result = <ChatHistoryEntry>[];
    for (final entry in newestFirst) {
      if (_cursor < 0) {
        result.add(entry);
        continue;
      }
      final stop = _cursor - _lookBack < 0 ? 0 : _cursor - _lookBack;
      var matched = false;
      for (var i = _cursor; i >= stop && !matched; i--) {
        if (_same(entry, _local[i])) {
          _cursor = i - 1;
          matched = true;
        }
      }
      // No match: a message from another device in between — not "earlier".
      _unmatched = matched ? 0 : _unmatched + 1;
      if (_unmatched >= _maxUnmatched) _cursor = -1;
    }
    return result;
  }
}

/// The AgriBot conversation (spec §14.3): sends questions, keeps the last 100
/// messages per user on the device and survives leaving the screen while a
/// reply is on its way.
class ChatController extends Notifier<ChatState> {
  static const maxMessages = 100;
  static const _uuid = Uuid();

  String? _uid;
  Future<void> _ready = Future<void>.value();
  int? _oldestHistoryId;
  HistoryAligner? _aligner;

  @override
  ChatState build() {
    final uid = ref.watch(currentUserIdProvider);
    _uid = uid;
    _oldestHistoryId = null;
    _aligner = null;
    if (uid == null) {
      _ready = Future<void>.value();
      return const ChatState();
    }
    _ready = _restore(uid);
    return const ChatState(restoring: true);
  }

  /// False once the account changed (or the provider went away) during an
  /// `await` — results for the previous user must be dropped.
  bool _isCurrent(String uid) => ref.mounted && _uid == uid;

  Future<void> _restore(String uid) async {
    List<ChatMessage>? saved;
    var count = 0;
    try {
      final store = ref.read(chatStoreProvider);
      saved = await store.load(uid);
      count = await store.sentCount(uid);
    } catch (_) {
      // Storage unavailable: the chat still works, just without history.
    }
    if (!_isCurrent(uid)) return;
    state = ChatState(
      // A question that was still on its way when the app closed never got
      // its answer: offer "Tap to retry".
      messages: _cap([
        for (final m in saved ?? const <ChatMessage>[])
          m.status == ChatStatus.sending ? m.copyWith(status: ChatStatus.failed) : m,
      ]),
      // A chat the user cleared stays cleared.
      canLoadEarlier: saved == null || saved.isNotEmpty,
      sentCount: count,
    );
    // New phone or fresh install: bring back the conversation kept by the
    // server without making the farmer ask for it.
    if (saved == null) unawaited(_loadEarlier(uid));
  }

  List<ChatMessage> _cap(List<ChatMessage> list) =>
      list.length <= maxMessages ? list : list.sublist(list.length - maxMessages);

  List<ChatMessage> _withStatus(String id, ChatStatus status) => [
    for (final m in state.messages) m.id == id ? m.copyWith(status: status) : m,
  ];

  Future<void> _persist(String uid) async {
    try {
      await ref.read(chatStoreProvider).save(uid, state.messages);
    } catch (_) {
      // Best effort: the conversation stays in memory.
    }
  }

  /// Appends [text] as the user's message and asks AgriBot. Ignored while a
  /// previous question is still waiting for its reply.
  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    await _ready;
    final uid = _uid;
    if (uid == null || !ref.mounted || state.waiting) return;
    final message = ChatMessage(
      id: _uuid.v4(),
      role: ChatRole.user,
      text: trimmed,
      createdAt: DateTime.now(),
      status: ChatStatus.sending,
    );
    state = state.copyWith(
      messages: _cap([...state.messages, message]),
      waiting: true,
      rateLimited: false,
    );
    await _persist(uid);
    await _deliver(uid, message);
  }

  /// Re-sends a failed message ("Tap to retry").
  Future<void> retry(String id) async {
    await _ready;
    final uid = _uid;
    if (uid == null || !ref.mounted || state.waiting) return;
    final index = state.messages.indexWhere((m) => m.id == id && m.isFailed);
    if (index < 0) return;
    final message = state.messages[index].copyWith(
      status: ChatStatus.sending,
      createdAt: DateTime.now(),
    );
    // Moved to the end so the reply lands right under its question.
    state = state.copyWith(
      messages: [...state.messages]
        ..removeAt(index)
        ..add(message),
      waiting: true,
      rateLimited: false,
    );
    await _persist(uid);
    await _deliver(uid, message);
  }

  Future<void> _deliver(String uid, ChatMessage message) async {
    final String reply;
    try {
      reply = await ref.read(chatRepositoryProvider).send(message.text);
    } catch (e) {
      if (!_isCurrent(uid)) return;
      state = state.copyWith(
        messages: _withStatus(message.id, ChatStatus.failed),
        waiting: false,
        rateLimited: e is ConflictFailure && e.code == 'chat_rate_limited',
      );
      await _persist(uid);
      return;
    }
    if (!_isCurrent(uid)) return;
    if (!state.messages.any((m) => m.id == message.id)) {
      // The chat was cleared while the question was on its way.
      state = state.copyWith(waiting: false);
      return;
    }
    final answer = ChatMessage(
      id: _uuid.v4(),
      role: ChatRole.bot,
      text: reply,
      createdAt: DateTime.now(),
    );
    final count = state.sentCount + 1;
    state = state.copyWith(
      messages: _cap([..._withStatus(message.id, ChatStatus.sent), answer]),
      waiting: false,
      sentCount: count,
    );
    // Only the language is recorded — never what the farmer asked.
    _track(AnalyticsEvents.chatSent);
    await _persist(uid);
    try {
      await ref.read(chatStoreProvider).saveSentCount(uid, count);
    } catch (_) {}
  }

  void _track(String event) {
    try {
      ref.read(analyticsProvider).track(event, {
        'language': ref.read(localeControllerProvider).languageCode,
      });
    } catch (_) {
      // Analytics must never affect the chat.
    }
  }

  /// Removes the conversation from this device.
  Future<void> clear() async {
    await _ready;
    final uid = _uid;
    if (uid == null || !ref.mounted) return;
    state = state.copyWith(
      messages: const [],
      earlier: const [],
      waiting: false,
      rateLimited: false,
      // The server still remembers the conversation; do not offer to bring
      // back what the user just removed.
      canLoadEarlier: false,
      loadingEarlier: false,
    );
    try {
      await ref.read(chatStoreProvider).clear(uid);
    } catch (_) {}
  }

  /// Best-effort "Load earlier" from the server-side history.
  Future<void> loadEarlier() async {
    await _ready;
    final uid = _uid;
    if (uid == null || !ref.mounted) return;
    await _loadEarlier(uid);
  }

  Future<void> _loadEarlier(String uid) async {
    if (!state.canLoadEarlier || state.loadingEarlier) return;
    state = state.copyWith(loadingEarlier: true);
    try {
      final repository = ref.read(chatRepositoryProvider);
      final aligner = _aligner ??= HistoryAligner(state.messages);
      var found = const <ChatHistoryEntry>[];
      var hasMore = true;
      // The newest pages may only repeat what is already on screen.
      for (var round = 0; round < 3 && found.isEmpty && hasMore; round++) {
        final page = await repository.history(beforeId: _oldestHistoryId);
        // Dropped when the account changed or the chat was cleared meanwhile.
        if (!_isCurrent(uid) || !state.loadingEarlier) return;
        hasMore = page.hasMore;
        _oldestHistoryId = page.oldestId ?? _oldestHistoryId;
        found = aligner.older(page.entries);
      }
      state = state.copyWith(
        earlier: [
          for (final entry in found.reversed)
            ChatMessage(
              id: 'history-${entry.id}',
              role: entry.role,
              text: entry.text,
              createdAt: chatHistoryEpoch,
            ),
          ...state.earlier,
        ],
        canLoadEarlier: hasMore && found.isNotEmpty,
        loadingEarlier: false,
      );
    } catch (_) {
      // No access to the history table, or offline: just hide the option.
      if (_isCurrent(uid)) {
        state = state.copyWith(canLoadEarlier: false, loadingEarlier: false);
      }
    }
  }
}

final chatControllerProvider = NotifierProvider<ChatController, ChatState>(ChatController.new);
