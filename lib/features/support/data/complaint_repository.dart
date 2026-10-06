import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/complaint.dart';

/// Contact Support messages (`complaints`, spec §11.23): the farmer reads and
/// inserts own rows; admins reply on the web.
class ComplaintRepository {
  ComplaintRepository(this._db, this._cache);

  final SupabaseClient _db;
  final CacheStore _cache;

  String get _uid {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw const AppException.auth('session_expired');
    return uid;
  }

  static String _cacheKey(String uid) => 'complaints_$uid';

  static List<Complaint> _decode(Object? json) => asRows(json).map(Complaint.fromJson).toList();

  /// The user's messages, newest first. Always asks the server so a new reply
  /// shows up; the saved copy is used only while offline.
  Future<List<Complaint>> fetchMine() async {
    final uid = _uid;
    return _cache.fetch(
      box: HiveBoxes.cacheUser,
      key: _cacheKey(uid),
      ttl: CacheTtl.user,
      forceRefresh: true,
      load: () => _db
          .from(Tables.complaints)
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false),
      decode: _decode,
    );
  }

  /// One message by id (a push notification opens the detail directly).
  /// Offline, the copy from the saved list is returned when there is one.
  Future<Complaint> fetchById(int id) async {
    final uid = _uid;
    try {
      final row = await _db
          .from(Tables.complaints)
          .select()
          .eq('id', id)
          .eq('user_id', uid)
          .maybeSingle();
      if (row == null) throw const AppException.notFound();
      return Complaint.fromJson(row);
    } catch (e) {
      final failure = mapError(e);
      if (failure is NetworkException) {
        final cached = _cached(uid).where((c) => c.id == id).firstOrNull;
        if (cached != null) return cached;
      }
      throw failure;
    }
  }

  List<Complaint> _cached(String uid) {
    try {
      return _decode(_cache.read(HiveBoxes.cacheUser, _cacheKey(uid))?.data);
    } catch (_) {
      return const [];
    }
  }

  /// Inserts a new message with status `Pending` and returns the saved row.
  Future<Complaint> send({
    required String subject,
    required String body,
    String? userName,
    String? userEmail,
  }) => guard(() async {
    final row = await _db
        .from(Tables.complaints)
        .insert({
          'user_id': _uid,
          'user_name': userName,
          'user_email': userEmail,
          'subject': subject,
          'body': body,
          'status': 'Pending',
        })
        .select()
        .single();
    return Complaint.fromJson(row);
  });

  /// Marks the admin's reply as seen by the farmer (`read_at`).
  Future<void> markRead(int id) => guard(() async {
    await _db
        .from(Tables.complaints)
        .update({'read_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', id)
        .eq('user_id', _uid)
        .isFilter('read_at', null);
  });

  /// Keeps the offline copy in step with what the screen shows.
  Future<void> saveToCache(List<Complaint> complaints) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return;
    await _cache.write(HiveBoxes.cacheUser, _cacheKey(uid), [
      for (final c in complaints) c.toJson(),
    ]);
  }
}

final complaintRepositoryProvider = Provider<ComplaintRepository>(
  (ref) => ComplaintRepository(ref.watch(supabaseClientProvider), ref.watch(cacheStoreProvider)),
);
