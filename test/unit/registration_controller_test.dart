import 'package:farmfriend/core/analytics/analytics_service.dart';
import 'package:farmfriend/core/config/app_config.dart';
import 'package:farmfriend/core/config/app_config_provider.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/registration/data/registration_repository.dart';
import 'package:farmfriend/features/registration/domain/bucket_status.dart';
import 'package:farmfriend/features/registration/domain/farmer_registration.dart';
import 'package:farmfriend/features/registration/domain/register_result.dart';
import 'package:farmfriend/features/registration/presentation/controllers/bucket_controller.dart';
import 'package:farmfriend/features/registration/presentation/controllers/register_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'registration_fakes.dart';

void main() {
  late FakeRegistrationRepository repo;
  late FakeAnalytics analytics;

  ProviderContainer container({String? uid = 'u1', AppConfig config = const AppConfig()}) {
    final c = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        registrationRepositoryProvider.overrideWithValue(repo),
        currentUserIdProvider.overrideWithValue(uid),
        appConfigOrDefaultProvider.overrideWithValue(config),
        analyticsProvider.overrideWith((ref) => analytics = FakeAnalytics(ref)),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() {
    repo = FakeRegistrationRepository(
      buckets: [bucket('CARROT', filled: 960), bucket('BEANS', filled: 500, fairPrice: 120)],
      registrations: [
        FarmerRegistration(id: 1, cropName: 'CARROT', amountMt: 12, registeredAt: DateTime(2026, 10)),
      ],
    );
  });

  test('bucketStatusProvider reads the bucket through the repository', () async {
    final c = container();
    final buckets = await c.read(bucketStatusProvider.future);
    expect(buckets.map((b) => b.cropName), ['CARROT', 'BEANS']);
    expect(c.read(bucketForCropProvider('carrot'))?.remainingMt, 40);
    expect(c.read(bucketForCropProvider('TOMATOES')), isNull);
  });

  test('the first read may use the cache; invalidating always asks the server', () async {
    final c = container();
    await c.read(bucketStatusProvider.future);
    c.invalidate(bucketStatusProvider);
    await c.read(bucketStatusProvider.future);
    expect(repo.bucketForced, [false, true]);
  });

  test('thresholds come from app_config', () {
    final c = container(
      config: const AppConfig(surplusMediumRatio: 0.4, surplusHighRatio: 0.45),
    );
    final thresholds = c.read(surplusThresholdsProvider);
    expect(thresholds.levelOf(bucket('BEANS', filled: 500)), SurplusLevel.high);
    expect(bucket('BEANS', filled: 500).level, SurplusLevel.low);
  });

  test('own registrations are empty while signed out', () async {
    final c = container(uid: null);
    expect(await c.read(myRegistrationsProvider.future), isEmpty);
    expect(await c.read(myCropRegistrationsProvider.future), isEmpty);
    expect(repo.registrationCalls, 0);
  });

  test('crop_registrations statuses are keyed by crop, newest first', () async {
    repo.cropRegistrations = [
      const CropRegistration(id: 2, cropName: 'Carrot', status: 'Approved'),
      const CropRegistration(id: 1, cropName: 'CARROT', status: 'Pending'),
      const CropRegistration(id: 3, cropName: 'BEANS'),
    ];
    final c = container();
    await c.read(myCropRegistrationsProvider.future);
    expect(c.read(cropRegistrationStatusProvider), {'CARROT': 'Approved'});
  });

  group('RegisterController', () {
    test('preCheck warns from the cached bucket only', () async {
      final c = container();
      final controller = c.read(registerControllerProvider.notifier);
      // Nothing cached yet: no instant answer.
      expect(controller.preCheck('CARROT', 100), isNull);
      await c.read(bucketStatusProvider.future);
      expect(controller.preCheck('CARROT', 40), isNull);
      expect(controller.preCheck('CARROT', 100)?.remainingMt, 40);
    });

    test('success refreshes the bucket and own quotas and tracks the events', () async {
      final c = container();
      await c.read(bucketStatusProvider.future);
      await c.read(myRegistrationsProvider.future);
      repo.result = const RegisterResult.success(registrationId: 7, cropName: 'BEANS');

      final result = await c.read(registerControllerProvider.notifier).submit('BEANS', 25);

      expect(result, isA<RegisterSuccess>());
      expect(repo.registerCalls, [('BEANS', 25.0)]);
      expect(c.read(registerControllerProvider), isFalse);

      await c.read(bucketStatusProvider.future);
      await c.read(myRegistrationsProvider.future);
      expect(repo.bucketCalls, 2);
      expect(repo.registrationCalls, 2);

      expect(analytics.events.map((e) => e.$1), [
        AnalyticsEvents.registerCheck,
        AnalyticsEvents.registerSuccess,
      ]);
      expect(analytics.propsOf(AnalyticsEvents.registerSuccess)?['crop'], 'BEANS');
    });

    test('surplus tracks the crop and fill % and reloads the bucket', () async {
      final c = container();
      await c.read(bucketStatusProvider.future);
      repo.result = const RegisterResult.surplus(
        cropName: 'CARROT',
        limitMt: 1000,
        filledMt: 960,
        remainingMt: 40,
      );

      final result = await c.read(registerControllerProvider.notifier).submit('CARROT', 100);

      expect(result, isA<RegisterSurplus>());
      expect(analytics.propsOf(AnalyticsEvents.registerSurplus), {'crop': 'CARROT', 'fill_pct': 96});
      await c.read(bucketStatusProvider.future);
      expect(repo.bucketCalls, 2);
    });

    test('a failed call clears the busy flag and rethrows', () async {
      final c = container();
      repo.result = const AppException.network();
      final controller = c.read(registerControllerProvider.notifier);
      await expectLater(controller.submit('CARROT', 10), throwsA(isA<NetworkException>()));
      expect(c.read(registerControllerProvider), isFalse);
    });

    test('choosing an alternative is tracked without personal data', () {
      final c = container();
      c.read(registerControllerProvider.notifier).alternativeChosen(from: 'CARROT', to: 'BEANS');
      expect(analytics.propsOf(AnalyticsEvents.altCropChosen), {'from': 'CARROT', 'to': 'BEANS'});
    });
  });
}
