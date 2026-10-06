import 'package:farmfriend/core/router/routes.dart';
import 'package:farmfriend/features/cart/presentation/controllers/cart_controller.dart';
import 'package:farmfriend/features/more/presentation/more_screen.dart';
import 'package:farmfriend/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import 'settings_test_fakes.dart';

void main() {
  Future<void> pumpMore(
    WidgetTester tester, {
    AppUser? profile = testFarmer,
    Locale locale = const Locale('en'),
    double textScale = 1.0,
    // Tall by default so every row is built without scrolling.
    Size surfaceSize = const Size(390, 1800),
  }) async {
    await pumpApp(
      tester,
      const MoreScreen(),
      overrides: [
        profileProvider.overrideWith(() => FakeProfileController(profile)),
        // The shared app bar shows these two badges.
        cartCountProvider.overrideWithValue(0),
        unreadNotificationCountProvider.overrideWithValue(0),
      ],
      locale: locale,
      textScale: textScale,
      surfaceSize: surfaceSize,
    );
    await tester.pump();
  }

  testWidgets('shows the profile header and every destination', (tester) async {
    await pumpMore(tester);

    expect(find.text('Nimal Perera'), findsOneWidget);
    expect(find.text('Kandy · Farmer'), findsOneWidget);

    for (final label in [
      'News',
      'Crop Prices',
      'Profit Planner',
      'Crop Outlook',
      'My Orders',
      'My Quotas',
      'Contact Support',
      'Notifications',
      'Settings',
      'Language',
      'Open web portal',
      'About',
      'Sign out',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
  });

  testWidgets('tapping Crop Prices opens the prices screen', (tester) async {
    await pumpMore(tester);

    await tester.tap(find.text('Crop Prices'));
    await tester.pumpAndSettle();

    expect(find.text(routeMarker(Routes.prices)), findsOneWidget);
  });

  testWidgets('every row pushes its route', (tester) async {
    const destinations = {
      'News': Routes.news,
      'Profit Planner': Routes.planner,
      'Crop Outlook': Routes.outlook,
      'My Orders': Routes.orders,
      'My Quotas': Routes.myQuotas,
      'Contact Support': Routes.support,
      'Notifications': Routes.notifications,
      'Settings': Routes.settings,
      'Language': Routes.settingsLanguage,
      'About': Routes.settingsAbout,
    };
    await pumpMore(tester);

    for (final entry in destinations.entries) {
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker(entry.value)), findsOneWidget, reason: entry.key);

      // Pushed, not replaced: back returns to the More tab.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Crop Prices'), findsOneWidget, reason: 'back from ${entry.key}');
    }
  });

  testWidgets('the profile header opens Settings', (tester) async {
    await pumpMore(tester);

    await tester.tap(find.text('Nimal Perera'));
    await tester.pumpAndSettle();

    expect(find.text(routeMarker(Routes.settings)), findsOneWidget);
  });

  testWidgets('Sign out asks for confirmation; cancel stays on the tab', (tester) async {
    await pumpMore(tester);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsNothing);
    expect(find.text('Crop Prices'), findsOneWidget);
  });

  testWidgets('localizes the district and type in the header', (tester) async {
    await pumpMore(tester, locale: const Locale('ta'));

    expect(find.text('கண்டி · விவசாயி'), findsOneWidget);
    expect(find.text('பயிர் விலைகள்'), findsOneWidget);
  });

  testWidgets('a profile without a name, district or type still renders', (tester) async {
    await pumpMore(tester, profile: const AppUser(id: 'user-2'));

    expect(find.text('Your profile'), findsOneWidget);
    expect(find.text('View and edit your profile'), findsOneWidget);
  });

  for (final code in ['si', 'ta']) {
    testWidgets('no overflow in $code at 320 dp and text scale 1.3', (tester) async {
      await pumpMore(
        tester,
        locale: Locale(code),
        textScale: 1.3,
        surfaceSize: const Size(320, 2400),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
