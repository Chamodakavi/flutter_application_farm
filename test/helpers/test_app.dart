import 'dart:convert';
import 'dart:io';

import 'package:farmfriend/core/l10n/crop_labels.dart';
import 'package:farmfriend/core/l10n/district_labels.dart';
import 'package:farmfriend/core/l10n/l10n_ext.dart';
import 'package:farmfriend/core/l10n/locale_provider.dart';
import 'package:farmfriend/core/network/connectivity_provider.dart';
import 'package:farmfriend/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Loads the crop and district label assets straight from disk.
void loadTestLabels() {
  CropLabels.loadFromJson(
    jsonDecode(File('assets/data/crops_i18n.json').readAsStringSync()) as Map<String, dynamic>,
  );
  Districts.loadFromJson(
    jsonDecode(File('assets/data/districts.json').readAsStringSync()) as List<dynamic>,
  );
}

/// Text shown by the catch-all route, so tests can assert on navigation:
/// `expect(find.text(routeMarker('/cart')), findsOneWidget)`.
String routeMarker(String location) => 'route:$location';

/// Pumps [child] inside the real theme, localizations and a GoRouter, with
/// Riverpod [overrides]. Any other location renders [routeMarker].
///
/// Hive and Supabase are not initialised in tests: override every provider
/// that would reach them (repositories, `supabaseClientProvider`, …).
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
  Locale locale = const Locale('en'),
  double textScale = 1.0,
  Size surfaceSize = const Size(390, 844),
}) async {
  loadTestLabels();
  await initializeDateFormatting();
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => child),
      GoRoute(
        path: '/:rest(.*)',
        builder: (_, state) => Scaffold(body: Center(child: Text(routeMarker(state.uri.toString())))),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        isOnlineProvider.overrideWithValue(true),
        ...overrides,
      ],
      child: MaterialApp.router(
        routerConfig: router,
        locale: locale,
        supportedLocales: AppLocales.all,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: AppTheme.light(locale),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
    ),
  );
  await tester.pump();
}
