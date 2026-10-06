import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/storage_service.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../data/profile_repository.dart';
import '../../domain/app_user.dart';

/// The signed-in user's profile; null while signed out. Rebuilds whenever the
/// account changes.
class ProfileController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    final uid = ref.watch(currentUserIdProvider);
    if (uid == null) return null;
    return ref.read(profileRepositoryProvider).fetch();
  }

  /// Complete Profile / Settings → Account.
  Future<void> save(AppUser profile) async {
    final saved = await ref.read(profileRepositoryProvider).saveProfile(profile);
    state = AsyncData(saved);
  }

  /// Optimistic toggle of `users.u_notify`; reverts on failure.
  Future<void> setNotify(bool value) async {
    final before = state.value;
    if (before == null) return;
    state = AsyncData(before.copyWith(notify: value));
    try {
      await ref.read(profileRepositoryProvider).setNotify(value);
    } catch (_) {
      state = AsyncData(before);
      rethrow;
    }
  }

  /// Uploads a new picture and stores its URL on the profile.
  Future<void> changeAvatar(String filePath) async {
    final before = state.value;
    if (before == null) return;
    final url = await ref.read(storageServiceProvider).uploadAvatar(filePath);
    await ref.read(profileRepositoryProvider).setAvatar(url);
    state = AsyncData(before.copyWith(avatarUrl: url));
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final profileProvider = AsyncNotifierProvider<ProfileController, AppUser?>(
  ProfileController.new,
);

/// True once name and phone are filled in (the Complete Profile gate).
final profileCompleteProvider = Provider<bool>(
  (ref) => ref.watch(profileProvider).value?.isProfileComplete ?? false,
);
