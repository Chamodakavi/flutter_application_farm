import 'package:farmfriend/features/community/domain/comment.dart';
import 'package:farmfriend/features/community/presentation/community_screen.dart';
import 'package:farmfriend/features/community/presentation/post_detail_screen.dart';
import 'package:farmfriend/features/community/presentation/saved_posts_screen.dart';
import 'package:farmfriend/features/community/presentation/widgets/comment_tile.dart';
import 'package:farmfriend/features/community/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/community_fakes.dart';

/// Lets the fake repository's futures complete and the list build.
Future<void> _load(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  testWidgets('an empty feed shows the empty state under the composer', (tester) async {
    await pumpApp(
      tester,
      const CommunityScreen(),
      overrides: communityOverrides(FakeCommunityRepository()),
    );
    await _load(tester);

    expect(find.text("What's on your mind?"), findsOneWidget);
    expect(find.text('No posts yet'), findsOneWidget);
    expect(find.text('My Posts (0)'), findsOneWidget);
    expect(find.text('Saved Posts (0)'), findsOneWidget);
    expect(find.byType(PostCard), findsNothing);

    await tester.tap(find.text('Create a post'));
    await tester.pumpAndSettle();
    expect(find.text(routeMarker('/community/new')), findsOneWidget);
  });

  testWidgets('the feed lists posts and the shortcut chips show the counts', (tester) async {
    final repo = FakeCommunityRepository(
      posts: [
        testPost(3, content: 'Third', savedByMe: true),
        testPost(2, userId: testUserId, content: 'Second'),
        testPost(1, content: 'First'),
      ],
    );
    await pumpApp(tester, const CommunityScreen(), overrides: communityOverrides(repo));
    await _load(tester);

    expect(find.byType(PostCard), findsNWidgets(3));
    expect(find.text('Third'), findsOneWidget);
    expect(find.text('My Posts (1)'), findsOneWidget);
    expect(find.text('Saved Posts (1)'), findsOneWidget);
    expect(find.text('No posts yet'), findsNothing);

    await tester.tap(find.text('Saved Posts (1)'));
    await tester.pumpAndSettle();
    expect(find.text(routeMarker('/community/saved')), findsOneWidget);
  });

  testWidgets('Saved Posts reuses the feed list with its own empty state', (tester) async {
    await pumpApp(
      tester,
      const SavedPostsScreen(),
      overrides: communityOverrides(FakeCommunityRepository(posts: [testPost(1)])),
    );
    await _load(tester);
    expect(find.text('No saved posts'), findsOneWidget);
    expect(find.byType(PostCard), findsNothing);
  });

  testWidgets('the feed does not overflow in Sinhala at text scale 1.3 on 320×640', (tester) async {
    final repo = FakeCommunityRepository(
      posts: [
        testPost(
          4,
          userId: testUserId,
          authorName: 'කමල් සිල්වා ගුණවර්ධන මහතා',
          content:
              '🌾 #Harvesting\nඅද අපේ කුඹුරේ අස්වනු නෙළීම ආරම්භ කළා. මේ කන්නයේ අස්වැන්න '
              'ගිය වතාවට වඩා හොඳයි. වැස්ස නිසා ටිකක් පරක්කු වුණත් දැන් හැම දෙයක්ම හොඳින් '
              'සිදු වෙනවා. ඔබේ ප්‍රදේශවල තත්ත්වය කොහොමද? අපි සියලු දෙනාම එකතු වී මිල ගණන් '
              'ගැන සාකච්ඡා කරමු. තවත් විස්තර ඉක්මනින් බෙදාගන්නම්. ස්තූතියි!',
          likeCount: 1280,
          commentCount: 342,
          likedByMe: true,
          savedByMe: true,
        ),
        testPost(3, content: 'කෙටි පළකිරීමක්', authorName: null, commentCount: 1),
        testPost(2, content: '❓ #Question\nකැරට් වලට හොඳම පොහොර මොනවාද?'),
        testPost(
          1,
          content: 'Supercalifragilisticexpialidocious_without_any_spaces_at_all_1234567890',
        ),
      ],
    );
    await pumpApp(
      tester,
      const CommunityScreen(),
      overrides: communityOverrides(repo),
      locale: const Locale('si'),
      textScale: 1.3,
      surfaceSize: const Size(320, 640),
    );
    await _load(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('ඔබේ සිතේ ඇත්තේ කුමක්ද?'), findsOneWidget);

    // Scroll through every card so each one is laid out.
    final seen = <int>{};
    for (var i = 0; i < 8; i++) {
      seen.addAll(tester.widgetList<PostCard>(find.byType(PostCard)).map((card) => card.postId));
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await _load(tester);
      expect(tester.takeException(), isNull);
    }
    seen.addAll(tester.widgetList<PostCard>(find.byType(PostCard)).map((card) => card.postId));
    expect(seen, {1, 2, 3, 4});
  });

  testWidgets('post detail shows the post, its comments and the comment box', (tester) async {
    final repo = FakeCommunityRepository(
      posts: [testPost(1, content: 'How is the harvest?', commentCount: 2)],
      comments: [
        Comment(
          id: 1,
          userId: 'other',
          postId: 1,
          content: 'Going well',
          authorName: 'Sunil',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Comment(
          id: 2,
          userId: testUserId,
          postId: 1,
          content: 'Same here',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    );
    await pumpApp(
      tester,
      const PostDetailScreen(postId: 1, focusComment: true),
      overrides: communityOverrides(repo),
    );
    await _load(tester);

    expect(find.text('How is the harvest?'), findsOneWidget);
    expect(find.byType(CommentTile), findsNWidgets(2));
    expect(find.text('Sunil'), findsOneWidget);
    // My own comment has no embedded author: the profile name is used.
    expect(find.text('Kamal Silva'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).autofocus, isTrue);

    await tester.enterText(find.byType(TextField), 'Thanks all');
    await tester.pump();
    await tester.tap(find.byTooltip('Send comment'));
    await _load(tester);
    await tester.pumpAndSettle();
    expect(find.byType(CommentTile), findsNWidgets(3));
    expect(find.text('Thanks all'), findsOneWidget);
    expect(find.text('3 comments'), findsOneWidget);
    expect(repo.comments.last.content, 'Thanks all');
  });
}
