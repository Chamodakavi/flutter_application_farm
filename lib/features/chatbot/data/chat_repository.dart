import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/chat_message.dart';

/// One row of `n8n_chat_histories`, reduced to what a bubble shows.
class ChatHistoryEntry {
  const ChatHistoryEntry({required this.id, required this.role, required this.text});

  final int id;
  final ChatRole role;
  final String text;

  /// n8n stores `{type: human|ai, content}`; older nodes nest the text under
  /// `data`. Tool and system rows (and anything unreadable) give null.
  static ChatHistoryEntry? fromRow(Map<String, dynamic> row) {
    Object? message = row['message'];
    if (message is String) {
      try {
        message = jsonDecode(message);
      } catch (_) {
        return null;
      }
    }
    if (message is! Map) return null;
    final role = switch (message['type']?.toString().toLowerCase()) {
      'human' || 'user' => ChatRole.user,
      'ai' || 'assistant' => ChatRole.bot,
      _ => null,
    };
    final data = message['data'];
    final content = message['content'] ?? (data is Map ? data['content'] : null);
    final text = content is String ? content.trim() : '';
    if (role == null || text.isEmpty) return null;
    return ChatHistoryEntry(id: asInt(row['id']), role: role, text: text);
  }
}

/// A page of server-side chat history, newest row first.
class ChatHistoryPage {
  const ChatHistoryPage({this.entries = const [], this.oldestId, this.hasMore = false});

  final List<ChatHistoryEntry> entries;

  /// Smallest row id on this page — the cursor for the next (older) page.
  final int? oldestId;
  final bool hasMore;
}

/// Talks to AgriBot through the `agribot-chat` Edge Function (spec §14). The
/// app never sees the n8n URL or key.
class ChatRepository {
  ChatRepository(this._db, this._ref, {this.timeout = AppConst.chatTimeout});

  final SupabaseClient _db;
  final Ref _ref;
  final Duration timeout;

  static const historyPageSize = 50;

  /// Sends [text] and returns the assistant's reply in the app language.
  Future<String> send(String text) async {
    final language = _ref.read(localeControllerProvider).languageCode;
    try {
      final res = await _db.functions
          .invoke(EdgeFn.agribotChat, body: {'message': text, 'language': language})
          .timeout(timeout);
      final reply = _replyOf(res.data);
      if (reply == null) throw const AppException.unknown('empty_reply');
      return reply;
    } on FunctionException catch (e) {
      if (e.status == 429) throw const AppException.conflict('chat_rate_limited');
      if (e.status == 401) throw const AppException.auth('session_expired');
      throw AppException.network('chat_${e.status}');
    } on TimeoutException {
      throw const AppException.network('chat_timeout');
    } catch (e) {
      throw mapError(e);
    }
  }

  String? _replyOf(Object? data) {
    var body = data;
    if (body is String) {
      try {
        body = jsonDecode(body);
      } catch (_) {
        return null;
      }
    }
    if (body is! Map) return null;
    final reply = body['reply']?.toString().trim() ?? '';
    return reply.isEmpty ? null : reply;
  }

  /// The user's conversation as stored by n8n (`session_id` = user id), for
  /// the optional "Load earlier". Pass the previous page's `oldestId` as
  /// [beforeId] to go further back.
  Future<ChatHistoryPage> history({int? beforeId, int limit = historyPageSize}) => guard(() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw const AppException.auth('session_expired');
    var query = _db.from(Tables.chatHistories).select('id, message').eq('session_id', uid);
    if (beforeId != null) query = query.lt('id', beforeId);
    final rows = await query
        .order('id', ascending: false)
        .limit(limit)
        .timeout(AppConst.networkTimeout);
    return ChatHistoryPage(
      entries: rows.map(ChatHistoryEntry.fromRow).nonNulls.toList(),
      oldestId: rows.isEmpty ? null : asInt(rows.last['id']),
      hasMore: rows.length >= limit,
    );
  });
}

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ref.watch(supabaseClientProvider), ref),
);
