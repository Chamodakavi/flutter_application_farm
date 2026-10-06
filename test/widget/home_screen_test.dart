import 'package:farmfriend/core/config/app_config_provider.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/router/routes.dart';
import 'package:farmfriend/features/cart/presentation/controllers/cart_controller.dart';
import 'package:farmfriend/features/home/presentation/home_screen.dart';
import 'package:farmfriend/features/marketplace/presentation/controllers/products_controller.dart';
import 'package:farmfriend/features/news/domain/news.dart';
import 'package:farmfriend/features/news/presentation/controllers/news_controller.dart';
import 'package:farmfriend/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:farmfriend/features/prices/domain/price_overview.dart';
import 'package:farmfriend/features/prices/presentation/controllers/prices_controller.dart';
import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:farmfriend/features/registration/domain/bucket_status.dart';
import 'package:farmfriend/features/registration/domain/farmer_registration.dart';
import 'package:farmfriend/features/registration/presentation/controllers/bucket_controller.dart';
import 'package:farmfriend/features/registration/presentation/controllers/register_controller.dart';
import 'package:farmfriend/features/weather/domain/weather.dart';
import 'package:farmfriend/features/weather/presentation/controllers/weather_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/overflow_probe.dart';
import '../helpers/test_app.dart';

class _Profile extends ProfileController {
  _Profile(this.user);

  final AppUser user;

  @override
  Future<AppUser?> build() async => user;
}

/// The weather request fails in every test: the dashboard must cope.
class _FailingWeather extends WeatherController {
  @override
  Future<Weather> build() async => throw const AppException.network();
}

const _farmer = AppUser(id: 'u1', name: 'Nimal', phone: '+94771234567', district: 'Kandy');

List<Override> homeOverrides({
  AppUser user = _farmer,
  bool bucketFails = false,
}) => [
  profileProvider.overrideWith(() => _Profile(user)),
  weatherProvider.overrideWith(_FailingWeather.new),
  cartCountProvider.overrideWithValue(2),
  unreadNotificationCountProvider.overrideWithValue(0),
  updateAvailableProvider.overrideWithValue(false),
  bucketStatusProvider.overrideWith(
    (ref) async => bucketFails
        ? throw const AppException.network()
        : const [
            BucketStatus(cropName: 'CARROT', limitMt: 100, filledMt: 90, remainingMt: 10),
            BucketStatus(cropName: 'BEANS', limitMt: 200, filledMt: 40, remainingMt: 160),
          ],
  ),
  myRegistrationsProvider.overrideWith(
    (ref) async => [
      FarmerRegistration(id: 1, cropName: 'CARROT', amountMt: 66, registeredAt: DateTime(2026, 9, 1)),
      FarmerRegistration(id: 2, cropName: 'BEANS', amountMt: 4.5, registeredAt: DateTime(2026, 8, 1)),
    ],
  ),
  myCropRegistrationsProvider.overrideWith(
    (ref) async => const [CropRegistration(id: 9, cropName: 'BEANS', status: 'Pending')],
  ),
  priceOverviewProvider.overrideWith(
    (ref) async => const [
      PriceOverview(cropName: 'TOMATOES', wholesalePrice: 245, prevPrice: 226.4),
    ],
  ),
  inStockProductCountProvider.overrideWith((ref) async => 12),
  recentNewsCountProvider.overrideWith((ref) async => 3),
  latestNewsProvider.overrideWith(
    (ref) async => [
      News(id: 7, title: 'Leaf curl alert in Nuwara Eliya', type: 'Alert', createdAt: DateTime(2026, 10, 1)),
    ],
  ),
];

/// The dashboard's vertical list (the strips inside it scroll sideways).
final page = find.byType(Scrollable).first;

void main() {
  testWidgets('dashboard shows the greeting, stats and summaries', (tester) async {
    await pumpApp(tester, const HomeScreen(), overrides: homeOverrides());
    await tester.pumpAndSettle();

    expect(find.text('Welcome back, Nimal'), findsOneWidget);
    expect(find.text('Total: 70.5 MT'), findsOneWidget); // 66 + 4.5
    expect(find.text('12'), findsOneWidget); // products in stock
    expect(find.text('3'), findsOneWidget); // recent news

    await tester.scrollUntilVisible(find.text('90% full'), 300, scrollable: page);
    expect(find.text('Almost full'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Rs. 245/kg'), 300, scrollable: page);
    await tester.scrollUntilVisible(find.text('66 MT registered'), 300, scrollable: page);
    await tester.pumpAndSettle(); // the card loads its statuses once it is built
    // crop_registrations drives the badge; without a row the quota is Approved.
    expect(find.text('Approved'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Leaf curl alert in Nuwara Eliya'), 300, scrollable: page);
    expect(find.textContaining('1 Oct 2026'), findsOneWidget);
  });

  testWidgets('one failing card does not blank the dashboard', (tester) async {
    await pumpApp(tester, const HomeScreen(), overrides: homeOverrides(bucketFails: true));
    await tester.pumpAndSettle();

    // Weather and the crop outlook failed; everything else still renders.
    expect(find.text('Welcome back, Nimal'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Retry'), 300, scrollable: page);
    await tester.scrollUntilVisible(find.text('66 MT registered'), 300, scrollable: page);
  });

  testWidgets('hero and stat cards navigate', (tester) async {
    await pumpApp(tester, const HomeScreen(), overrides: homeOverrides());
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Registered Crops'));
    await tester.pumpAndSettle();
    expect(find.text(routeMarker(Routes.myQuotas)), findsOneWidget);
  });

  testWidgets('administrators see the web-panel banner (spec 11.28)', (tester) async {
    await pumpApp(
      tester,
      const HomeScreen(),
      overrides: homeOverrides(user: _farmer.copyWith(role: 'admin')),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('You are an administrator'), findsOneWidget);
  });

  testWidgets('TC_L10N_01: no overflow in Sinhala and Tamil at text scale 1.3', (tester) async {
    for (final locale in const [Locale('si'), Locale('ta')]) {
      final problems = await collectLayoutErrors(() async {
        await pumpApp(
          tester,
          const HomeScreen(),
          overrides: homeOverrides(),
          locale: locale,
          textScale: 1.3,
          surfaceSize: const Size(320, 640),
        );
        await tester.pumpAndSettle();
        for (var i = 0; i < 12; i++) {
          await tester.drag(page, const Offset(0, -300));
          await tester.pumpAndSettle();
        }
      });
      expect(problems, isEmpty, reason: '$locale');
    }
  });
}
