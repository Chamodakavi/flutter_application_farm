import 'dart:async';

import 'package:farmfriend/core/analytics/analytics_service.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/chatbot/data/chat_repository.dart';
import 'package:farmfriend/features/chatbot/data/chat_store.dart';
import 'package:farmfriend/features/chatbot/data/speech_services.dart';
import 'package:farmfriend/features/chatbot/domain/chat_message.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

/// Scripted AgriBot: each [send] takes the next item of [script] — a reply
/// (`String`), a failure (any other object, thrown) or a `Completer<String>`
/// to hold the reply back. With an empty script it echoes the question.
class FakeChatRepository implements ChatRepository {
  final script = <Object>[];
  final sent = <String>[];

  /// History pages handed out in order by [history]; an [Exception] is thrown.
  final historyPages = <Object>[];
  final historyRequests = <int?>[];

  @override
  Duration get timeout => const Duration(seconds: 1);

  @override
  Future<String> send(String text) async {
    sent.add(text);
    if (script.isEmpty) return 'Reply to: $text';
    final next = script.removeAt(0);
    if (next is Completer<String>) return next.future;
    if (next is String) return next;
    throw next;
  }

  @override
  Future<ChatHistoryPage> history({int? beforeId, int limit = 50}) async {
    historyRequests.add(beforeId);
    if (historyPages.isEmpty) return const ChatHistoryPage();
    final next = historyPages.removeAt(0);
    if (next is ChatHistoryPage) return next;
    throw next;
  }
}

class MemoryChatStore implements ChatStore {
  final messages = <String, List<ChatMessage>>{};
  final counts = <String, int>{};

  @override
  Future<List<ChatMessage>?> load(String uid) async {
    final saved = messages[uid];
    return saved == null ? null : List.of(saved);
  }

  @override
  Future<void> save(String uid, List<ChatMessage> list) async => messages[uid] = List.of(list);

  @override
  Future<void> clear(String uid) async => messages[uid] = [];

  @override
  Future<int> sentCount(String uid) async => counts[uid] ?? 0;

  @override
  Future<void> saveSentCount(String uid, int count) async => counts[uid] = count;
}

typedef TrackedEvent = ({String event, Map<String, Object?> props});

/// Records events instead of queueing them for Supabase.
class RecordingAnalytics extends AnalyticsService {
  RecordingAnalytics(super.ref, this.events);

  final List<TrackedEvent> events;

  @override
  void track(String event, [Map<String, Object?> props = const {}]) =>
      events.add((event: event, props: props));
}

class FakeSpeechInput implements SpeechInput {
  FakeSpeechInput({
    this.availability = MicAvailability.unavailable,
    this.startResult = SpeechStartResult.started,
  });

  MicAvailability availability;
  SpeechStartResult startResult;
  int starts = 0;
  int stops = 0;
  void Function(String words)? onWords;
  void Function()? onDone;

  @override
  Future<MicAvailability> probe(String languageCode) async => availability;

  @override
  Future<SpeechStartResult> start({
    required String languageCode,
    required void Function(String words) onWords,
    required void Function() onDone,
  }) async {
    starts++;
    this.onWords = onWords;
    this.onDone = onDone;
    return startResult;
  }

  @override
  Future<void> stop() async => stops++;
}

class FakeSpeechOutput implements SpeechOutput {
  FakeSpeechOutput({this.available = false});

  bool available;
  final spoken = <String>[];
  int stops = 0;

  @override
  Future<bool> isAvailable(String languageCode) async => available;

  @override
  Future<bool> speak(
    String text, {
    required String languageCode,
    required void Function() onDone,
  }) async {
    spoken.add(text);
    return true;
  }

  @override
  Future<void> stop() async => stops++;
}

/// Overrides shared by the chat tests: a signed-in user and no plugins.
List<Override> chatOverrides({
  required FakeChatRepository repository,
  required MemoryChatStore store,
  List<TrackedEvent>? events,
  String? uid = 'user-1',
  FakeSpeechInput? speechInput,
  FakeSpeechOutput? speechOutput,
}) => [
  currentUserIdProvider.overrideWithValue(uid),
  chatRepositoryProvider.overrideWithValue(repository),
  chatStoreProvider.overrideWithValue(store),
  analyticsProvider.overrideWith((ref) => RecordingAnalytics(ref, events ?? [])),
  speechInputProvider.overrideWithValue(speechInput ?? FakeSpeechInput()),
  speechOutputProvider.overrideWithValue(speechOutput ?? FakeSpeechOutput()),
];
