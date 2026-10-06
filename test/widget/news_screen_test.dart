import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/features/news/data/news_repository.dart';
import 'package:farmfriend/features/news/domain/news.dart';
import 'package:farmfriend/features/news/presentation/news_detail_screen.dart';
import 'package:farmfriend/features/news/presentation/news_screen.dart';
import 'package:farmfriend/features/news/presentation/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/overflow_probe.dart';
import '../helpers/test_app.dart';

class _FakeNewsRepository implements NewsRepository {
  _FakeNewsRepository(this.all);

  final List<News> all;

  @override
  Future<List<News>> fetchLatest({bool forceRefresh = false}) async => all;

  @override
  Future<List<News>> fetchMore(int offset) async => const [];

  @override
  Future<News> fetchById(int id) async =>
      all.firstWhere((n) => n.id == id, orElse: () => throw const AppException.notFound());

  @override
  Future<int> countSince(DateTime since) async => all.length;
}

final _items = [
  News(
    id: 1,
    title: 'Heavy rain warning',
    description: 'Delay fertiliser application this week.',
    type: 'Alert',
    author: 'Met Department',
    createdAt: DateTime.utc(2026, 10, 3, 6),
  ),
  News(
    id: 2,
    title: 'Drip irrigation subsidy',
    description: 'Apply at any agrarian service centre.',
    type: 'Technology',
    createdAt: DateTime.utc(2026, 9, 28, 6),
  ),
];

Future<void> _load(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  testWidgets('lists news with filter chips taken from the loaded types', (tester) async {
    await pumpApp(
      tester,
      const NewsScreen(),
      overrides: [newsRepositoryProvider.overrideWithValue(_FakeNewsRepository(_items))],
    );
    await _load(tester);

    expect(find.byType(NewsCard), findsNWidgets(2));
    expect(find.widgetWithText(ChoiceChip, 'All'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Alert'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Technology'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Technology'));
    await tester.pumpAndSettle();
    expect(find.byType(NewsCard), findsOneWidget);
    expect(find.text('Drip irrigation subsidy'), findsOneWidget);
    expect(find.text('Heavy rain warning'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.pumpAndSettle();
    expect(find.byType(NewsCard), findsNWidgets(2));

    await tester.tap(find.text('Heavy rain warning'));
    await tester.pumpAndSettle();
    expect(find.text(routeMarker('/news/1')), findsOneWidget);
  });

  testWidgets('shows the empty state when there is no news', (tester) async {
    await pumpApp(
      tester,
      const NewsScreen(),
      overrides: [newsRepositoryProvider.overrideWithValue(_FakeNewsRepository(const []))],
    );
    await _load(tester);
    expect(find.text('No news yet'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('detail loads by id and shows author, date and Share', (tester) async {
    await pumpApp(
      tester,
      const NewsDetailScreen(newsId: 1),
      overrides: [newsRepositoryProvider.overrideWithValue(_FakeNewsRepository(_items))],
    );
    await _load(tester);

    expect(find.text('Heavy rain warning'), findsOneWidget);
    expect(find.text('By Met Department'), findsOneWidget);
    expect(find.text('3 Oct 2026'), findsOneWidget);
    expect(find.text('Delay fertiliser application this week.'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    expect(NewsDetailScreen.shareText(_items.first), endsWith('/news/1'));
    expect(NewsDetailScreen.shareText(_items.first), startsWith('Heavy rain warning\n'));
  });

  testWidgets('detail shows a retry state for an unknown id', (tester) async {
    await pumpApp(
      tester,
      const NewsDetailScreen(newsId: 99),
      overrides: [newsRepositoryProvider.overrideWithValue(_FakeNewsRepository(_items))],
    );
    await _load(tester);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.textContaining("couldn't find"), findsOneWidget);
  });

  for (final locale in const [Locale('si'), Locale('ta')]) {
    testWidgets('list and detail do not overflow (${locale.languageCode}, 1.3, 320×640)', (
      tester,
    ) async {
      const longWord = 'Supercalifragilisticexpialidocious_without_any_spaces_1234567890';
      final items = [
        ..._items,
        for (final (index, type) in const [
          'General',
          'Disease',
          'Market',
          'Organic farming and soil health',
          null,
        ].indexed)
          News(
            id: 10 + index,
            title: index.isEven
                ? longWord
                : 'නව පොහොර සහනාධාරය — புதிய உர மானியம் அறிவிக்கப்பட்டது',
            description: '$longWord ගොවීන්ට දැන් ඕනෑම ගොවිජන සේවා මධ්‍යස්ථානයකින් අයදුම් කළ හැක.',
            type: type,
            author: 'Department of Agriculture, $longWord',
            createdAt: DateTime.utc(2026, 9, 10 + index),
          ),
      ];
      final overrides = [newsRepositoryProvider.overrideWithValue(_FakeNewsRepository(items))];

      final listProblems = await collectLayoutErrors(() async {
        await pumpApp(
          tester,
          const NewsScreen(),
          overrides: overrides,
          locale: locale,
          textScale: 1.3,
          surfaceSize: const Size(320, 640),
        );
        await _load(tester);
        for (var i = 0; i < 8; i++) {
          await tester.drag(find.byType(ListView), const Offset(0, -300));
          await _load(tester);
        }
      });
      expect(listProblems, isEmpty, reason: 'list $locale');

      for (final id in [1, 10, 13]) {
        final detailProblems = await collectLayoutErrors(() async {
          await pumpApp(
            tester,
            NewsDetailScreen(newsId: id),
            overrides: overrides,
            locale: locale,
            textScale: 1.3,
            surfaceSize: const Size(320, 640),
          );
          await _load(tester);
          await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
          await _load(tester);
        });
        expect(detailProblems, isEmpty, reason: 'detail $id $locale');
      }
    });
  }
}
