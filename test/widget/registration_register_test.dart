import 'dart:async';

import 'package:farmfriend/core/analytics/analytics_service.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/features/registration/domain/farmer_registration.dart';
import 'package:farmfriend/features/registration/domain/register_result.dart';
import 'package:farmfriend/features/registration/presentation/my_quotas_screen.dart';
import 'package:farmfriend/features/registration/presentation/register_quota_screen.dart';
import 'package:farmfriend/features/registration/presentation/widgets/alternative_crop_tile.dart';
import 'package:farmfriend/features/registration/presentation/widgets/surplus_warning_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/registration_fakes.dart';
import 'registration_test_support.dart';

const _surplus = RegisterSurplus(
  cropName: 'CARROT',
  limitMt: 1000,
  filledMt: 960,
  remainingMt: 40,
  alternatives: [
    AlternativeCrop(cropName: 'BEANS', remainingMt: 500, fairPrice: 120),
    AlternativeCrop(cropName: 'LEEKS', remainingMt: 75.5),
  ],
);

void main() {
  group('SurplusWarningSheet (TC_REG_02)', () {
    Future<void> pumpSheet(
      WidgetTester tester, {
      RegisterSurplus surplus = _surplus,
      bool confirming = false,
      ValueChanged<AlternativeCrop>? onChoose,
      ValueChanged<double>? onRegisterRemaining,
    }) => pumpApp(
      tester,
      Scaffold(
        body: SurplusWarningSheet(
          surplus: surplus,
          cropName: 'CARROT',
          requestedMt: 100,
          confirming: confirming,
          onChoose: onChoose ?? (_) {},
          onRegisterRemaining: onRegisterRemaining ?? (_) {},
        ),
      ),
    );

    testWidgets('shows the warning, at least one alternative and "Register remaining"', (
      tester,
    ) async {
      AlternativeCrop? chosen;
      double? remainder;
      await pumpSheet(
        tester,
        onChoose: (c) => chosen = c,
        onRegisterRemaining: (a) => remainder = a,
      );
      await tester.pumpAndSettle();

      expect(find.text('Quota exceeded for Carrot'), findsOneWidget);
      expect(find.textContaining('Only 40 MT left'), findsOneWidget);
      expect(find.text('960 of 1,000 MT registered'), findsOneWidget);
      expect(find.text('96%'), findsOneWidget);

      expect(find.byType(AlternativeCropTile), findsNWidgets(2));
      expect(find.text('Beans'), findsOneWidget);
      expect(find.text('500 MT of room · Fair price Rs. 120/kg'), findsOneWidget);
      expect(find.text('75.5 MT of room'), findsOneWidget);
      expect(find.text('Register remaining 40 MT'), findsOneWidget);

      await tester.ensureVisible(find.text('Choose').first);
      await tester.tap(find.text('Choose').first);
      expect(chosen?.cropName, 'BEANS');

      await tester.ensureVisible(find.text('Register remaining 40 MT'));
      await tester.tap(find.text('Register remaining 40 MT'));
      expect(remainder, 40);
    });

    testWidgets('a full quota offers alternatives but nothing to register', (tester) async {
      await pumpSheet(
        tester,
        surplus: const RegisterSurplus(
          cropName: 'CARROT',
          limitMt: 1000,
          filledMt: 1000,
          alternatives: [AlternativeCrop(cropName: 'BEANS', remainingMt: 500)],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('This quota is full'), findsOneWidget);
      expect(find.text('Choose'), findsOneWidget);
      expect(find.textContaining('Register remaining'), findsNothing);
    });

    testWidgets('says so when no other crop has room', (tester) async {
      await pumpSheet(
        tester,
        surplus: const RegisterSurplus(limitMt: 1000, filledMt: 990, remainingMt: 10),
      );
      await tester.pumpAndSettle();
      expect(find.text('No other crop has room right now.'), findsOneWidget);
      expect(find.text('Register remaining 10 MT'), findsOneWidget);
    });

    testWidgets('actions are disabled while the server is confirming', (tester) async {
      AlternativeCrop? chosen;
      double? remainder;
      await pumpSheet(
        tester,
        confirming: true,
        onChoose: (c) => chosen = c,
        onRegisterRemaining: (a) => remainder = a,
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining('Confirming with the server'), findsOneWidget);
      await tester.ensureVisible(find.text('Choose').first);
      await tester.tap(find.text('Choose').first);
      await tester.ensureVisible(find.text('Register remaining 40 MT'));
      await tester.tap(find.text('Register remaining 40 MT'));
      expect(chosen, isNull);
      expect(remainder, isNull);
    });
  });

  group('RegisterQuotaScreen', () {
    late SliceHarness harness;

    setUp(() {
      harness = SliceHarness(
        registration: FakeRegistrationRepository(
          buckets: [
            bucket('CARROT', filled: 960, fairPrice: 140, farmers: 12, year: 2027, month: 3),
            bucket('BEANS', filled: 500, fairPrice: 120),
            bucket('CABBAGE', filled: 1000),
          ],
          registrations: [
            FarmerRegistration(
              id: 1,
              cropName: 'LEEKS',
              amountMt: 66,
              registeredAt: DateTime(2026, 9, 20),
            ),
          ],
        ),
        prices: FakePriceRepository(
          forecastRows: [forecast('CARROT', 2027, 3, wholesale: 180, cost: 100)],
        ),
      );
    });

    Future<void> pump(WidgetTester tester, {String? crop, double? amount}) async {
      await pumpApp(
        tester,
        RegisterQuotaScreen(initialCrop: crop, initialAmount: amount),
        overrides: harness.overrides,
      );
      await tester.pumpAndSettle();
    }

    Future<void> tapSubmit(WidgetTester tester) async {
      await tester.ensureVisible(find.text('Check & Register'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check & Register'));
    }

    testWidgets('shows the form, live crop context and own quotas', (tester) async {
      await pump(tester, crop: 'CARROT', amount: 8.09);

      expect(find.text('Register Harvest Quota'), findsOneWidget);
      expect(find.text('Farmer Authenticated'), findsOneWidget);
      expect(find.text('Almost full'), findsOneWidget);
      expect(find.text('Remaining capacity: 40 MT'), findsOneWidget);
      expect(find.text('12 farmers registered'), findsOneWidget);
      expect(find.text('Model forecast for March 2027'), findsOneWidget);
      expect(find.text("Don't know the tonnage?"), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '8.09'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Leeks'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('My Registered Quotas'), findsOneWidget);
      expect(find.text('1 Record'), findsOneWidget);
      expect(find.text('Leeks'), findsOneWidget);
      expect(harness.registration.watching, isTrue);
    });

    testWidgets('validates the crop and the amount before calling the server', (tester) async {
      await pump(tester);
      await tapSubmit(tester);
      await tester.pumpAndSettle();
      expect(find.text('Please select a crop'), findsOneWidget);
      expect(find.text('This field is required'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '20000');
      await tapSubmit(tester);
      await tester.pumpAndSettle();
      expect(find.text('The amount cannot be more than 10,000 MT'), findsOneWidget);
      expect(harness.registration.registerCalls, isEmpty);
    });

    testWidgets('the crop picker lists roomy crops first and disables full ones', (tester) async {
      await pump(tester);
      await tester.tap(find.byKey(const Key('register-crop-field')));
      await tester.pumpAndSettle();

      expect(find.text('Search crops'), findsOneWidget);
      final beans = tester.getTopLeft(find.text('Beans')).dy;
      final carrot = tester.getTopLeft(find.text('Carrot')).dy;
      final cabbage = tester.getTopLeft(find.text('Cabbage')).dy;
      expect(beans < carrot && carrot < cabbage, isTrue);

      // Full: tapping does nothing.
      await tester.tap(find.text('Cabbage'));
      await tester.pumpAndSettle();
      expect(find.text('Search crops'), findsOneWidget);

      // Sinhala search finds the crop in an English session.
      await tester.enterText(find.widgetWithText(TextField, 'Search crops'), 'බෝංචි');
      await tester.pumpAndSettle();
      expect(find.text('Carrot'), findsNothing);
      await tester.tap(find.text('Beans'));
      await tester.pumpAndSettle();
      expect(find.text('Remaining capacity: 500 MT'), findsOneWidget);
    });

    testWidgets('TC_REG_02: instant warning from the cache, confirmed by the RPC', (tester) async {
      harness.registration
        ..gate = Completer<void>()
        ..result = _surplus;
      await pump(tester, crop: 'CARROT', amount: 100);
      await tapSubmit(tester);
      await tester.pump(const Duration(milliseconds: 600));

      // Pre-check: the sheet is already up while the RPC is still running.
      expect(find.text('Quota exceeded for Carrot'), findsOneWidget);
      expect(find.textContaining('Confirming with the server'), findsOneWidget);
      expect(harness.registration.registerCalls, [('CARROT', 100.0)]);

      harness.registration.gate!.complete();
      await tester.pumpAndSettle();
      expect(find.textContaining('Confirming with the server'), findsNothing);
      expect(find.byType(AlternativeCropTile), findsNWidgets(2));
      expect(find.text('Register remaining 40 MT'), findsOneWidget);
      expect(harness.analytics!.propsOf(AnalyticsEvents.registerSurplus), {
        'crop': 'CARROT',
        'fill_pct': 96,
      });

      // "Choose" reselects the crop and keeps the amount.
      await tester.ensureVisible(find.text('Choose').first);
      await tester.tap(find.text('Choose').first);
      await tester.pumpAndSettle();
      expect(find.text('Quota exceeded for Carrot'), findsNothing);
      expect(find.text('Remaining capacity: 500 MT'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '100'), findsOneWidget);
      expect(harness.analytics!.propsOf(AnalyticsEvents.altCropChosen), {
        'from': 'CARROT',
        'to': 'BEANS',
      });
      expect(harness.registration.registerCalls, hasLength(1));
    });

    testWidgets('"Register remaining" registers what still fits', (tester) async {
      harness.registration.result = _surplus;
      await pump(tester, crop: 'CARROT', amount: 100);
      await tapSubmit(tester);
      await tester.pumpAndSettle();

      harness.registration.result = const RegisterResult.success(cropName: 'CARROT');
      await tester.ensureVisible(find.text('Register remaining 40 MT'));
      await tester.tap(find.text('Register remaining 40 MT'));
      await tester.pumpAndSettle();

      expect(harness.registration.registerCalls, [('CARROT', 100.0), ('CARROT', 40.0)]);
      expect(find.text('Quota registered'), findsOneWidget);
      expect(find.text('Registered 40 MT of Carrot. Your quota is locked.'), findsOneWidget);
    });

    testWidgets('TC_REG_01: success locks the quota, refreshes and offers My Quotas', (
      tester,
    ) async {
      await pump(tester, crop: 'BEANS', amount: 25);
      final bucketCalls = harness.registration.bucketCalls;
      final quotaCalls = harness.registration.registrationCalls;

      await tapSubmit(tester);
      await tester.pumpAndSettle();

      expect(harness.registration.registerCalls, [('BEANS', 25.0)]);
      expect(find.text('Registered 25 MT of Beans. Your quota is locked.'), findsOneWidget);
      expect(harness.registration.bucketCalls, greaterThan(bucketCalls));
      expect(harness.registration.registrationCalls, greaterThan(quotaCalls));
      expect(harness.analytics!.propsOf(AnalyticsEvents.registerSuccess)?['crop'], 'BEANS');

      await tester.tap(find.text('View my quotas'));
      await tester.pumpAndSettle();
      // The push permission is asked at this meaningful moment, once.
      expect(harness.push!.prompts, 1);
      expect(find.text(routeMarker('/register/my-quotas')), findsOneWidget);
    });

    testWidgets('no_target, invalid_amount and an unknown status are explained', (tester) async {
      await pump(tester, crop: 'BEANS', amount: 25);

      harness.registration.result = const RegisterResult.noTarget();
      await tapSubmit(tester);
      await tester.pumpAndSettle();
      expect(
        find.text('No active national target for this crop. Contact admin.'),
        findsOneWidget,
      );

      harness.registration.result = const RegisterResult.invalid();
      await tapSubmit(tester);
      await tester.pumpAndSettle();
      expect(find.textContaining('This amount was not accepted'), findsOneWidget);
      expect(find.textContaining('No active national target for this crop'), findsNothing);

      harness.registration.result = const RegisterResult.unknown();
      await tapSubmit(tester);
      await tester.pumpAndSettle();
      expect(find.textContaining('We could not confirm this registration'), findsOneWidget);
      expect(harness.push?.prompts ?? 0, 0);
    });

    testWidgets('a network failure shows the localized error and keeps the form', (tester) async {
      harness.registration.result = const AppException.network();
      await pump(tester, crop: 'BEANS', amount: 25);
      await tapSubmit(tester);
      await tester.pumpAndSettle();
      expect(find.textContaining('No internet connection'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '25'), findsOneWidget);
    });

    testWidgets('land size → tonnes fills the amount (spec §13.8)', (tester) async {
      await pump(tester, crop: 'CARROT');
      await tester.ensureVisible(find.text("Don't know the tonnage?"));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Don't know the tonnage?"));
      await tester.pumpAndSettle();

      expect(find.text('Estimate from land size'), findsOneWidget);
      await tester.enterText(find.widgetWithText(TextFormField, '').last, '1');
      await tester.pumpAndSettle();
      // 1 acre × 20 MT/ha → 8.1 MT.
      await tester.tap(find.text('Use 8.1 MT'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextFormField, '8.1'), findsOneWidget);
    });

    testWidgets('the helper is hidden when the model has no row for the target month', (
      tester,
    ) async {
      await pump(tester, crop: 'BEANS');
      expect(find.text("Don't know the tonnage?"), findsNothing);
    });
  });

  group('MyQuotasScreen (spec §11.11)', () {
    testWidgets('lists own quotas with the total and a crop_registrations status', (tester) async {
      final harness = SliceHarness(
        registration: FakeRegistrationRepository(
          registrations: [
            FarmerRegistration(id: 2, cropName: 'CARROT', amountMt: 12.5, registeredAt: DateTime(2026, 10, 2)),
            FarmerRegistration(id: 1, cropName: 'LEEKS', amountMt: 66, registeredAt: DateTime(2026, 9, 20)),
          ],
          cropRegistrations: const [CropRegistration(id: 9, cropName: 'CARROT', status: 'Approved')],
        ),
      );
      await pumpApp(tester, const MyQuotasScreen(), overrides: harness.overrides);
      await tester.pumpAndSettle();

      expect(find.text('78.5 MT'), findsOneWidget);
      expect(find.text('2 Records'), findsOneWidget);
      expect(find.text('Carrot'), findsOneWidget);
      expect(find.text('2 Oct 2026'), findsOneWidget);
      expect(find.text('Approved'), findsOneWidget);

      await tester.ensureVisible(find.text('Request a change'));
      await tester.tap(find.text('Request a change'));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker('/support?subject=Quota+change+request')), findsOneWidget);
    });

    testWidgets('empty state leads to the Register tab', (tester) async {
      final harness = SliceHarness();
      await pumpApp(tester, const MyQuotasScreen(), overrides: harness.overrides);
      await tester.pumpAndSettle();
      expect(find.text('No quotas registered yet'), findsOneWidget);
      await tester.tap(find.text('Register a crop'));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker('/register')), findsOneWidget);
    });
  });
}
