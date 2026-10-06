import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../core/cache/hive_boxes.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/chat_message.dart';

/// Where the conversation is kept on the device (spec §17.3). Behind an
/// interface so tests can use an in-memory fake — Hive is not initialised
/// there.
abstract class ChatStore {
  /// The saved conversation, or null when nothing was ever saved for [uid]
  /// on this device (fresh install, or after signing out).
  Future<List<ChatMessage>?> load(String uid);

  Future<void> save(String uid, List<ChatMessage> messages);

  /// Empties the conversation but remembers that the user cleared it, so
  /// [load] returns an empty list rather than null.
  Future<void> clear(String uid);

  /// How many questions the user has had answered so far (drives the
  /// one-time feedback prompt, spec §18.4).
  Future<int> sentCount(String uid);

  Future<void> saveSentCount(String uid, int count);
}

/// Messages as one JSON string in the per-user `chat_{uid}` box; the counter
/// lives in `prefs`.
class HiveChatStore implements ChatStore {
  const HiveChatStore();

  static const _messagesKey = 'messages';

  Box<dynamic>? get _prefs =>
      Hive.isBoxOpen(HiveBoxes.prefs) ? Hive.box<dynamic>(HiveBoxes.prefs) : null;

  @override
  Future<List<ChatMessage>?> load(String uid) async {
    final box = await HiveBoxes.open(HiveBoxes.chat(uid));
    final raw = box.get(_messagesKey);
    if (raw is! String) return null;
    try {
      return asRows(jsonDecode(raw)).map(ChatMessage.fromJson).toList();
    } catch (_) {
      // Saved by an incompatible app version: start with an empty chat.
      return const [];
    }
  }

  @override
  Future<void> save(String uid, List<ChatMessage> messages) async {
    final box = await HiveBoxes.open(HiveBoxes.chat(uid));
    await box.put(_messagesKey, jsonEncode([for (final m in messages) m.toJson()]));
  }

  @override
  Future<void> clear(String uid) async {
    final box = await HiveBoxes.open(HiveBoxes.chat(uid));
    await box.put(_messagesKey, jsonEncode(const <Object>[]));
  }

  @override
  Future<int> sentCount(String uid) async => asInt(_prefs?.get(PrefKeys.chatCount(uid)));

  @override
  Future<void> saveSentCount(String uid, int count) async =>
      _prefs?.put(PrefKeys.chatCount(uid), count);
}

final chatStoreProvider = Provider<ChatStore>((ref) => const HiveChatStore());
