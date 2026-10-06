// TC_L10N_01 for the registration and prices slice: every screen must lay out
// without overflow in Sinhala and Tamil at text scale 1.3 on a 320×640 phone.
import 'package:farmfriend/features/prices/domain/price_series.dart';
import 'package:farmfriend/features/prices/presentation/price_detail_screen.dart';
import 'package:farmfriend/features/prices/presentation/prices_screen.dart';
import 'package:farmfriend/features/prices/presentation/profit_planner_screen.dart';
import 'package:farmfriend/features/registration/domain/farmer_registration.dart';
import 'package:farmfriend/features/registration/domain/register_result.dart';
import 'package:farmfriend/features/registration/presentation/crop_outlook_detail_screen.dart';
import 'package:farmfriend/features/registration/presentation/crop_outlook_screen.dart';
import 'package:farmfriend/features/registration/presentation/my_quotas_screen.dart';
import 'package:farmfriend/features/registration/presentation/register_quota_screen.dart';
import 'package:farmfriend/features/registration/presentation/widgets/crop_picker_sheet.dart';
import 'package:farmfriend/features/registration/presentation/widgets/land_to_tonnes_sheet.dart';
import 'package:farmfriend/features/registration/presentation/widgets/surplus_warning_sheet.dart';
import 'package:farmfriend/features/registration/domain/bucket_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/overflow_probe.dart';
import '../helpers/test_app.dart';
import '../unit/registration_fakes.dart';
import 'registration_test_support.dart';

const _locales = [Locale('si'), Locale('ta')];
const _small = Size(320, 640);

SliceHarness _harness() {
  final months = [for (var i = 0; i < 12; i++) addMonths(DateTime(2026, 10), i)];
  return SliceHarness(
    registration: FakeRegistrationRepository(
      buckets: [
        bucket(
          'ASH PLANTAINS',
          limit: 12500.75,
          filled: 11250.25,
          fairPrice: 1140.5,
          wholesalePrice: 1376.25,
          farmers: 1234,
          year: 2027,
          month: 3,
          harvestDate: '2027-03-15',
          plantingDate: 'Mid December (Maha season)',
        ),
        bucket('BITTER GOURD', filled: 500, fairPrice: 220, wholesalePrice: 180),
        bucket('CABBAGE', filled: 1000, fairPrice: 90),
        bucket('CARROT', limit: 400, filled: 280, fairPrice: 150),
      ],
      registrations: [
        for (var i = 0; i < 7; i++)
          FarmerRegistration(
            id: i,
            cropName: i.isEven ? 'ASH PLANTAINS' : 'BITTER GOURD',
            amountMt: 1234.56 + i,
            registeredAt: DateTime(2026, 9, 20 + i),
          ),
      ],
      cropRegistrations: const [
        CropRegistration(id: 1, cropName: 'ASH PLANTAINS', status: 'Approved'),
        CropRegistration(id: 2, cropName: 'BITTER GOURD', status: 'Pending'),
      ],
    ),
    prices: FakePriceRepository(
      forecastRows: [
        for (final crop in ['ASH PLANTAINS', 'BITTER GOURD', 'CARROT', 'CABBAGE'])
          for (final (i, m) in months.indexed)
            // Bitter gourd has no row for this month → "Forecast pending".
            if (!(crop == 'BITTER GOURD' && i == 0))
              forecast(
                crop,
                m.year,
                m.month,
                wholesale: 1180.5 + i * 13 + crop.length,
                cost: crop == 'CABBAGE' ? 1400 : 900.25,
                retail: 1500,
                plantingYear: addMonths(m, -3).year,
                plantingMonth: addMonths(m, -3).month,
                generatedAt: DateTime(2026, 7, 1), // stale chip too
              ),
      ],
      historyRows: {
        for (final crop in ['ASH PLANTAINS', 'BITTER GOURD', 'CARROT', 'CABBAGE'])
          crop: [
            for (var i = 14; i >= 1; i--)
              PricePoint(addMonths(DateTime(2026, 10), -i), 1100.0 + i * 7),
          ],
      },
    ),
  );
}

/// Scrolls the first vertical list to its end, one screen at a time.
Future<void> _scrollThrough(WidgetTester tester, {int steps = 14}) async {
  final list = find.byType(ListView).first;
  for (var i = 0; i < steps; i++) {
    await tester.drag(list, const Offset(0, -300), warnIfMissed: false);
    await tester.pumpAndSettle();
  }
}

void main() {
  Future<void> expectNoOverflow(
    WidgetTester tester,
    Widget screen, {
    SliceHarness? harness,
    Future<void> Function()? interact,
  }) async {
    for (final locale in _locales) {
      final problems = await collectLayoutErrors(() async {
        await pumpApp(
          tester,
          screen,
          overrides: (harness ?? _harness()).overrides,
          locale: locale,
          textScale: 1.3,
          surfaceSize: _small,
        );
        await tester.pumpAndSettle();
        await interact?.call();
        await _scrollThrough(tester);
      });
      expect(problems, isEmpty, reason: '$locale');
      await unmount(tester);
    }
  }

  testWidgets('RegisterQuotaScreen', (tester) async {
    await expectNoOverflow(
      tester,
      const RegisterQuotaScreen(initialCrop: 'ASH PLANTAINS', initialAmount: 1234.56),
    );
  });

  testWidgets('RegisterQuotaScreen with validation errors and no crop', (tester) async {
    await expectNoOverflow(
      tester,
      const RegisterQuotaScreen(),
      interact: () async {
        final submit = find.byIcon(Icons.verified_outlined);
        await reveal(tester, submit);
        await tester.tap(submit);
        await tester.pumpAndSettle();
      },
    );
  });

  testWidgets('CropOutlookScreen', (tester) async {
    await expectNoOverflow(tester, const CropOutlookScreen());
  });

  testWidgets('CropOutlookDetailScreen', (tester) async {
    await expectNoOverflow(tester, const CropOutlookDetailScreen(cropName: 'ASH PLANTAINS'));
    await expectNoOverflow(tester, const CropOutlookDetailScreen(cropName: 'CABBAGE'));
  });

  testWidgets('MyQuotasScreen', (tester) async {
    await expectNoOverflow(tester, const MyQuotasScreen());
  });

  testWidgets('PricesScreen', (tester) async {
    await expectNoOverflow(tester, const PricesScreen());
  });

  testWidgets('PriceDetailScreen', (tester) async {
    await expectNoOverflow(tester, const PriceDetailScreen(cropName: 'ASH PLANTAINS'));
    await expectNoOverflow(tester, const PriceDetailScreen(cropName: 'BITTER GOURD'));
  });

  testWidgets('ProfitPlannerScreen with a plan and a comparison', (tester) async {
    await expectNoOverflow(
      tester,
      const ProfitPlannerScreen(initialCrop: 'ASH PLANTAINS'),
      interact: () async {
        await tester.enterText(find.byType(TextFormField), '12.5');
        await tester.pumpAndSettle();
        for (var i = 0; i < 2; i++) {
          final add = find.byIcon(Icons.add_rounded);
          await reveal(tester, add);
          await tester.tap(add);
          await tester.pumpAndSettle();
          await tester.tap(find.byType(ListTile).first);
          await tester.pumpAndSettle();
        }
        expect(find.byType(Table), findsOneWidget);
        await tester.drag(find.byType(ListView).first, const Offset(0, 3000));
        await tester.pumpAndSettle();
      },
    );
  });

  testWidgets('ProfitPlannerScreen before a crop is chosen', (tester) async {
    await expectNoOverflow(tester, const ProfitPlannerScreen());
  });

  testWidgets('sheets: surplus warning, crop picker, land → tonnes', (tester) async {
    final harness = _harness();
    final buckets = harness.registration.buckets;
    const surplus = RegisterSurplus(
      cropName: 'ASH PLANTAINS',
      limitMt: 12500.75,
      filledMt: 11250.25,
      remainingMt: 1250.5,
      alternatives: [
        AlternativeCrop(cropName: 'BITTER GOURD', remainingMt: 1500.25, fairPrice: 1220.5),
        AlternativeCrop(cropName: 'CARROT', remainingMt: 120),
      ],
    );
    final sheets = <Widget>[
      const SurplusWarningSheet(
        surplus: surplus,
        cropName: 'ASH PLANTAINS',
        requestedMt: 2500.75,
        confirming: true,
      ),
      CropPickerSheet(buckets: buckets, thresholds: const SurplusThresholds(), selected: 'CARROT'),
      LandToTonnesSheet(forecast: harness.prices.forecastRows.first),
    ];
    for (final sheet in sheets) {
      for (final locale in _locales) {
        final problems = await collectLayoutErrors(() async {
          await pumpApp(
            tester,
            Scaffold(body: sheet),
            overrides: harness.overrides,
            locale: locale,
            textScale: 1.3,
            surfaceSize: _small,
          );
          // The confirming spinner never settles.
          await tester.pump(const Duration(seconds: 1));
        });
        expect(problems, isEmpty, reason: '${sheet.runtimeType} $locale');
        await unmount(tester);
      }
    }
  });
}
