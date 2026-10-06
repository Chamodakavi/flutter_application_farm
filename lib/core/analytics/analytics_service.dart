import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config_provider.dart';
import '../config/constants.dart';
import '../errors/error_mapper.dart';
import '../l10n/locale_provider.dart';
import '../supabase/supabase_providers.dart';

/// Event names for the usage evaluation (spec §18.4).
abstract final class AnalyticsEvents {
  static const registerCheck = 'register_check';
  static const registerSuccess = 'register_success';
  static const registerSurplus = 'register_surplus';
  static const altCropChosen = 'alt_crop_chosen';
  static const priceViewed = 'price_viewed';
  static const plannerUsed = 'planner_used';
  static const orderPlaced = 'order_placed';
  static const chatSent = 'chat_sent';
  static const voiceUsed = 'voice_used';
  static const languageChanged = 'language_changed';
  static const pushOpened = 'push_opened';
}

/// Batches usage events into `analytics_events`. Events are flushed every 30 s
/// and when the app is paused. Failures are swallowed — analytics must never
/// affect the user. Props must not contain names, emails or phone numbers.
class AnalyticsService {
  AnalyticsService(this._ref);

  final Ref _ref;
  final _queue = <Map<String, dynamic>>[];
  Timer? _timer;

  static const _flushEvery = Duration(seconds: 30);
  static const _maxQueue = 200;

  void track(String event, [Map<String, Object?> props = const {}]) {
    final uid = _ref.read(supabaseClientProvider).auth.currentUser?.id;
    if (uid == null) return;
    if (_queue.length >= _maxQueue) _queue.removeAt(0);
    _queue.add({
      'user_id': uid,
      'event': event,
      'props': props,
      'app_version': _ref.read(appVersionProvider).value,
      'platform': defaultTargetPlatform.name,
      'locale': _ref.read(localeControllerProvider).languageCode,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
    _timer ??= Timer(_flushEvery, flush);
  }

  Future<void> flush() async {
    _timer?.cancel();
    _timer = null;
    if (_queue.isEmpty) return;
    final batch = List<Map<String, dynamic>>.of(_queue);
    _queue.clear();
    try {
      await _ref.read(supabaseClientProvider).from(Tables.analyticsEvents).insert(batch);
    } catch (_) {
      // Offline: keep the events for the next flush, bounded by _maxQueue.
      if (_queue.length + batch.length <= _maxQueue) _queue.insertAll(0, batch);
    }
  }

  void dispose() => _timer?.cancel();
}

final analyticsProvider = Provider<AnalyticsService>((ref) {
  final service = AnalyticsService(ref);
  ref.onDispose(service.dispose);
  return service;
});

/// In-app feedback → `app_feedback` (spec §18.4).
class FeedbackRepository {
  FeedbackRepository(this._db);

  final SupabaseClient _db;

  Future<void> submit({
    required String context,
    required int rating,
    required int easeRating,
    required int usefulnessRating,
    String? comment,
    required String locale,
  }) => guard(() async {
    await _db.from(Tables.appFeedback).insert({
      'user_id': _db.auth.currentUser?.id,
      'context': context,
      'rating': rating,
      'ease_rating': easeRating,
      'usefulness_rating': usefulnessRating,
      'comment': (comment == null || comment.trim().isEmpty) ? null : comment.trim(),
      'locale': locale,
    });
  });
}

final feedbackRepositoryProvider = Provider<FeedbackRepository>(
  (ref) => FeedbackRepository(ref.watch(supabaseClientProvider)),
);
