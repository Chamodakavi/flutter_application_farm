import 'package:farmfriend/features/community/domain/post.dart';
import 'package:farmfriend/features/community/domain/post_activity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Post.toggledLike', () {
    test('liking adds one and sets likedByMe', () {
      const post = Post(id: 1, likeCount: 3);
      final liked = post.toggledLike();
      expect(liked.likedByMe, isTrue);
      expect(liked.likeCount, 4);
    });

    test('unliking removes one and clears likedByMe', () {
      const post = Post(id: 1, likeCount: 4, likedByMe: true);
      final unliked = post.toggledLike();
      expect(unliked.likedByMe, isFalse);
      expect(unliked.likeCount, 3);
    });

    test('the count never goes below zero', () {
      // The view can lag behind: liked_by_me true while like_count is 0.
      const post = Post(id: 1, likeCount: 0, likedByMe: true);
      expect(post.toggledLike().likeCount, 0);
    });

    test('toggling twice gives the original post back', () {
      const post = Post(id: 1, likeCount: 7, savedByMe: true);
      expect(post.toggledLike().toggledLike(), post);
    });
  });

  group('Post.toggledSave', () {
    test('flips savedByMe and leaves the like state alone', () {
      const post = Post(id: 1, likeCount: 2, likedByMe: true);
      final saved = post.toggledSave();
      expect(saved.savedByMe, isTrue);
      expect(saved.likeCount, 2);
      expect(saved.likedByMe, isTrue);
      expect(saved.toggledSave(), post);
    });
  });

  group('ActivityTag', () {
    test('apply prefixes the text with the emoji tag on its own line', () {
      expect(
        ActivityTag.apply(PostActivity.planting, 'Carrots went in today'),
        '🌱 #Planting\nCarrots went in today',
      );
      expect(
        ActivityTag.apply(PostActivity.question, '  Why are my leaves yellow?  '),
        '❓ #Question\nWhy are my leaves yellow?',
      );
    });

    test('apply without an activity returns the trimmed text', () {
      expect(ActivityTag.apply(null, '  Hello  '), 'Hello');
    });

    test('apply replaces an existing tag instead of stacking a second one', () {
      final planting = ActivityTag.apply(PostActivity.planting, 'Beans');
      expect(ActivityTag.apply(PostActivity.selling, planting), '🛒 #Selling\nBeans');
      expect(ActivityTag.apply(PostActivity.planting, planting), planting);
      expect(ActivityTag.apply(null, planting), 'Beans');
    });

    test('parse splits the tag from the text', () {
      for (final activity in PostActivity.values) {
        final parsed = ActivityTag.parse(ActivityTag.apply(activity, 'Line one\nLine two'));
        expect(parsed.activity, activity);
        expect(parsed.text, 'Line one\nLine two');
      }
    });

    test('parse accepts a tag followed by a space or nothing', () {
      expect(
        ActivityTag.parse('🌾 #Harvesting 2 tonnes of rice').activity,
        PostActivity.harvesting,
      );
      expect(ActivityTag.parse('🌾 #Harvesting 2 tonnes of rice').text, '2 tonnes of rice');
      expect(ActivityTag.parse('🌾 #Harvesting'), (activity: PostActivity.harvesting, text: ''));
    });

    test('parse leaves untagged text and look-alike hashtags untouched', () {
      expect(ActivityTag.parse('Just a post'), (activity: null, text: 'Just a post'));
      expect(ActivityTag.parse('🌱 #PlantingSeason is here').activity, isNull);
      expect(ActivityTag.parse('I am 🌱 #Planting').activity, isNull);
      expect(ActivityTag.strip('🛒 #Selling\nFresh beans'), 'Fresh beans');
    });

    test('prefixLength is what apply adds in front of the text', () {
      for (final activity in PostActivity.values) {
        const body = 'text';
        expect(
          ActivityTag.apply(activity, body).length,
          body.length + ActivityTag.prefixLength(activity),
        );
      }
      expect(ActivityTag.prefixLength(null), 0);
    });
  });
}
