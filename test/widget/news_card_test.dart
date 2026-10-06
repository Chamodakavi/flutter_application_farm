import 'package:farmfriend/features/news/domain/news.dart';
import 'package:farmfriend/features/news/presentation/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

const _iso = '2026-03-05T08:30:00.000Z';

News _news({String? type = 'General'}) => News(
  id: 1,
  title: 'New drip irrigation subsidy',
  description: 'Farmers can now apply for the subsidy at any agrarian service centre.',
  type: type,
  author: 'Department of Agriculture',
  createdAt: DateTime.parse(_iso),
);

Widget _host(News news, {VoidCallback? onTap}) => Scaffold(
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: NewsCard(news: news, onTap: onTap),
  ),
);

void main() {
  testWidgets('shows a formatted date, not the raw ISO string', (tester) async {
    await pumpApp(tester, _host(_news()));

    expect(find.text('5 Mar 2026'), findsOneWidget);
    expect(find.textContaining('2026-03-05'), findsNothing);
    expect(find.textContaining('T08:30'), findsNothing);
    expect(find.text('New drip irrigation subsidy'), findsOneWidget);
    expect(find.text('General'), findsOneWidget);
    expect(find.text('Read More'), findsOneWidget);
  });

  testWidgets('the date follows the app language', (tester) async {
    await pumpApp(tester, _host(_news()), locale: const Locale('si'));

    expect(find.textContaining('2026-03-05'), findsNothing);
    expect(find.textContaining('2026'), findsOneWidget);
    expect(find.text('5 Mar 2026'), findsNothing);
  });

  testWidgets('Alert items get the amber accent, other types do not', (tester) async {
    await pumpApp(tester, _host(_news(type: 'Alert')));
    expect(find.byKey(NewsCard.alertAccentKey), findsOneWidget);
    expect(find.text('Alert'), findsOneWidget);

    await pumpApp(tester, _host(_news(type: 'Technology')));
    expect(find.byKey(NewsCard.alertAccentKey), findsNothing);
    expect(find.text('Technology'), findsOneWidget);
  });

  testWidgets('tapping the card opens the article', (tester) async {
    var taps = 0;
    await pumpApp(tester, _host(_news(), onTap: () => taps++));
    await tester.tap(find.text('New drip irrigation subsidy'));
    expect(taps, 1);
  });

  testWidgets('does not overflow on a narrow phone in Tamil at text scale 1.3', (tester) async {
    await pumpApp(
      tester,
      _host(_news(type: 'Alert')),
      locale: const Locale('ta'),
      textScale: 1.3,
      surfaceSize: const Size(320, 640),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('எச்சரிக்கை'), findsOneWidget);
  });
}
