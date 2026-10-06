import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/cache/hive_boxes.dart';
import 'core/config/env.dart';
import 'core/l10n/crop_labels.dart';
import 'core/l10n/district_labels.dart';
import 'core/supabase/secure_local_storage.dart';

/// App-wide logger. Never log tokens, passwords, phone numbers or emails
/// (spec §0.5).
final appLogger = Logger(
  level: kReleaseMode ? Level.warning : Level.debug,
  printer: PrettyPrinter(methodCount: 0, errorMethodCount: 8, colors: false),
);

/// Initialises everything the first frame needs, then runs the app.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  _installErrorHandlers();

  if (!Env.isConfigured) {
    runApp(const _MissingConfigApp());
    return;
  }

  await HiveBoxes.init();
  await Future.wait([
    initializeDateFormatting(), // si / ta month and day names
    CropLabels.load(),
    Districts.load(),
    Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseKey,
      // Session in the Android Keystore / iOS Keychain (spec §8.7).
      authOptions: const FlutterAuthClientOptions(localStorage: SecureLocalStorage()),
    ),
  ]);

  // Riverpod 3 retries failed providers by default; the UI has explicit Retry
  // buttons and pull-to-refresh instead, so errors surface immediately.
  final app = ProviderScope(retry: (_, _) => null, child: const FarmFriendApp());

  if (Env.sentryDsn.isEmpty) {
    runApp(app);
    return;
  }
  await SentryFlutter.init((options) {
    options
      ..dsn = Env.sentryDsn
      ..environment = Env.appEnv
      ..sendDefaultPii = false
      ..tracesSampleRate = Env.isProd ? 0.2 : 1.0;
  }, appRunner: () => runApp(SentryWidget(child: app)));
}

void _installErrorHandlers() {
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    appLogger.e('Flutter error', error: details.exception, stackTrace: details.stack);
    previous?.call(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    appLogger.e('Uncaught error', error: error, stackTrace: stack);
    if (Env.sentryDsn.isNotEmpty) unawaited(Sentry.captureException(error, stackTrace: stack));
    return true;
  };
}

/// Shown when the app is started without `--dart-define-from-file`. Developer
/// facing, so it is intentionally not localized.
class _MissingConfigApp extends StatelessWidget {
  const _MissingConfigApp();

  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Color(0xFF0E2A1C),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text(
              'FarmFriend is not configured.\n\n'
              'Copy env/example.json to env/dev.json, fill in SUPABASE_URL and '
              'SUPABASE_PUBLISHABLE_KEY, then run:\n\n'
              'flutter run --dart-define-from-file=env/dev.json',
              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
            ),
          ),
        ),
      ),
    ),
  );
}
