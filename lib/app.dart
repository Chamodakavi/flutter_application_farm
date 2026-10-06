import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/analytics/analytics_service.dart';
import 'core/config/app_config_provider.dart';
import 'core/config/env.dart';
import 'core/l10n/l10n_ext.dart';
import 'core/l10n/locale_provider.dart';
import 'core/notifications/local_notifications.dart';
import 'core/notifications/push_service.dart';
import 'core/router/app_router.dart';
import 'core/supabase/supabase_providers.dart';
import 'core/theme/app_theme.dart';

/// Root widget: router, theme and the three app languages.
class FarmFriendApp extends ConsumerStatefulWidget {
  const FarmFriendApp({super.key});

  @override
  ConsumerState<FarmFriendApp> createState() => _FarmFriendAppState();
}

class _FarmFriendAppState extends ConsumerState<FarmFriendApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tagCrashReports();
    unawaited(_startServices());
  }

  Future<void> _startServices() async {
    final router = ref.read(routerProvider);
    final local = ref.read(localNotificationsProvider)
      // A tapped notification (local or push) opens its deep link.
      ..onOpenRoute = (route) => router.push(route);
    await local.init();
    final push = ref.read(pushServiceProvider);
    await push.init();
    if (ref.read(currentUserIdProvider) != null) await push.registerDevice();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      unawaited(ref.read(analyticsProvider).flush());
    } else if (state == AppLifecycleState.resumed) {
      // Pick up a maintenance switch or version bump made while backgrounded.
      ref.invalidate(appConfigProvider);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Crash reports carry the user id (never email or phone) and the app
  /// language (spec §18.3).
  void _tagCrashReports() {
    if (Env.sentryDsn.isEmpty) return;
    ref
      ..listenManual(currentUserIdProvider, fireImmediately: true, (_, uid) {
        Sentry.configureScope((s) => s.setUser(uid == null ? null : SentryUser(id: uid)));
      })
      ..listenManual(localeControllerProvider, fireImmediately: true, (_, locale) {
        Sentry.configureScope((s) => s.setTag('locale', locale.languageCode));
      });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
      locale: locale,
      supportedLocales: AppLocales.all,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.light(locale),
      builder: (context, child) {
        // Respect system text scaling up to 1.3 (spec §10.2).
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: media.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.3),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
