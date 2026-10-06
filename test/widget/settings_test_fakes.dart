import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stands in for [ProfileController] so widget tests never reach Supabase:
/// `profileProvider.overrideWith(() => fake)`.
class FakeProfileController extends ProfileController {
  FakeProfileController(this.initial);

  final AppUser? initial;
  final saved = <AppUser>[];
  final notifyChanges = <bool>[];

  @override
  Future<AppUser?> build() async => initial;

  @override
  Future<void> save(AppUser profile) async {
    saved.add(profile);
    state = AsyncData(profile);
  }

  @override
  Future<void> setNotify(bool value) async {
    notifyChanges.add(value);
    state = AsyncData(state.value?.copyWith(notify: value));
  }
}

const testFarmer = AppUser(
  id: 'user-1',
  name: 'Nimal',
  surname: 'Perera',
  email: 'nimal@example.com',
  phone: '+94771234567',
  district: 'Kandy',
  userType: UserTypes.farmer,
);
