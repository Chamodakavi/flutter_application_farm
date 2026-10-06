import 'package:farmfriend/core/analytics/analytics_service.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/utils/formatters.dart';
import 'package:farmfriend/features/prices/domain/price_forecast.dart';
import 'package:farmfriend/features/prices/domain/price_overview.dart';
import 'package:farmfriend/features/prices/domain/price_series.dart';
import 'package:farmfriend/features/prices/domain/profit_plan.dart';
import 'package:farmfriend/features/prices/presentation/controllers/prices_controller.dart';
import 'package:farmfriend/features/prices/presentation/price_detail_screen.dart';
import 'package:farmfriend/features/prices/presentation/prices_screen.dart';
import 'package:farmfriend/features/prices/presentation/profit_planner_screen.dart';
import 'package:farmfriend/features/prices/presentation/widgets/price_change_badge.dart';
import 'package:farmfriend/features/prices/presentation/widgets/price_list_tile.dart';
import 'package:farmfriend/features/prices/presentation/widgets/price_trend_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/registration_fakes.dart';
import 'registration_test_support.dart';

/// Forecast row [offset] months after October 2026 (the test "today").
PriceForecast _ahead(
  String crop,
  int offset, {
  double wholesale = 150,
  double? cost = 100,
  DateTime? generatedAt,
}) {
  final month = addMonths(DateTime(2026, 10), offset);
  final planting = addMonths(month, -3);
  return forecast(
    crop,
    month.year,
    month.month,
    wholesale: wholesale,
    cost: cost,
    retail: wholesale * 1.25,
    plantingYear: planting.year,
    plantingMonth: planting.month,
    generatedAt: generatedAt ?? DateTime(2026, 10, 1),
  );
}

List<PricePoint> _history(double latest) => [
  for (var i = 12; i >= 1; i--)
    PricePoint(addMonths(DateTime(2026, 10), -i), latest - (i - 1) * 2),
];

void main() {
  // Carrot has this month's forecast; the job has not produced October for
  // beans yet (TC_PRICE_02).
  FakePriceRepository prices() => FakePriceRepository(
    forecastRows: [
      // March 2027 (offset 5) is the best month: Rs. 180 − 100.
      for (var i = 0; i < 12; i++) _ahead('CARROT', i, wholesale: i == 5 ? 180 : 150.0 + i),
      for (var i = 1; i < 12; i++) _ahead('BEANS', i, wholesale: 300.0 - i),
    ],
    historyRows: {'CARROT': _history(125), 'BEANS': _history(275)},
  );

  group('PriceChangeBadge', () {
    testWidgets('▲ green, ▼ red, — grey', (tester) async {
      await pumpApp(
        tester,
        const Scaffold(
          body: Column(
            children: [
              PriceChangeBadge(changePct: 8.2),
              PriceChangeBadge(changePct: -5.12),
              PriceChangeBadge(changePct: null),
              PriceChangeBadge(changePct: 0.01, compact: true),
            ],
          ),
        ),
      );
      expect(find.text('▲ 8.2%'), findsOneWidget);
      expect(find.text('▼ 5.1%'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
      expect(find.text('— 0%'), findsOneWidget);
    });
  });

  group('PriceTrendChart', () {
    Future<void> pumpChart(WidgetTester tester, PriceSeries series) async {
      await pumpApp(tester, Scaffold(body: PriceTrendChart(series: series)));
      await tester.pumpAndSettle();
    }

    testWidgets('draws with a forecast only, or with history only', (tester) async {
      await pumpChart(
        tester,
        PriceSeries(
          crop: 'CARROT',
          now: testNow,
          forecast: [for (var i = 0; i < 12; i++) _ahead('CARROT', i)],
        ),
      );
      var chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.lineBarsData[0].spots, isEmpty);
      expect(chart.data.lineBarsData[1].spots, hasLength(12));
      expect(find.text('Forecast'), findsOneWidget);

      await unmount(tester);
      await pumpChart(tester, PriceSeries(crop: 'CARROT', now: testNow, history: _history(120)));
      chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.lineBarsData[0].spots, hasLength(12));
      expect(chart.data.betweenBarsData, isEmpty);
      // History ends last month: no "today" marker inside the plotted range.
      expect(chart.data.extraLinesData.verticalLines, isEmpty);
    });

    testWidgets('says so instead of drawing when there is a single month', (tester) async {
      await pumpChart(
        tester,
        PriceSeries(
          crop: 'CARROT',
          now: testNow,
          history: [PricePoint(DateTime(2026, 10), 120)],
          forecast: [_ahead('CARROT', 0)],
        ),
      );
      expect(find.byType(LineChart), findsNothing);
      expect(find.text('Not enough price data to draw a chart yet.'), findsOneWidget);
    });
  });

  group('PricesScreen (spec §11.29)', () {
    testWidgets('TC_PRICE_01: rows from overridden providers', (tester) async {
      await pumpApp(
        tester,
        const PricesScreen(),
        overrides: [
          ...SliceHarness().overrides,
          priceOverviewProvider.overrideWith(
            (ref) async => [
              PriceOverview(
                cropName: 'CARROT',
                wholesalePrice: 245,
                prevPrice: 226.43,
                changePct: 8.2,
                fairPrice: 200,
                costPerKg: 143,
                generatedAt: DateTime(2026, 10, 1),
              ),
            ],
          ),
          priceForecastsProvider.overrideWith(
            (ref) async => [for (var i = 0; i < 8; i++) _ahead('CARROT', i)],
          ),
          recentPriceHistoryProvider.overrideWith((ref) async => {'CARROT': _history(226.43)}),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Crop Prices'), findsOneWidget);
      expect(find.text('Wholesale forecast · updated 1 Oct 2026'), findsOneWidget);
      expect(find.byType(PriceListTile), findsOneWidget);
      expect(find.text('Carrot'), findsOneWidget);
      expect(find.text('Rs. 245/kg'), findsOneWidget);
      expect(find.text('▲ 8.2%'), findsOneWidget);
      expect(find.text('Above fair price'), findsOneWidget);
      expect(find.text('Forecast pending'), findsNothing);
      expect(find.textContaining('Forecasts are estimates'), findsOneWidget);

      await tester.tap(find.byType(PriceListTile));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker('/prices/CARROT')), findsOneWidget);
    });

    testWidgets('TC_PRICE_02: "Forecast pending" when the current month is missing', (
      tester,
    ) async {
      final harness = SliceHarness(prices: prices());
      await pumpApp(tester, const PricesScreen(), overrides: harness.overrides);
      await tester.pumpAndSettle();

      expect(find.byType(PriceListTile), findsNWidgets(2));
      // Beans: the latest actual price stands in, flagged as pending.
      expect(find.text('Forecast pending'), findsOneWidget);
      expect(find.text('Rs. 275/kg'), findsOneWidget);
      // Carrot: this month's forecast against last month's actual price.
      expect(find.text('Rs. 150/kg'), findsOneWidget);
      expect(find.text('▲ 20%'), findsOneWidget);
      expect(find.text('Above fair price'), findsOneWidget);
    });

    testWidgets('searches in any language and sorts', (tester) async {
      final harness = SliceHarness(prices: prices());
      await pumpApp(tester, const PricesScreen(), overrides: harness.overrides);
      await tester.pumpAndSettle();

      List<String> shown() => tester
          .widgetList<PriceListTile>(find.byType(PriceListTile))
          .map((t) => t.summary.cropName)
          .toList();
      expect(shown(), ['BEANS', 'CARROT']);

      await tester.tap(find.widgetWithText(ChoiceChip, 'Biggest rise'));
      await tester.pumpAndSettle();
      expect(shown(), ['CARROT', 'BEANS']);

      await tester.enterText(find.byType(TextField), 'බෝංචි');
      await tester.pumpAndSettle();
      expect(shown(), ['BEANS']);

      await tester.enterText(find.byType(TextField), 'nothing');
      await tester.pumpAndSettle();
      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('amber chip when the forecast is older than 45 days', (tester) async {
      final harness = SliceHarness(
        prices: FakePriceRepository(
          forecastRows: [
            for (var i = 0; i < 6; i++) _ahead('CARROT', i, generatedAt: DateTime(2026, 7, 1)),
          ],
        ),
      );
      await pumpApp(tester, const PricesScreen(), overrides: harness.overrides);
      await tester.pumpAndSettle();
      expect(find.text('Forecast may be outdated'), findsOneWidget);
    });

    testWidgets('empty and error states', (tester) async {
      await pumpApp(tester, const PricesScreen(), overrides: SliceHarness().overrides);
      await tester.pumpAndSettle();
      expect(find.text('No prices yet'), findsOneWidget);

      await unmount(tester);
      await pumpApp(
        tester,
        const PricesScreen(),
        overrides: [
          ...SliceHarness().overrides,
          priceSummariesProvider.overrideWith((ref) async => throw const AppException.network()),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('No internet connection'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  group('PriceDetailScreen (spec §11.30)', () {
    testWidgets('hero, chart with history + forecast, best month, cost and quota', (
      tester,
    ) async {
      final harness = SliceHarness(
        prices: prices(),
        registration: FakeRegistrationRepository(buckets: [bucket('CARROT', filled: 600)]),
      );
      await pumpApp(
        tester,
        const PriceDetailScreen(cropName: 'CARROT'),
        overrides: harness.overrides,
      );
      await tester.pumpAndSettle();

      expect(harness.analytics!.propsOf(AnalyticsEvents.priceViewed), {'crop': 'CARROT'});
      expect(find.text("This month's wholesale price"), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(const Key('price-hero'))).data, 'Rs. 150/kg');
      expect(find.text('▲ 20%'), findsOneWidget);
      expect(find.text('Estimated retail Rs. 187.5/kg'), findsOneWidget);
      expect(find.text('Forecast pending'), findsNothing);

      // Solid actual line, dashed forecast line, floor–fair band, today marker.
      final chart = tester.widget<LineChart>(find.byType(LineChart, skipOffstage: false));
      final bars = chart.data.lineBarsData;
      expect(bars[0].spots, hasLength(12));
      expect(bars[0].dashArray, isNull);
      expect(bars[1].spots, hasLength(13)); // 12 forecast months + the bridge point
      expect(bars[1].dashArray, isNotNull);
      expect(chart.data.betweenBarsData, hasLength(1));
      expect(chart.data.extraLinesData.verticalLines, hasLength(1));
      await reveal(tester, find.text('Plan my profit'));
      expect(find.text('Best month to harvest'), findsOneWidget);
      expect(find.text('March 2027'), findsWidgets);
      expect(find.text('Profit Rs. 80/kg'), findsOneWidget);
      expect(find.text('Plant in December 2026 to harvest in March 2027'), findsOneWidget);

      await tester.tap(find.text('Plan my profit'));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker('/planner?crop=CARROT&month=2027-03')), findsOneWidget);
    });

    testWidgets('quota card and "Why this price?" follow further down', (tester) async {
      final harness = SliceHarness(
        prices: prices(),
        registration: FakeRegistrationRepository(buckets: [bucket('CARROT', filled: 600)]),
      );
      await pumpApp(
        tester,
        const PriceDetailScreen(cropName: 'carrot'),
        overrides: harness.overrides,
      );
      await tester.pumpAndSettle();

      await reveal(tester, find.text('National quota'));
      expect(find.text('600 of 1,000 MT registered'), findsOneWidget);

      await reveal(tester, find.text('Why this price?'));
      await tester.tap(find.text('Why this price?'));
      await tester.pumpAndSettle();
      expect(find.text('Model version', skipOffstage: false), findsOneWidget);

      await reveal(tester, find.text('Ask AgriBot'));
      await tester.tap(find.text('Ask AgriBot'));
      await tester.pumpAndSettle();
      expect(find.textContaining('route:/chat?prompt=What+will+Carrot+sell+for'), findsOneWidget);
    });

    testWidgets('TC_PRICE_02: pending forecast shows the latest actual price, no crash', (
      tester,
    ) async {
      final harness = SliceHarness(prices: prices());
      await pumpApp(
        tester,
        const PriceDetailScreen(cropName: 'BEANS'),
        overrides: harness.overrides,
      );
      await tester.pumpAndSettle();
      expect(find.text('Latest market price (September 2026)'), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(const Key('price-hero'))).data, 'Rs. 275/kg');
      expect(find.text('Forecast pending'), findsOneWidget);
      expect(find.byType(PriceTrendChart), findsOneWidget);
    });

    testWidgets('a crop without any prices gets an empty state', (tester) async {
      await pumpApp(
        tester,
        const PriceDetailScreen(cropName: 'LEEKS'),
        overrides: SliceHarness(prices: prices()).overrides,
      );
      await tester.pumpAndSettle();
      expect(find.text('No prices for this crop'), findsOneWidget);
    });
  });

  group('ProfitPlannerScreen (spec §11.31)', () {
    SliceHarness harness() => SliceHarness(
      prices: prices(),
      registration: FakeRegistrationRepository(
        buckets: [bucket('CARROT', filled: 995), bucket('BEANS', filled: 100)],
      ),
    );

    String textOf(WidgetTester tester, String key) =>
        tester.widget<Text>(find.byKey(Key(key), skipOffstage: false)).data!;

    testWidgets('TC_PLAN_01: 1 acre of carrot matches ProfitPlan', (tester) async {
      final h = harness();
      await pumpApp(
        tester,
        const ProfitPlannerScreen(initialCrop: 'CARROT'),
        overrides: h.overrides,
      );
      await tester.pumpAndSettle();

      // The best month is preselected and starred.
      expect(find.text('⭐ Mar 27'), findsOneWidget);
      expect(find.text('Enter your land size to see the plan.'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '1');
      await tester.pumpAndSettle();

      final plan = ProfitPlan.forLand(_ahead('CARROT', 5, wholesale: 180), 1, LandUnit.acres);
      expect(plan.expectedMt, closeTo(8.09372, 1e-9));
      expect(textOf(tester, 'planner-harvest'), Fmt.mt(plan.expectedMt));
      expect(textOf(tester, 'planner-cost'), Fmt.rsWhole(plan.costLkr));
      expect(textOf(tester, 'planner-income'), Fmt.rsWhole(plan.revenueLkr));
      expect(textOf(tester, 'planner-profit'), Fmt.rsWhole(plan.profitLkr));
      expect(textOf(tester, 'planner-harvest'), '8.09 MT');
      expect(textOf(tester, 'planner-cost'), 'Rs. 809,372');
      expect(textOf(tester, 'planner-income'), 'Rs. 1,456,870');
      expect(textOf(tester, 'planner-profit'), 'Rs. 647,498');
      expect(find.text('= 0.4 hectares'), findsOneWidget);

      // Only 5 MT of quota left: the plan does not fit.
      await reveal(tester, find.text('See crops with room'));
      expect(find.textContaining('exceeds the remaining quota'), findsOneWidget);

      await reveal(tester, find.text('Register 8.09 MT of Carrot'));
      await tester.tap(find.text('Register 8.09 MT of Carrot'));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker('/register?crop=CARROT&amount=8.09')), findsOneWidget);
    });

    testWidgets('hectares, another month, a loss and the usage event', (tester) async {
      final h = SliceHarness(
        prices: FakePriceRepository(
          forecastRows: [
            _ahead('CARROT', 1, wholesale: 80), // below the Rs. 100 cost
            _ahead('CARROT', 2, wholesale: 180),
          ],
        ),
      );
      await pumpApp(
        tester,
        const ProfitPlannerScreen(initialCrop: 'carrot', initialMonth: '2026-11'),
        overrides: h.overrides,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Hectares'));
      await tester.enterText(find.byType(TextFormField), '2');
      await tester.pumpAndSettle();

      expect(textOf(tester, 'planner-harvest'), '40 MT');
      expect(textOf(tester, 'planner-profit'), 'Rs. -800,000');
      expect(find.text('Expected loss', skipOffstage: false), findsOneWidget);

      await tester.tap(find.text('⭐ Dec 26'));
      await tester.pumpAndSettle();
      expect(textOf(tester, 'planner-profit'), 'Rs. 3,200,000');

      await tester.pump(const Duration(seconds: 3));
      expect(h.analytics!.propsOf(AnalyticsEvents.plannerUsed), {
        'crop': 'CARROT',
        'land_ha': 2.0,
        'profit': 'profit',
      });
    });

    testWidgets('compares crops on the same land and month, highlighting the best', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const ProfitPlannerScreen(initialCrop: 'CARROT', initialMonth: '2027-03'),
        overrides: harness().overrides,
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '1');
      await tester.pumpAndSettle();
      await reveal(tester, find.text('Add a crop to compare'));
      await tester.tap(find.text('Add a crop to compare'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beans').last);
      await tester.pumpAndSettle();

      // Beans sell for Rs. 295 in March against Rs. 180 for carrot.
      await reveal(tester, find.text('Highest profit'));
      expect(find.byType(Table), findsOneWidget);
      expect(find.text('Highest profit'), findsOneWidget);
      final beans = ProfitPlan.forLand(_ahead('BEANS', 5, wholesale: 295), 1, LandUnit.acres);
      expect(find.text(Fmt.rsWhole(beans.profitLkr)), findsOneWidget);

      await tester.tap(find.byTooltip('Remove Beans'));
      await tester.pumpAndSettle();
      expect(find.byType(Table), findsNothing);
    });

    testWidgets('asks for a crop first; empty state without forecasts', (tester) async {
      await pumpApp(tester, const ProfitPlannerScreen(), overrides: harness().overrides);
      await tester.pumpAndSettle();
      expect(find.text('Choose a crop to start your plan.'), findsOneWidget);
      expect(find.textContaining('These are estimates'), findsOneWidget);

      await unmount(tester);
      await pumpApp(tester, const ProfitPlannerScreen(), overrides: SliceHarness().overrides);
      await tester.pumpAndSettle();
      expect(find.text('No forecasts yet'), findsOneWidget);
    });
  });
}
