/// Compile-time configuration, injected with `--dart-define-from-file=env/<name>.json`.
///
/// Only public-by-design values belong here (spec §0): the Supabase URL and
/// publishable key, and Google OAuth client IDs.
abstract final class Env {
  static const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  static const googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
  static const googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
  static const weatherProvider =
      String.fromEnvironment('WEATHER_PROVIDER', defaultValue: 'open_meteo');
  static const webAppUrl = String.fromEnvironment(
    'WEB_APP_URL',
    defaultValue: 'https://fyp-blue-beta.vercel.app',
  );
  static const sentryDsn = String.fromEnvironment('SENTRY_DSN');

  static bool get isProd => appEnv == 'prod';

  /// False when the app was started without `--dart-define-from-file`.
  static bool get isConfigured => supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;

  static void assertValid() {
    assert(supabaseUrl.isNotEmpty, 'SUPABASE_URL missing — run with --dart-define-from-file');
    assert(supabaseKey.isNotEmpty, 'SUPABASE_PUBLISHABLE_KEY missing');
  }
}
