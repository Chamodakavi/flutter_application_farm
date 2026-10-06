import 'package:farmfriend/features/community/domain/comment.dart';
import 'package:farmfriend/features/community/presentation/community_screen.dart';
import 'package:farmfriend/features/community/presentation/create_post_screen.dart';
import 'package:farmfriend/features/community/presentation/my_posts_screen.dart';
import 'package:farmfriend/features/community/presentation/post_detail_screen.dart';
import 'package:farmfriend/features/community/presentation/saved_posts_screen.dart';
import 'package:farmfriend/features/community/presentation/widgets/comment_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/overflow_probe.dart';
import '../helpers/test_app.dart';
import '../unit/community_fakes.dart';

const _locales = [Locale('si'), Locale('ta')];
const _small = Size(320, 640);

/// Nothing to wrap on: the worst case for a narrow column.
const longWord = 'Supercalifragilisticexpialidocious_without_any_spaces_1234567890';

/// Posts with long names, long text, big counters and both scripts.
FakeCommunityRepository longTextRepository({List<Comment> comments = const []}) =>
    FakeCommunityRepository(
      comments: comments,
      posts: [
        testPost(
          4,
          userId: testUserId,
          authorName: 'කමල් සිල්වා ගුණවර්ධන මහතා',
          content:
              '🌾 #Harvesting\nඅද අපේ කුඹුරේ අස්වනු නෙළීම ආරම්භ කළා. මේ කන්නයේ අස්වැන්න '
              'ගිය වතාවට වඩා හොඳයි. வானிலை காரணமாக சிறிது தாமதமானாலும் இப்போது எல்லாம் '
              'நன்றாக நடக்கிறது. ඔබේ ප්‍රදේශවල තත්ත්වය කොහොමද? අපි සියලු දෙනාම එකතු වී '
              'මිල ගණන් ගැන සාකච්ඡා කරමු. தொடர்ந்து பகிர்கிறேன். ස්තූතියි!',
          likeCount: 128000,
          commentCount: 34200,
          likedByMe: true,
          savedByMe: true,
        ),
        testPost(3, content: 'கேரட்டுக்கு சிறந்த உரம் எது?', authorName: null, savedByMe: true),
        testPost(2, userId: testUserId, content: '❓ #Question\n$longWord'),
        testPost(1, content: longWord, authorName: longWord, commentCount: 1),
      ],
    );

Future<void> _load(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _scrollThrough(WidgetTester tester, Finder scrollable) async {
  for (var i = 0; i < 8; i++) {
    await tester.drag(scrollable, const Offset(0, -300));
    await _load(tester);
  }
}

void main() {
  for (final locale in _locales) {
    final tag = locale.languageCode;

    testWidgets('feed, My Posts and Saved Posts do not overflow ($tag, 1.3, 320×640)', (
      tester,
    ) async {
      for (final screen in const <Widget>[CommunityScreen(), MyPostsScreen(), SavedPostsScreen()]) {
        final problems = await collectLayoutErrors(() async {
          await pumpApp(
            tester,
            screen,
            overrides: communityOverrides(longTextRepository()),
            locale: locale,
            textScale: 1.3,
            surfaceSize: _small,
          );
          await _load(tester);
          await _scrollThrough(tester, find.byType(CustomScrollView));
        });
        expect(problems, isEmpty, reason: '${screen.runtimeType} $locale');
      }
    });

    testWidgets('the empty feed does not overflow ($tag, 1.3, 320×640)', (tester) async {
      for (final screen in const <Widget>[CommunityScreen(), MyPostsScreen(), SavedPostsScreen()]) {
        final problems = await collectLayoutErrors(() async {
          await pumpApp(
            tester,
            screen,
            overrides: communityOverrides(FakeCommunityRepository()),
            locale: locale,
            textScale: 1.3,
            surfaceSize: _small,
          );
          await _load(tester);
          await _scrollThrough(tester, find.byType(CustomScrollView));
        });
        expect(problems, isEmpty, reason: '${screen.runtimeType} $locale');
      }
    });

    testWidgets('post detail with comments does not overflow ($tag, 1.3, 320×640)', (tester) async {
      final problems = await collectLayoutErrors(() async {
        await pumpApp(
          tester,
          const PostDetailScreen(postId: 4),
          overrides: communityOverrides(
            longTextRepository(
              comments: [
                for (var i = 1; i <= 25; i++)
                  Comment(
                    id: i,
                    userId: i.isEven ? testUserId : 'other',
                    postId: 4,
                    content: i == 3 ? longWord : 'අදහස $i — கருத்து $i, a slightly longer comment',
                    authorName: i % 3 == 0 ? null : 'Sunil Bandara Wickramasinghe Rajapaksha',
                    createdAt: DateTime.now().subtract(Duration(hours: 30 - i)),
                  ),
              ],
            ),
          ),
          locale: locale,
          textScale: 1.3,
          surfaceSize: _small,
        );
        await _load(tester);
        await _scrollThrough(tester, find.byType(CustomScrollView));
        // Typing a comment adds the optimistic "Sending…" tile.
        await tester.enterText(find.byType(TextField), longWord);
        await tester.pump();
        await tester.tap(find.byIcon(Icons.send_rounded));
        await _load(tester);
        await tester.pump(const Duration(milliseconds: 400));
      });
      expect(problems, isEmpty, reason: '$locale');
      expect(find.byType(CommentTile), findsWidgets);
    });

    testWidgets('create post, with the activity sheet, does not overflow ($tag, 1.3, 320×640)', (
      tester,
    ) async {
      final problems = await collectLayoutErrors(() async {
        await pumpApp(
          tester,
          const CreatePostScreen(),
          overrides: communityOverrides(FakeCommunityRepository()),
          locale: locale,
          textScale: 1.3,
          surfaceSize: _small,
        );
        await _load(tester);
        await tester.enterText(find.byType(TextField), '$longWord\n$longWord');
        await tester.pump();
        await tester.ensureVisible(find.byIcon(Icons.emoji_nature_outlined));
        await tester.pump();
        await tester.tap(find.byIcon(Icons.emoji_nature_outlined));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.tap(find.text('🌾'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await _scrollThrough(tester, find.byType(SingleChildScrollView));
      });
      expect(problems, isEmpty, reason: '$locale');
      expect(find.byType(InputChip), findsOneWidget);
    });

    testWidgets('edit post does not overflow ($tag, 1.3, 320×640)', (tester) async {
      final problems = await collectLayoutErrors(() async {
        await pumpApp(
          tester,
          const CreatePostScreen(editPostId: 4),
          overrides: communityOverrides(longTextRepository()),
          locale: locale,
          textScale: 1.3,
          surfaceSize: _small,
        );
        await _load(tester);
        await _scrollThrough(tester, find.byType(SingleChildScrollView));
      });
      expect(problems, isEmpty, reason: '$locale');
      // The stored tag became the chip; the field holds only the user's words.
      expect(find.byType(InputChip), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isNot(contains('#Harvesting')),
      );
    });
  }
}
