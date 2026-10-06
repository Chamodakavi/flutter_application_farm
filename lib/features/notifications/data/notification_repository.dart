import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/constants.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/app_notification.dart';

/// The broadcast inbox (`notifications`, spec §11.24) — read only.
class NotificationRepository {
  NotificationRepository(this._db, this._cache);

  final SupabaseClient _db;
  final CacheStore _cache;

  /// The inbox shows the newest broadcasts only.
  static const maxItems = 100;

  static String _cacheKey(String uid) => 'notifications_$uid';

  /// Newest first. Always asks the server so the badge is right; the copy
  /// saved for [uid] is used only while offline.
  Future<List<AppNotification>> fetchLatest(String uid) => _cache.fetch(
    box: HiveBoxes.cacheUser,
    key: _cacheKey(uid),
    ttl: CacheTtl.user,
    forceRefresh: true,
    load: () => _db
        .from(Tables.notifications)
        .select()
        .order('created_at', ascending: false)
        .limit(maxItems),
    decode: (json) => asRows(json).map(AppNotification.fromJson).toList(),
  );

  /// Keeps the offline copy in step after a realtime insert.
  Future<void> saveToCache(String uid, List<AppNotification> items) =>
      _cache.write(HiveBoxes.cacheUser, _cacheKey(uid), [for (final n in items) n.toJson()]);
}

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepository(ref.watch(supabaseClientProvider), ref.watch(cacheStoreProvider)),
);
