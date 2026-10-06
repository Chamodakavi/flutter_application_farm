import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/constants.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/bucket_status.dart';
import '../domain/farmer_registration.dart';
import '../domain/register_result.dart';

/// National bucket, the quota check and the farmer's own registrations
/// (spec §13.1). The quota rule itself lives in the `register_harvest` RPC.
class RegistrationRepository {
  RegistrationRepository(this._db, this._cache);

  final SupabaseClient _db;
  final CacheStore _cache;

  static const _bucketKey = 'bucket_status';

  /// `get_bucket_status()` — cached for ten minutes so Crop Outlook and the
  /// Register form open offline (spec §17.3).
  Future<List<BucketStatus>> bucketStatus({bool forceRefresh = false}) => _cache.fetch(
    box: HiveBoxes.cacheBucket,
    key: _bucketKey,
    ttl: CacheTtl.bucket,
    forceRefresh: forceRefresh,
    load: () async => await _db.rpc(Rpc.getBucketStatus),
    decode: (json) => asRows(
      json,
    ).where((row) => row['crop_name'] != null).map(BucketStatus.fromJson).toList(),
  );

  /// When the cached bucket was saved — for the "Updated … ago" label.
  DateTime? get bucketSavedAt => _cache.savedAt(HiveBoxes.cacheBucket, _bucketKey);

  /// `register_harvest` — the server decides; a reply this app version cannot
  /// read becomes [RegisterResult.unknown].
  Future<RegisterResult> register(String cropName, double amountMt) => guard(() async {
    final Object? res = await _db.rpc(
      Rpc.registerHarvest,
      params: {'p_crop_name': cropName, 'p_amount_mt': amountMt},
    );
    final Object? body = (res is List && res.isNotEmpty) ? res.first : res;
    if (body is! Map) return const RegisterResult.unknown();
    try {
      return RegisterResult.fromJson(Map<String, dynamic>.from(body));
    } catch (_) {
      return const RegisterResult.unknown();
    }
  });

  /// Own `farmer_registrations`, newest first.
  Future<List<FarmerRegistration>> myRegistrations(String uid, {bool forceRefresh = false}) =>
      _cache.fetch(
        box: HiveBoxes.cacheUser,
        key: 'registrations_$uid',
        ttl: CacheTtl.user,
        forceRefresh: forceRefresh,
        load: () => _db
            .from(Tables.farmerRegistrations)
            .select()
            .eq('farmer_id', uid)
            .order('registered_at', ascending: false),
        decode: (json) => asRows(json).map(FarmerRegistration.fromJson).toList(),
      );

  /// Own `crop_registrations`, newest first. The table's role is not
  /// confirmed (spec §22.1), so a missing table or an RLS rejection yields an
  /// empty list instead of an error.
  Future<List<CropRegistration>> myCropRegistrations(String uid, {bool forceRefresh = false}) async {
    try {
      return await _cache.fetch(
        box: HiveBoxes.cacheUser,
        key: 'crop_registrations_$uid',
        ttl: CacheTtl.user,
        forceRefresh: forceRefresh,
        load: () => _db
            .from(Tables.cropRegistrations)
            .select()
            .eq('user_id', uid)
            .order('created_at', ascending: false),
        decode: (json) => asRows(json).map(CropRegistration.fromJson).toList(),
      );
    } catch (_) {
      return const [];
    }
  }

  /// Calls [onInsert] for every `farmer_registrations` INSERT this user is
  /// allowed to see (realtime respects RLS — spec §17.1). Returns the function
  /// that removes the channel.
  void Function() watchRegistrations(void Function() onInsert) {
    try {
      final channel = _db
          .channel('bucket-live')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: Tables.farmerRegistrations,
            callback: (_) => onInsert(),
          )
          .subscribe();
      return () => unawaited(_db.removeChannel(channel).then((_) {}, onError: (_) {}));
    } catch (_) {
      // No realtime: the 60 s poll keeps the bucket moving.
      return () {};
    }
  }
}

final registrationRepositoryProvider = Provider<RegistrationRepository>(
  (ref) => RegistrationRepository(ref.watch(supabaseClientProvider), ref.watch(cacheStoreProvider)),
);

/// Lets a cached provider tell its first build from a refresh: the first
/// read of a session may come from a fresh cache, every rebuild after that
/// (`ref.invalidate`, pull-to-refresh, the poll) goes to the network.
class RefreshGate {
  bool _opened = false;

  /// False on the first call, true afterwards.
  bool take() {
    final force = _opened;
    _opened = true;
    return force;
  }
}
