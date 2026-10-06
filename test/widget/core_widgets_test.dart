import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/utils/app_status.dart';
import 'package:farmfriend/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  group('AsyncValueView', () {
    testWidgets('shows data', (tester) async {
      await pumpApp(
        tester,
        Scaffold(
          body: AsyncValueView<List<String>>(
            value: const AsyncData(['Carrot']),
            data: (items) => Text(items.first),
          ),
        ),
      );
      expect(find.text('Carrot'), findsOneWidget);
    });

    testWidgets('shows the empty state for an empty list', (tester) async {
      await pumpApp(
        tester,
        Scaffold(
          body: AsyncValueView<List<String>>(
            value: const AsyncData([]),
            data: (items) => const Text('data'),
            empty: const EmptyState(title: 'Nothing yet'),
          ),
        ),
      );
      expect(find.text('Nothing yet'), findsOneWidget);
      expect(find.text('data'), findsNothing);
    });

    testWidgets('shows a localized error with Retry', (tester) async {
      var retried = false;
      await pumpApp(
        tester,
        Scaffold(
          body: AsyncValueView<int>(
            value: const AsyncError(AppException.network(), StackTrace.empty),
            data: (v) => Text('$v'),
            onRetry: () => retried = true,
          ),
        ),
      );
      expect(find.textContaining('No internet connection'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });
  });

  testWidgets('StatusChip localizes known statuses and passes unknown ones through', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const Scaffold(
        body: Column(children: [StatusChip('pending'), StatusChip('On hold')]),
      ),
      locale: const Locale('si'),
    );
    expect(find.text('අපේක්ෂිත'), findsOneWidget);
    expect(find.text('On hold'), findsOneWidget);
  });

  testWidgets('QuotaProgressBar shows filled, limit and remaining', (tester) async {
    await pumpApp(
      tester,
      const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: QuotaProgressBar(filledMt: 90, limitMt: 100),
        ),
      ),
    );
    expect(find.text('90 of 100 MT registered'), findsOneWidget);
    expect(find.text('10 MT left'), findsOneWidget);
    expect(SurplusLevel.fromRatio(0.9), SurplusLevel.high);
  });

  testWidgets('QtyStepper respects min and max', (tester) async {
    var value = 1;
    await pumpApp(
      tester,
      Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) => QtyStepper(
            value: value,
            min: 1,
            max: 2,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();
    expect(value, 1);
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    expect(value, 2);
  });

  testWidgets('core widgets do not overflow in Tamil at text scale 1.3', (tester) async {
    await pumpApp(
      tester,
      Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PrimaryButton(label: 'சரிபார்த்து பதிவுசெய்க', icon: Icons.eco, onPressed: () {}),
            const SizedBox(height: 12),
            const EmptyState(title: 'உங்கள் கூடை காலியாக உள்ளது', message: 'வாங்கத் தொடங்குங்கள்'),
            const ErrorState(error: AppException.permission()),
            const InfoNote(text: 'இந்த ஒதுக்கீடுகள் பூட்டப்பட்டுள்ளன. மாற்ற நிர்வாகியைத் தொடர்புகொள்ளவும்.'),
          ],
        ),
      ),
      locale: const Locale('ta'),
      textScale: 1.3,
      surfaceSize: const Size(320, 640),
    );
    expect(tester.takeException(), isNull);
  });
}
