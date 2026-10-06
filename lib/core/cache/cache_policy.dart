import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../errors/app_exception.dart';
import '../errors/error_mapper.dart';

/// How long each cache stays fresh (spec §17.3).
abstract final class CacheTtl {
  static const news = Duration(hours: 1);
  static const bucket = Duration(minutes: 10);
  static const products = Duration(minutes: 30);
  static const weather = Duration(minutes: 30);
  static const prices = Duration(hours: 6);
  static const config = Duration(hours: 1);
  static const user = Duration(minutes: 5);
}

class CacheEntry {
  const CacheEntry(this.data, this.savedAt);

  /// Decoded JSON (`List`, `Map` or primitive).
  final Object? data;
  final DateTime savedAt;

  bool isFresh(Duration ttl) => DateTime.now().difference(savedAt) < ttl;
}

/// JSON cache on top of Hive. Every method is a no-op when the box is not
/// open, so widget tests run without initialising Hive.
class CacheStore {
  const CacheStore();

  Box<dynamic>? _box(String name) => Hive.isBoxOpen(name) ? Hive.box<dynamic>(name) : null;

  CacheEntry? read(String box, String key) {
    final raw = _box(box)?.get(key);
    if (raw is! String) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return CacheEntry(map['d'], DateTime.fromMillisecondsSinceEpoch(map['t'] as int));
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String box, String key, Object? data) async {
    await _box(box)?.put(
      key,
      jsonEncode({'t': DateTime.now().millisecondsSinceEpoch, 'd': data}),
    );
  }

  Future<void> remove(String box, String key) async => _box(box)?.delete(key);

  Future<void> clear(String box) async => _box(box)?.clear();

  /// When [key] was last saved — for "updated X ago" labels.
  DateTime? savedAt(String box, String key) => read(box, key)?.savedAt;

  /// Fetches raw JSON through the cache.
  ///
  /// * Fresh cache (younger than [ttl]) and not [forceRefresh] → cache.
  /// * Otherwise → network, then saved.
  /// * Network failure → stale cache if any, else the error is rethrown.
  Future<T> fetch<T>({
    required String box,
    required String key,
    required Duration ttl,
    required Future<Object?> Function() load,
    required T Function(Object? json) decode,
    bool forceRefresh = false,
  }) async {
    final cached = read(box, key);
    if (!forceRefresh && cached != null && cached.isFresh(ttl)) {
      try {
        return decode(cached.data);
      } catch (_) {
        // Schema drift between app versions: fall through to the network.
      }
    }
    try {
      final raw = await load();
      await write(box, key, raw);
      return decode(raw);
    } catch (e) {
      final failure = mapError(e);
      if (cached != null && failure is NetworkException) {
        try {
          return decode(cached.data);
        } catch (_) {}
      }
      throw failure;
    }
  }
}

final cacheStoreProvider = Provider<CacheStore>((ref) => const CacheStore());
