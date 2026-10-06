import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Keeps the Supabase session in the Android Keystore / iOS Keychain instead
/// of the SDK default (plain SharedPreferences) — spec §8.7.
class SecureLocalStorage extends LocalStorage {
  const SecureLocalStorage();

  static const _storage = FlutterSecureStorage();
  static const _key = 'sb_session';

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async => (await _read()) != null;

  @override
  Future<String?> accessToken() => _read();

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: _key, value: persistSessionString);

  @override
  Future<void> removePersistedSession() => _storage.delete(key: _key);

  /// A keystore wiped by a device restore must not block app start.
  Future<String?> _read() async {
    try {
      return await _storage.read(key: _key);
    } catch (_) {
      await _storage.delete(key: _key);
      return null;
    }
  }
}
