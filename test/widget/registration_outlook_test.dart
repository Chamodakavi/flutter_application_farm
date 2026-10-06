import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/features/registration/domain/bucket_status.dart';
import 'package:farmfriend/features/registration/presentation/crop_outlook_detail_screen.dart';
import 'package:farmfriend/features/registration/presentation/crop_outlook_screen.dart';
import 'package:farmfriend/features/registration/presentation/widgets/bucket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/registration_fakes.dart';
import 'registration_test_support.dart';

class _FailingRepository extends FakeRegistrationRepository {
  @override
  Future<List<BucketStatus>> bucketStatus({bool forceRefresh = false}) async {
    bucketCalls++;
    throw const AppException.network();
  }
}

void main() {
  SliceHarness harness() => SliceHarness(
    registration: FakeRegistrationRepository(
      buckets: [
        bucket(
          'CARROT',
          filled: 960,
          fairPrice: 140,
          wholesalePrice: 176,
          farmers: 12,
          harvestDate: '2027-03-15',
          plantingDate: 'Mid December',
        ),
        bucket('BEANS', filled: 500, fairPrice: 220),
        bucket('CABBAGE', filled: 1000, fairPrice: 90),
        bucket('LEEKS', limit: 400, filled: 280, fairPrice: 150),
      ],
    ),
  );

  List<String> shownCrops(WidgetTester tester) => tester
      .widgetList<BucketCard>(find.byType(BucketCard, skipOffstage: false))
      .map((c) => c.bucket.cropName)
      .toList();

  group('CropOutlookScreen (spec §11.12)', () {
    testWidgets('lists every crop, most room first, with a legend', (tester) async {
      final h = harness();
      await pumpApp(tester, const CropOutlookScreen(), overrides: h.overrides);
      await tester.pumpAndSettle();

      expect(find.text('Crop Outlook'), findsOneWidget);
      expect(shownCrops(tester).take(2), ['BEANS', 'LEEKS']);
      expect(find.text('500 of 1,000 MT registered'), findsOneWidget);
      expect(find.text('Fair price: Rs. 220/kg'), findsOneWidget);
      // Legend + chips.
      expect(find.text('Filling up'), findsWidgets);
      expect(h.registration.watching, isTrue);
    });

    testWidgets('filters by level and searches in any language', (tester) async {
      final h = harness();
      await pumpApp(tester, const CropOutlookScreen(), overrides: h.overrides);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, 'Almost full'));
      await tester.pumpAndSettle();
      expect(shownCrops(tester), ['CARROT']);

      await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Full'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'Full'));
      await tester.pumpAndSettle();
      expect(shownCrops(tester), ['CABBAGE']);

      await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'All'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
      await tester.enterText(find.byType(TextField), 'கேரட்');
      await tester.pumpAndSettle();
      expect(shownCrops(tester), ['CARROT']);

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('No crops match this search or filter'), findsOneWidget);
    });

    testWidgets('availableOnly opens on crops with room; sorting by price works', (tester) async {
      final h = harness();
      await pumpApp(
        tester,
        const CropOutlookScreen(availableOnly: true),
        overrides: h.overrides,
      );
      await tester.pumpAndSettle();
      expect(shownCrops(tester).toSet(), {'BEANS', 'LEEKS'});

      await tester.tap(find.text('Most room'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Highest price').last);
      await tester.pumpAndSettle();
      expect(shownCrops(tester), ['BEANS', 'LEEKS']);

      await tester.tap(find.byType(BucketCard).first);
      await tester.pumpAndSettle();
      expect(find.text(routeMarker('/outlook/BEANS')), findsOneWidget);
    });

    testWidgets('empty and error states', (tester) async {
      await pumpApp(tester, const CropOutlookScreen(), overrides: SliceHarness().overrides);
      await tester.pumpAndSettle();
      expect(find.text('No active crop targets'), findsOneWidget);

      await unmount(tester);
      final failing = SliceHarness(registration: _FailingRepository());
      await pumpApp(tester, const CropOutlookScreen(), overrides: failing.overrides);
      await tester.pumpAndSettle();
      expect(find.textContaining('No internet connection'), findsOneWidget);
      final calls = failing.registration.bucketCalls;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(failing.registration.bucketCalls, greaterThan(calls));
    });

    testWidgets('polls get_bucket_status every 60 s while visible, and stops on dispose', (
      tester,
    ) async {
      final h = harness();
      await pumpApp(tester, const CropOutlookScreen(), overrides: h.overrides);
      await tester.pumpAndSettle();
      expect(h.registration.bucketCalls, 1);

      await tester.pump(const Duration(seconds: 61));
      await tester.pumpAndSettle();
      expect(h.registration.bucketCalls, 2);

      await unmount(tester);
      expect(h.registration.watching, isFalse);
      await tester.pump(const Duration(seconds: 130));
      expect(h.registration.bucketCalls, 2);
    });
  });

  group('CropOutlookDetailScreen', () {
    testWidgets('shows the gauge, numbers, dates, prices and next steps', (tester) async {
      final h = harness();
      await pumpApp(
        tester,
        const CropOutlookDetailScreen(cropName: 'CARROT'),
        overrides: h.overrides,
      );
      await tester.pumpAndSettle();

      expect(find.text('96%'), findsOneWidget);
      expect(find.text('12 farmers registered'), findsOneWidget);
      // Parseable free text is formatted, anything else is shown as typed.
      expect(find.text('15 Mar 2027', skipOffstage: false), findsOneWidget);
      expect(find.text('Mid December', skipOffstage: false), findsOneWidget);
      await reveal(tester, find.text('Ask AgriBot about Carrot'));
      expect(find.text('Rs. 176/kg'), findsOneWidget);

      await tester.tap(find.text('Register this crop'));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker('/register?crop=CARROT')), findsOneWidget);
    });

    testWidgets('a full crop cannot be registered; unknown crops get an empty state', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const CropOutlookDetailScreen(cropName: 'CABBAGE'),
        overrides: harness().overrides,
      );
      await tester.pumpAndSettle();
      await reveal(tester, find.text('Register this crop'));
      expect(find.textContaining('This quota is full'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Register this crop')).onPressed,
        isNull,
      );

      await unmount(tester);
      await pumpApp(
        tester,
        const CropOutlookDetailScreen(cropName: 'TOMATOES'),
        overrides: harness().overrides,
      );
      await tester.pumpAndSettle();
      expect(find.text('No active target'), findsOneWidget);
    });
  });
}
