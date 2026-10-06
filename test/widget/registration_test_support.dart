// Overrides shared by the registration and prices widget tests.
import 'package:farmfriend/core/analytics/analytics_service.dart';
import 'package:farmfriend/core/config/app_config.dart';
import 'package:farmfriend/core/config/app_config_provider.dart';
import 'package:farmfriend/core/notifications/push_service.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/cart/presentation/controllers/cart_controller.dart';
import 'package:farmfriend/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:farmfriend/features/prices/data/price_repository.dart';
import 'package:farmfriend/features/prices/presentation/controllers/prices_controller.dart';
import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:farmfriend/features/registration/data/registration_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../unit/registration_fakes.dart';

/// Tears the current screen (and its ProviderScope) down, so the next
/// `pumpApp` in the same test starts from scratch.
Future<void> unmount(WidgetTester tester) => tester.pumpWidget(const SizedBox());

/// Scrolls the page until [finder] is built and fully on screen.
Future<void> reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 200, scrollable: find.byType(Scrollable).first);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

/// "Today" in every widget test of the slice.
final testNow = DateTime(2026, 10, 15);

class FakeProfile extends ProfileController {
  @override
  Future<AppUser?> build() async =>
      const AppUser(id: 'u1', name: 'Nimal', surname: 'Perera', phone: '0771234567');
}

/// Counts permission prompts instead of touching Firebase.
class FakePushService extends PushService {
  FakePushService(super.ref);

  int prompts = 0;

  @override
  Future<bool> requestPermission({bool force = false}) async {
    prompts++;
    return false;
  }
}

/// Everything a screen of the slice reads, backed by fakes.
class SliceHarness {
  SliceHarness({FakeRegistrationRepository? registration, FakePriceRepository? prices})
    : registration = registration ?? FakeRegistrationRepository(),
      prices = prices ?? FakePriceRepository();

  final FakeRegistrationRepository registration;
  final FakePriceRepository prices;
  FakeAnalytics? analytics;
  FakePushService? push;

  List<Override> get overrides => [
    registrationRepositoryProvider.overrideWithValue(registration),
    priceRepositoryProvider.overrideWithValue(prices),
    priceClockProvider.overrideWithValue(() => testNow),
    currentUserIdProvider.overrideWithValue('u1'),
    appConfigOrDefaultProvider.overrideWithValue(const AppConfig()),
    analyticsProvider.overrideWith((ref) => analytics = FakeAnalytics(ref)),
    pushServiceProvider.overrideWith((ref) => push = FakePushService(ref)),
    profileProvider.overrideWith(FakeProfile.new),
    cartCountProvider.overrideWithValue(0),
    unreadNotificationCountProvider.overrideWithValue(0),
  ];
}
