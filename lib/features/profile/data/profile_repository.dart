import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../domain/app_user.dart';

class ProfileRepository {
  ProfileRepository(this._db, this._cache);

  final SupabaseClient _db;
  final CacheStore _cache;

  User get _user {
    final user = _db.auth.currentUser;
    if (user == null) throw const AppException.auth('session_expired');
    return user;
  }

  String _cacheKey(String uid) => 'profile_$uid';

  /// The signed-in user's `users` row.
  ///
  /// A missing row is created on the fly (spec §8.6). When offline, the last
  /// saved copy is returned so the app can still open (TC_MOB_02).
  Future<AppUser> fetch() async {
    final user = _user;
    try {
      var row = await _db.from(Tables.users).select().eq('id', user.id).maybeSingle();
      if (row == null) {
        await ensureProfileRow();
        row = await _db.from(Tables.users).select().eq('id', user.id).maybeSingle();
      }
      // Still nothing (RLS or trigger problem): a blank profile sends the user
      // to Complete Profile, whose upsert creates the row.
      if (row == null) return AppUser(id: user.id, email: user.email);
      await _cache.write(HiveBoxes.cacheUser, _cacheKey(user.id), row);
      return AppUser.fromJson(row);
    } catch (e) {
      final failure = mapError(e);
      final cached = _cache.read(HiveBoxes.cacheUser, _cacheKey(user.id));
      if (failure is NetworkException && cached?.data is Map) {
        return AppUser.fromJson(Map<String, dynamic>.from(cached!.data! as Map));
      }
      throw failure;
    }
  }

  /// Safety net behind the database trigger: called right after every
  /// successful sign-in. Never overwrites an existing row.
  Future<void> ensureProfileRow() => guard(() async {
    final user = _user;
    final meta = user.userMetadata ?? const <String, dynamic>{};
    final phone = user.phone;
    await _db.from(Tables.users).upsert(
      {
        'id': user.id,
        'u_email': user.email,
        'u_tel': (phone != null && phone.isNotEmpty)
            ? (phone.startsWith('+') ? phone : '+$phone')
            : null,
        'u_name': meta['full_name'] ?? meta['name'] ?? user.email?.split('@').first,
        'u_avatar': meta['avatar_url'] ?? meta['picture'],
      },
      onConflict: 'id',
      ignoreDuplicates: true,
    );
  });

  /// Complete Profile and Settings → Account. Upsert, so it also repairs a
  /// missing row. `u_role` is never sent from the app (spec §0.4).
  Future<AppUser> saveProfile(AppUser profile) => guard(() async {
    final user = _user;
    final row = await _db
        .from(Tables.users)
        .upsert({
          'id': user.id,
          'u_email': user.email ?? profile.email,
          'u_name': profile.name?.trim(),
          'u_surname': profile.surname?.trim(),
          'u_tel': profile.phone?.trim(),
          'u_district': profile.district,
          'u_type': profile.userType,
          'u_notify': profile.notify,
          if (profile.avatarUrl != null) 'u_avatar': profile.avatarUrl,
        }, onConflict: 'id')
        .select()
        .single();
    await _cache.write(HiveBoxes.cacheUser, _cacheKey(user.id), row);
    return AppUser.fromJson(row);
  });

  /// Master notification switch (`users.u_notify`).
  Future<void> setNotify(bool value) => guard(() async {
    await _db.from(Tables.users).update({'u_notify': value}).eq('id', _user.id);
  });

  Future<void> setAvatar(String url) => guard(() async {
    await _db.from(Tables.users).update({'u_avatar': url}).eq('id', _user.id);
  });
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(supabaseClientProvider), ref.watch(cacheStoreProvider)),
);
