import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/news.dart';

/// Reads `news`, newest first. The last [cacheLimit] items are kept in Hive
/// so the list and detail open offline (spec §11.18, §17.3).
class NewsRepository {
  NewsRepository(this._db, this._cache);

  final SupabaseClient _db;
  final CacheStore _cache;

  /// How many of the newest articles are fetched and saved in one go.
  static const cacheLimit = 50;
  static const _latestKey = 'latest';
  static const _recentCountKey = 'recent_count';

  PostgrestTransformBuilder<List<Map<String, dynamic>>> _range(int offset, int count) => _db
      .from(Tables.news)
      .select()
      .order('created_at', ascending: false)
      .range(offset, offset + count - 1);

  static List<News> _decode(Object? json) => asRows(json).map(News.fromJson).toList();

  /// The newest [cacheLimit] articles through the cache: fresh for
  /// [CacheTtl.news], and the saved copy is returned when the network is down.
  /// The list screen reveals them a page at a time.
  Future<List<News>> fetchLatest({bool forceRefresh = false}) => _cache.fetch(
    box: HiveBoxes.cacheNews,
    key: _latestKey,
    ttl: CacheTtl.news,
    forceRefresh: forceRefresh,
    load: () async => await _range(0, cacheLimit),
    decode: _decode,
  );

  /// A page of older articles, [AppConst.pageSize] from [offset] — beyond
  /// what [fetchLatest] returned, so always from the network.
  Future<List<News>> fetchMore(int offset) =>
      guard(() async => _decode(await _range(offset, AppConst.pageSize)));

  News? _cachedById(int id) {
    try {
      final saved = _decode(_cache.read(HiveBoxes.cacheNews, _latestKey)?.data);
      for (final item in saved) {
        if (item.id == id) return item;
      }
    } catch (_) {
      // Unreadable cache: fall through to the network.
    }
    return null;
  }

  /// One article — the saved list item when there is one, else by id from
  /// the server (deep links, spec §9.3).
  Future<News> fetchById(int id) => guard(() async {
    final cached = _cachedById(id);
    if (cached != null) return cached;
    final row = await _db.from(Tables.news).select().eq('n_id', id).maybeSingle();
    if (row == null) throw const AppException.notFound();
    return News.fromJson(row);
  });

  /// Number of articles created on or after [since] (Home stat card).
  Future<int> countSince(DateTime since) => _cache.fetch(
    box: HiveBoxes.cacheNews,
    key: _recentCountKey,
    ttl: CacheTtl.news,
    load: () async =>
        await _db.from(Tables.news).count().gte('created_at', since.toUtc().toIso8601String()),
    decode: asInt,
  );
}

final newsRepositoryProvider = Provider<NewsRepository>(
  (ref) => NewsRepository(ref.watch(supabaseClientProvider), ref.watch(cacheStoreProvider)),
);
