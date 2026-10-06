import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/features/prices/data/price_repository.dart';
import 'package:farmfriend/features/prices/domain/price_forecast.dart';
import 'package:farmfriend/features/prices/domain/price_overview.dart';
import 'package:farmfriend/features/prices/domain/price_series.dart';
import 'package:farmfriend/features/prices/domain/profit_plan.dart';
import 'package:farmfriend/features/prices/presentation/controllers/prices_controller.dart';
import 'package:farmfriend/features/prices/presentation/prices_screen.dart';
import 'package:farmfriend/features/prices/presentation/profit_planner_screen.dart';
import 'package:farmfriend/features/registration/presentation/widgets/land_to_tonnes_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'registration_fakes.dart';

void main() {
  final now = DateTime(2026, 10, 15);

  /// Forecast row [offset] months after October 2026.
  PriceForecast ahead(String crop, int offset, {double wholesale = 180, double? fair}) {
    final month = addMonths(DateTime(2026, 10), offset);
    return forecast(crop, month.year, month.month, wholesale: wholesale, fair: fair);
  }

  group('ProfitPlan (spec §13.7)', () {
    // Model row: 20,000 MT from 1,000 ha → 20 MT/ha; cost Rs. 100/kg;
    // wholesale Rs. 180/kg.
    final carrot = forecast('CARROT', 2027, 3);

    test('1 acre of carrot', () {
      final plan = ProfitPlan.forLand(carrot, 1, LandUnit.acres);
      expect(plan.landHa, closeTo(0.404686, 1e-9));
      expect(plan.yieldMtPerHa, 20);
      expect(plan.expectedMt, closeTo(8.09372, 1e-9));
      expect(plan.costLkr, closeTo(809372, 1e-6));
      expect(plan.revenueLkr, closeTo(1456869.6, 1e-6));
      expect(plan.profitLkr, closeTo(647497.6, 1e-6));
      expect(plan.breakEvenPerKg, 100);
      expect(plan.isLoss, isFalse);
      expect(plan.profitSign, 'profit');
    });

    test('acres convert to hectares; hectares pass through', () {
      expect(ProfitPlan.acresToHa(1), 0.404686);
      expect(ProfitPlan.acresToHa(2.5), closeTo(1.011715, 1e-9));
      expect(LandUnit.acres.toHa(10), closeTo(4.04686, 1e-9));
      expect(LandUnit.hectares.toHa(10), 10);
      expect(ProfitPlan.forLand(carrot, 2, LandUnit.hectares).expectedMt, 40);
    });

    test('zero land gives zero everywhere', () {
      final plan = ProfitPlan(forecast: carrot, landHa: 0);
      expect(plan.expectedMt, 0);
      expect(plan.costLkr, 0);
      expect(plan.revenueLkr, 0);
      expect(plan.profitLkr, 0);
      expect(plan.profitSign, 'even');
    });

    test('missing yield leaves every figure unknown', () {
      for (final row in [
        forecast('CARROT', 2027, 3, goalMt: null),
        forecast('CARROT', 2027, 3, extentHa: null),
        forecast('CARROT', 2027, 3, extentHa: 0),
      ]) {
        final plan = ProfitPlan(forecast: row, landHa: 1);
        expect(plan.yieldMtPerHa, isNull);
        expect(plan.expectedMt, isNull);
        expect(plan.costLkr, isNull);
        expect(plan.revenueLkr, isNull);
        expect(plan.profitLkr, isNull);
        expect(plan.profitSign, 'unknown');
      }
    });

    test('missing cost keeps the income but not the profit', () {
      final plan = ProfitPlan(forecast: forecast('CARROT', 2027, 3, cost: null), landHa: 1);
      expect(plan.revenueLkr, 20 * 1000 * 180);
      expect(plan.costLkr, isNull);
      expect(plan.profitLkr, isNull);
      expect(plan.breakEvenPerKg, isNull);
    });

    test('negative profit when the cost is above the wholesale price', () {
      final plan = ProfitPlan(
        forecast: forecast('CARROT', 2027, 3, wholesale: 80, cost: 100),
        landHa: 1,
      );
      expect(plan.profitLkr, -400000);
      expect(plan.isLoss, isTrue);
      expect(plan.profitSign, 'loss');
    });
  });

  test('land → tonnes rounds to one decimal and needs a yield (spec §13.8)', () {
    final row = forecast('CARROT', 2027, 3);
    expect(estimateTonnes(row, ProfitPlan.acresToHa(1)), 8.1);
    expect(estimateTonnes(row, 2), 40);
    expect(estimateTonnes(row, 0), isNull);
    expect(estimateTonnes(forecast('CARROT', 2027, 3, goalMt: null), 2), isNull);
  });

  group('best harvest month (spec §13.6)', () {
    test('highest wholesale − cost wins', () {
      final best = bestHarvestMonth([
        forecast('CARROT', 2026, 11, wholesale: 200, cost: 150), // 50
        forecast('CARROT', 2027, 1, wholesale: 190, cost: 100), // 90
        forecast('CARROT', 2026, 12, wholesale: 260, cost: 200), // 60
      ]);
      expect(best?.harvestDate, DateTime(2027, 1));
    });

    test('ties go to the earliest month, whatever the input order', () {
      final best = bestHarvestMonth([
        forecast('CARROT', 2027, 2, wholesale: 190, cost: 100),
        forecast('CARROT', 2026, 12, wholesale: 190, cost: 100),
        forecast('CARROT', 2027, 1, wholesale: 240, cost: 150),
      ]);
      expect(best?.harvestDate, DateTime(2026, 12));
    });

    test('without cost data the highest wholesale price wins', () {
      final best = bestHarvestMonth([
        forecast('CARROT', 2026, 11, wholesale: 200, cost: null),
        forecast('CARROT', 2026, 12, wholesale: 230, cost: null),
      ]);
      expect(best?.harvestDate, DateTime(2026, 12));
      expect(bestHarvestMonth(const []), isNull);
    });

    test('PriceSeries only looks at the next 12 months', () {
      final series = PriceSeries(
        crop: 'CARROT',
        now: now,
        forecast: [
          forecast('CARROT', 2026, 9, wholesale: 900), // past
          for (var i = 0; i < 12; i++) ahead('CARROT', i, wholesale: 180.0 + i),
          forecast('CARROT', 2027, 10, wholesale: 900), // month 13
        ],
      );
      expect(series.upcoming, hasLength(12));
      expect(series.upcoming.first.harvestDate, DateTime(2026, 10));
      expect(series.bestMonth?.harvestDate, DateTime(2027, 9));
    });
  });

  group('current month and change % (spec §13.6)', () {
    final history = [
      PricePoint(DateTime(2026, 8), 150),
      PricePoint(DateTime(2026, 9), 160),
    ];

    test('current month is the forecast row for today', () {
      final series = PriceSeries(
        crop: 'CARROT',
        now: now,
        history: history,
        forecast: [forecast('CARROT', 2026, 10, wholesale: 176), forecast('CARROT', 2026, 11)],
      );
      expect(series.forecastPending, isFalse);
      expect(series.currentPrice, 176);
      expect(series.currentPriceMonth, DateTime(2026, 10));
      // Last month from history: (176 − 160) ÷ 160.
      expect(series.changePct, closeTo(10, 1e-9));
    });

    test('falls back to the latest actual price when the forecast is missing', () {
      final series = PriceSeries(
        crop: 'CARROT',
        now: now,
        history: history,
        forecast: [forecast('CARROT', 2026, 11, wholesale: 190)],
      );
      expect(series.current, isNull);
      expect(series.forecastPending, isTrue);
      expect(series.currentPrice, 160);
      expect(series.currentPriceMonth, DateTime(2026, 9));
      // (160 − 150) ÷ 150.
      expect(series.changePct, closeTo(6.6667, 1e-3));
    });

    test('last month comes from the forecast when history lacks it', () {
      final series = PriceSeries(
        crop: 'CARROT',
        now: now,
        forecast: [
          forecast('CARROT', 2026, 9, wholesale: 200),
          forecast('CARROT', 2026, 10, wholesale: 190),
        ],
      );
      expect(series.changePct, closeTo(-5, 1e-9));
    });

    test('no previous month, or a zero price, gives no change', () {
      expect(
        PriceSeries(crop: 'CARROT', now: now, forecast: [forecast('CARROT', 2026, 10)]).changePct,
        isNull,
      );
      expect(
        PriceSeries(
          crop: 'CARROT',
          now: now,
          history: [PricePoint(DateTime(2026, 9), 0)],
          forecast: [forecast('CARROT', 2026, 10)],
        ).changePct,
        isNull,
      );
      expect(PriceSeries(crop: 'CARROT', now: now).currentPrice, isNull);
    });
  });

  group('model versions (spec §13.6)', () {
    test('only the newest version per crop is kept', () {
      final rows = latestModelVersion([
        forecast('CARROT', 2026, 10, version: 'v1', generatedAt: DateTime(2026, 9, 1), wholesale: 1),
        forecast('CARROT', 2026, 11, version: 'v1', generatedAt: DateTime(2026, 9, 1), wholesale: 1),
        forecast('CARROT', 2026, 10, version: 'v2', generatedAt: DateTime(2026, 10, 1), wholesale: 2),
        forecast('CARROT', 2026, 11, version: 'v2', generatedAt: DateTime(2026, 10, 1), wholesale: 2),
        // Beans were not re-run: their only version stays.
        forecast('BEANS', 2026, 10, version: 'v1', generatedAt: DateTime(2026, 9, 1), wholesale: 3),
      ]);
      expect(rows.map((r) => '${r.cropName} ${r.month} ${r.modelVersion}'), [
        'BEANS 10 v1',
        'CARROT 10 v2',
        'CARROT 11 v2',
      ]);
    });

    test('without dates the higher version text wins (v10 > v9)', () {
      final rows = latestModelVersion([
        forecast('CARROT', 2026, 10, version: 'v9'),
        forecast('CARROT', 2026, 10, version: 'v10'),
        forecast('CARROT', 2026, 11, version: 'v10'),
      ]);
      expect(rows.map((r) => r.modelVersion).toSet(), {'v10'});
      expect(rows, hasLength(2));
    });

    test('a series never mixes versions and matches crops in UPPERCASE', () {
      final series = PriceSeries(
        crop: ' carrot ',
        now: now,
        forecast: [
          forecast('CARROT', 2026, 10, version: 'v1', generatedAt: DateTime(2026, 9, 1), wholesale: 111),
          forecast('CARROT', 2026, 10, version: 'v2', generatedAt: DateTime(2026, 10, 1), wholesale: 222),
          forecast('CARROT', 2026, 12, version: 'v1', generatedAt: DateTime(2026, 9, 1), wholesale: 999),
          forecast('BEANS', 2026, 10, version: 'v3', generatedAt: DateTime(2026, 10, 9), wholesale: 5),
        ],
      );
      expect(series.crop, 'CARROT');
      expect(series.forecast.map((f) => f.modelVersion).toSet(), {'v2'});
      expect(series.currentPrice, 222);
      expect(series.modelVersion, 'v2');
      expect(series.generatedAt, DateTime(2026, 10, 1));
    });
  });

  test('a forecast older than 45 days is stale', () {
    expect(isForecastStale(DateTime(2026, 8, 30), now), isTrue);
    expect(isForecastStale(DateTime(2026, 9, 5), now), isFalse);
    expect(isForecastStale(null, now), isFalse);
    final series = PriceSeries(
      crop: 'CARROT',
      now: now,
      forecast: [forecast('CARROT', 2026, 10, generatedAt: DateTime(2026, 7, 1))],
    );
    expect(series.isStale, isTrue);
  });

  group('buildPriceSummaries (Crop Prices rows)', () {
    final forecasts = [
      for (var i = 0; i < 8; i++) ahead('CARROT', i, wholesale: 180.0 + i, fair: 140),
      // Beans: the job has not produced October yet.
      for (var i = 1; i < 4; i++) ahead('BEANS', i, wholesale: 300.0 + i),
    ];
    final history = {
      'CARROT': [PricePoint(DateTime(2026, 9), 150)],
      'BEANS': [PricePoint(DateTime(2026, 8), 250), PricePoint(DateTime(2026, 9), 275)],
    };

    test('uses the overview row when it has a price', () {
      final rows = buildPriceSummaries(
        overview: const [
          PriceOverview(
            cropName: 'CARROT',
            wholesalePrice: 245,
            prevPrice: 226.44,
            changePct: 8.2,
            fairPrice: 200,
            costPerKg: 143,
          ),
        ],
        forecasts: forecasts,
        history: history,
        now: now,
      );
      final carrot = rows.firstWhere((r) => r.cropName == 'CARROT');
      expect(carrot.price, 245);
      expect(carrot.changePct, 8.2);
      expect(carrot.aboveFair, isTrue);
      expect(carrot.marginPerKg, 102);
      expect(carrot.forecastPending, isFalse);
      expect(carrot.sparkline, [180, 181, 182, 183, 184, 185]);
    });

    test('falls back to the forecast row, then to the latest actual price', () {
      final rows = buildPriceSummaries(forecasts: forecasts, history: history, now: now);
      expect(rows.map((r) => r.cropName), ['BEANS', 'CARROT']);

      final carrot = rows.last;
      expect(carrot.price, 180);
      expect(carrot.changePct, closeTo(20, 1e-9));
      expect(carrot.aboveFair, isTrue);
      expect(carrot.forecastPending, isFalse);

      final beans = rows.first;
      expect(beans.forecastPending, isTrue);
      expect(beans.price, 275);
      expect(beans.changePct, closeTo(10, 1e-9));
      expect(beans.aboveFair, isNull);
      expect(beans.sparkline, [301, 302, 303]);
    });

    test('an overview row without a price does not hide the fallback', () {
      final rows = buildPriceSummaries(
        overview: const [PriceOverview(cropName: 'beans')],
        forecasts: forecasts,
        history: history,
        now: now,
      );
      expect(rows.first.cropName, 'BEANS');
      expect(rows.first.price, 275);
      expect(rows.first.forecastPending, isTrue);
    });
  });

  test('sortPriceSummaries: rise, fall, margin; rows without the figure go last', () {
    const rows = [
      PriceSummary(cropName: 'BEANS', price: 300, changePct: -5, costPerKg: 100),
      PriceSummary(cropName: 'CARROT', price: 180, changePct: 8, costPerKg: 150),
      PriceSummary(cropName: 'LEEKS', price: 90),
    ];
    List<String> names(PriceSort sort) =>
        sortPriceSummaries(rows, sort, (c) => c).map((r) => r.cropName).toList();
    expect(names(PriceSort.name), ['BEANS', 'CARROT', 'LEEKS']);
    expect(names(PriceSort.biggestRise), ['CARROT', 'BEANS', 'LEEKS']);
    expect(names(PriceSort.biggestFall), ['BEANS', 'CARROT', 'LEEKS']);
    expect(names(PriceSort.bestMargin), ['BEANS', 'CARROT', 'LEEKS']);
  });

  test('planner helpers: upcoming rows per crop and the month parameter', () {
    final byCrop = upcomingByCrop([
      forecast('CARROT', 2026, 9),
      for (var i = 0; i < 14; i++) ahead('carrot', i),
      forecast('BEANS', 2026, 11),
    ], now);
    expect(byCrop.keys.toSet(), {'CARROT', 'BEANS'});
    expect(byCrop['CARROT'], hasLength(12));
    expect(byCrop['CARROT']!.first.harvestDate, DateTime(2026, 10));
    expect(parsePlannerMonth('2027-03'), DateTime(2027, 3));
    expect(parsePlannerMonth('2027-13'), isNull);
    expect(parsePlannerMonth('March'), isNull);
    expect(parsePlannerMonth(null), isNull);
  });

  group('providers (TC_MOB_01: forecasts via Riverpod)', () {
    ProviderContainer container(FakePriceRepository repo) {
      final c = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          priceRepositoryProvider.overrideWithValue(repo),
          priceClockProvider.overrideWithValue(() => now),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('priceForecastsProvider serves the newest version of each crop', () async {
      final c = container(
        FakePriceRepository(
          forecastRows: [
            forecast('CARROT', 2026, 10, version: 'v1', generatedAt: DateTime(2026, 9, 1)),
            forecast('CARROT', 2026, 10, version: 'v2', generatedAt: DateTime(2026, 10, 1)),
          ],
        ),
      );
      final rows = await c.read(priceForecastsProvider.future);
      expect(rows.single.modelVersion, 'v2');
      expect(c.read(cropForecastsProvider('carrot')).single.modelVersion, 'v2');
    });

    test('the price list survives a missing overview view', () async {
      final c = container(
        FakePriceRepository(
          overviewError: const AppException.notFound(),
          forecastRows: [forecast('CARROT', 2026, 10, wholesale: 176)],
        ),
      );
      final rows = await c.read(priceSummariesProvider.future);
      expect(rows.single.price, 176);
    });

    test('the price list fails when nothing can be shown', () async {
      final c = container(FakePriceRepository(overviewError: const AppException.network()));
      await expectLater(
        c.read(priceSummariesProvider.future),
        throwsA(isA<NetworkException>()),
      );
    });

    test('priceSeriesProvider joins history and forecast for one crop', () async {
      final c = container(
        FakePriceRepository(
          forecastRows: [forecast('CARROT', 2026, 11, wholesale: 190)],
          historyRows: {
            'CARROT': [PricePoint(DateTime(2026, 9), 160)],
          },
        ),
      );
      final series = await c.read(priceSeriesProvider('carrot').future);
      expect(series.forecastPending, isTrue);
      expect(series.currentPrice, 160);
      expect(series.bestMonth?.harvestDate, DateTime(2026, 11));
    });
  });
}
