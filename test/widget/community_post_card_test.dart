import 'dart:async';

import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/features/community/domain/post.dart';
import 'package:farmfriend/features/community/presentation/controllers/feed_controller.dart';
import 'package:farmfriend/features/community/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/community_fakes.dart';

/// Pumps a [PostCard] for [post] and returns the repository behind it.
Future<FakeCommunityRepository> _pumpCard(WidgetTester tester, Post post) async {
  final repo = FakeCommunityRepository(posts: [post]);
  await pumpApp(
    tester,
    Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: PostCard(postId: post.id),
      ),
    ),
    overrides: communityOverrides(repo),
  );
  ProviderScope.containerOf(tester.element(find.byType(PostCard)))
      .read(postStoreProvider.notifier)
      .put(post);
  await tester.pump();
  return repo;
}

void main() {
  testWidgets('tapping Like updates the count before the server answers', (tester) async {
    final repo = await _pumpCard(tester, testPost(1, likeCount: 3, commentCount: 2));
    expect(find.text('3'), findsOneWidget);
    expect(find.text('2 comments'), findsOneWidget);

    repo.writeGate = Completer<void>();
    await tester.tap(find.text('Like'));
    await tester.pump();
    expect(find.text('4'), findsOneWidget);
    expect(repo.likeCalls, isEmpty);

    repo.writeGate!.complete();
    await tester.pump();
    expect(repo.likeCalls, [(1, true)]);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('a failed like goes back to the old count and shows the error', (tester) async {
    final repo = await _pumpCard(tester, testPost(1, likeCount: 3));
    repo.writeError = const AppException.network();

    await tester.tap(find.text('Like'));
    await tester.pump();
    await tester.pump();
    expect(find.text('3'), findsOneWidget);
    expect(find.textContaining('No internet connection'), findsOneWidget);
  });

  testWidgets('the bookmark toggles optimistically', (tester) async {
    final repo = await _pumpCard(tester, testPost(1));
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);

    repo.writeGate = Completer<void>();
    await tester.tap(find.byIcon(Icons.bookmark_border_rounded));
    await tester.pump();
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);

    repo.writeGate!.complete();
    await tester.pump();
    expect(repo.saveCalls, [(1, true)]);
  });

  testWidgets('shows the activity tag as a chip, not as raw text', (tester) async {
    await _pumpCard(tester, testPost(1, content: '🌱 #Planting\nCarrots went in today'));
    expect(find.text('🌱 Planting'), findsOneWidget);
    expect(find.text('Carrots went in today'), findsOneWidget);
    expect(find.textContaining('#Planting'), findsNothing);
  });

  testWidgets('own posts offer Edit and Delete; other posts offer Report', (tester) async {
    await _pumpCard(tester, testPost(1, userId: testUserId));
    await tester.tap(find.byTooltip('More options'));
    await tester.pumpAndSettle();
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    expect(find.text('Report'), findsNothing);
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text(routeMarker('/community/new?edit=1')), findsOneWidget);

    await _pumpCard(tester, testPost(2));
    await tester.tap(find.byTooltip('More options'));
    await tester.pumpAndSettle();
    expect(find.text('Edit'), findsNothing);
    await tester.tap(find.text('Report'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Report+post+%232'), findsOneWidget);
  });

  testWidgets('Comment opens the post with the comment box focused', (tester) async {
    await _pumpCard(tester, testPost(1));
    await tester.tap(find.text('Comment'));
    await tester.pumpAndSettle();
    expect(find.text(routeMarker('/community/post/1?comment=1')), findsOneWidget);
  });

  test('the share text is the start of the post plus its web link', () {
    final short = PostCard.shareText(testPost(12, content: 'Fresh beans for sale'));
    expect(short, startsWith('Fresh beans for sale\n'));
    expect(short, endsWith('/community/post/12'));

    final long = PostCard.shareText(testPost(13, content: 'x' * 500));
    expect(long.split('\n').first.length, lessThanOrEqualTo(201));
    expect(long, endsWith('/community/post/13'));
  });
}
