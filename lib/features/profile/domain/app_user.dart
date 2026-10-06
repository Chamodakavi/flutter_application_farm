import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// A row of `users` (id = `auth.users.id`).
@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String id,
    @JsonKey(name: 'u_name') String? name,
    @JsonKey(name: 'u_surname') String? surname,
    @JsonKey(name: 'u_email') String? email,
    @JsonKey(name: 'u_tel') String? phone,
    @JsonKey(name: 'u_district') String? district,
    @JsonKey(name: 'u_type') String? userType,
    @JsonKey(name: 'u_notify') @Default(true) bool notify,
    @JsonKey(name: 'u_avatar') String? avatarUrl,
    @JsonKey(name: 'u_role') @Default('farmer') String role,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  /// Name and phone are the mandatory gate before the home shell (spec §8.1).
  bool get isProfileComplete =>
      (name?.trim().isNotEmpty ?? false) && (phone?.trim().isNotEmpty ?? false);

  bool get isAdmin => role.toLowerCase() == 'admin';

  String get displayName => [name, surname]
      .whereType<String>()
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .join(' ');

  /// First letter for the avatar circle.
  String get initial {
    final source = displayName.isNotEmpty ? displayName : (email ?? '?');
    return source.substring(0, 1).toUpperCase();
  }
}

/// Values for `users.u_type` (Settings → "Select Type"). Stored in English;
/// confirm the list against the web app (spec §22.2).
abstract final class UserTypes {
  static const farmer = 'Farmer';
  static const buyer = 'Buyer';
  static const officer = 'Agricultural Officer';
  static const all = [farmer, buyer, officer];
}
