import 'dart:async';

import 'package:farmfriend/core/config/constants.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/features/community/domain/comment.dart';
import 'package:farmfriend/features/community/presentation/controllers/feed_controller.dart';
import 'package:farmfriend/features/community/presentation/controllers/post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'community_fakes.dart';

ProviderContainer _container(FakeCommunityRepository repository) =>
    ProviderContainer.test(retry: (_, _) => null, overrides: communityOverrides(repository));

/// Loads a feed and keeps it alive for the test (the providers auto-dispose).
Future<FeedState> _open(ProviderContainer container, FeedKind kind) {
  container.listen(feedProvider(kind), (_, _) {});
  return container.read(feedProvider(kind).future);
}

void main() {
  group('optimistic like', () {
    test('flips at once and keeps the new state when the write succeeds', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1, likeCount: 3)]);
      final container = _container(repo);
      await _open(container, FeedKind.all);

      repo.writeGate = Completer<void>();
      final pending = container.read(postStoreProvider.notifier).toggleLike(1);

      // Before the server has answered.
      expect(container.read(postByIdProvider(1))!.likedByMe, isTrue);
      expect(container.read(postByIdProvider(1))!.likeCount, 4);
      expect(repo.likeCalls, isEmpty);

      repo.writeGate!.complete();
      await pending;
      expect(repo.likeCalls, [(1, true)]);
      expect(container.read(postByIdProvider(1))!.likedByMe, isTrue);
      expect(container.read(postByIdProvider(1))!.likeCount, 4);
    });

    test('reverts and rethrows when the write fails', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1, likeCount: 3)])
        ..writeError = const AppException.network();
      final container = _container(repo);
      await _open(container, FeedKind.all);

      await expectLater(
        container.read(postStoreProvider.notifier).toggleLike(1),
        throwsA(isA<NetworkException>()),
      );
      expect(container.read(postByIdProvider(1))!.likedByMe, isFalse);
      expect(container.read(postByIdProvider(1))!.likeCount, 3);
    });

    test('unlike works the same way and a second tap in flight is ignored', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1, likeCount: 1, likedByMe: true)]);
      final container = _container(repo);
      await _open(container, FeedKind.all);
      final store = container.read(postStoreProvider.notifier);

      repo.writeGate = Completer<void>();
      final first = store.toggleLike(1);
      final second = store.toggleLike(1);
      expect(container.read(postByIdProvider(1))!.likeCount, 0);
      repo.writeGate!.complete();
      await Future.wait([first, second]);

      expect(repo.likeCalls, [(1, false)]);
      expect(container.read(postByIdProvider(1))!.likedByMe, isFalse);
    });

    test('a refetch during the request does not undo the optimistic state', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1, likeCount: 3)]);
      final container = _container(repo);
      await _open(container, FeedKind.all);

      repo.writeGate = Completer<void>();
      final pending = container.read(postStoreProvider.notifier).toggleLike(1);
      // The server copy still says "not liked".
      await container.read(feedProvider(FeedKind.all).notifier).refresh();
      expect(container.read(postByIdProvider(1))!.likedByMe, isTrue);
      expect(container.read(postByIdProvider(1))!.likeCount, 4);

      repo.writeGate!.complete();
      await pending;
    });
  });

  group('optimistic save', () {
    test('a post saved in the feed shows up in Saved Posts and its count', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1), testPost(2)]);
      final container = _container(repo);
      await _open(container, FeedKind.all);
      expect((await _open(container, FeedKind.saved)).ids, isEmpty);
      container.listen(savedPostsCountProvider, (_, _) {});
      expect(await container.read(savedPostsCountProvider.future), 0);

      await container.read(postStoreProvider.notifier).toggleSave(2);

      expect(repo.saveCalls, [(2, true)]);
      expect(container.read(postByIdProvider(2))!.savedByMe, isTrue);
      expect((await container.read(feedProvider(FeedKind.saved).future)).ids, [2]);
      expect(await container.read(savedPostsCountProvider.future), 1);
    });

    test('reverts when the write fails', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1, savedByMe: true)])
        ..writeError = const AppException.permission();
      final container = _container(repo);
      await _open(container, FeedKind.all);

      await expectLater(
        container.read(postStoreProvider.notifier).toggleSave(1),
        throwsA(isA<PermissionFailure>()),
      );
      expect(container.read(postByIdProvider(1))!.savedByMe, isTrue);
    });
  });

  group('FeedController', () {
    test('pages through the feed without repeating posts', () async {
      final repo = FakeCommunityRepository(posts: [for (var id = 45; id >= 1; id--) testPost(id)]);
      final container = _container(repo);
      final first = await _open(container, FeedKind.all);
      expect(first.ids.length, AppConst.pageSize);
      expect(first.hasMore, isTrue);

      final feed = container.read(feedProvider(FeedKind.all).notifier);
      await feed.loadMore();
      await feed.loadMore();
      final state = container.read(feedProvider(FeedKind.all)).requireValue;
      expect(state.ids, [for (var id = 45; id >= 1; id--) id]);
      expect(state.hasMore, isFalse);

      await feed.loadMore();
      expect(container.read(feedProvider(FeedKind.all)).requireValue.ids.length, 45);
    });

    test('My Posts only holds the signed-in user\'s posts', () async {
      final repo = FakeCommunityRepository(
        posts: [
          testPost(3),
          testPost(2, userId: testUserId),
          testPost(1),
        ],
      );
      final container = _container(repo);
      expect((await _open(container, FeedKind.mine)).ids, [2]);
      container.listen(myPostsCountProvider, (_, _) {});
      expect(await container.read(myPostsCountProvider.future), 1);
    });

    test('a new post refreshes the feed, My Posts and the count', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1)]);
      final container = _container(repo);
      await _open(container, FeedKind.all);
      await _open(container, FeedKind.mine);

      await container.read(postActionsProvider).create(content: '🌱 #Planting\nBeans today');

      expect((await container.read(feedProvider(FeedKind.all).future)).ids, [2, 1]);
      expect((await container.read(feedProvider(FeedKind.mine).future)).ids, [2]);
      expect(container.read(postByIdProvider(2))!.content, '🌱 #Planting\nBeans today');
    });

    test('editing changes the text everywhere; deleting removes the post', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1, userId: testUserId)]);
      final container = _container(repo);
      await _open(container, FeedKind.all);
      final actions = container.read(postActionsProvider);

      await actions.edit(1, 'Updated text');
      expect(container.read(postByIdProvider(1))!.content, 'Updated text');

      await actions.delete(1);
      expect(container.read(postByIdProvider(1)), isNull);
      expect((await container.read(feedProvider(FeedKind.all).future)).ids, isEmpty);
    });
  });

  group('CommentsController', () {
    Comment remote(int id, {String userId = 'other', String content = 'Nice'}) =>
        Comment(id: id, userId: userId, postId: 1, content: content, createdAt: DateTime.now());

    Future<ProviderContainer> open(FakeCommunityRepository repo) async {
      final container = _container(repo);
      await _open(container, FeedKind.all);
      container.listen(commentsProvider(1), (_, _) {});
      await container.read(commentsProvider(1).future);
      return container;
    }

    test('my comment shows at once, then becomes the saved row', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1, commentCount: 2)]);
      final container = await open(repo);
      final comments = container.read(commentsProvider(1).notifier);

      repo.writeGate = Completer<void>();
      final pending = comments.add('  Good harvest!  ', authorName: 'Kamal Silva');
      var added = container.read(commentsProvider(1)).requireValue.added;
      expect(added.single.content, 'Good harvest!');
      expect(CommentsController.isPending(added.single), isTrue);
      expect(container.read(postByIdProvider(1))!.commentCount, 3);

      repo.writeGate!.complete();
      await pending;
      added = container.read(commentsProvider(1)).requireValue.added;
      expect(added.single.id, 1000);
      expect(added.single.authorName, 'Kamal Silva');
      expect(CommentsController.isPending(added.single), isFalse);
    });

    test('a failed comment is removed again and the count restored', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1, commentCount: 2)])
        ..writeError = const AppException.network();
      final container = await open(repo);

      await expectLater(
        container.read(commentsProvider(1).notifier).add('Hello'),
        throwsA(isA<NetworkException>()),
      );
      expect(container.read(commentsProvider(1)).requireValue.isEmpty, isTrue);
      expect(container.read(postByIdProvider(1))!.commentCount, 2);
    });

    test('realtime appends other people\'s comments and ignores my own echo', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1)]);
      final container = await open(repo);
      final comments = container.read(commentsProvider(1).notifier);

      repo.realtime.add(remote(7));
      await pumpEventQueue();
      expect(container.read(commentsProvider(1)).requireValue.added.map((c) => c.id), [7]);
      expect(container.read(postByIdProvider(1))!.commentCount, 1);

      // Same row delivered twice.
      repo.realtime.add(remote(7));
      await pumpEventQueue();
      expect(container.read(commentsProvider(1)).requireValue.added.length, 1);

      // My insert echoes back after its response.
      await comments.add('Mine');
      repo.realtime.add(remote(1000, userId: testUserId, content: 'Mine'));
      await pumpEventQueue();
      final ids = container.read(commentsProvider(1)).requireValue.added.map((c) => c.id);
      expect(ids, [7, 1000]);
      expect(container.read(postByIdProvider(1))!.commentCount, 2);
    });

    test('my echo arriving before the response replaces the placeholder', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1)]);
      final container = await open(repo);

      repo.writeGate = Completer<void>();
      final pending = container.read(commentsProvider(1).notifier).add('Mine');
      repo.realtime.add(remote(1000, userId: testUserId, content: 'Mine'));
      await pumpEventQueue();
      expect(container.read(commentsProvider(1)).requireValue.added.single.id, 1000);

      repo.writeGate!.complete();
      await pending;
      expect(container.read(commentsProvider(1)).requireValue.added.single.id, 1000);
      expect(container.read(postByIdProvider(1))!.commentCount, 1);
    });

    test('deleting my comment removes it; a failure puts it back', () async {
      final mine = remote(5, userId: testUserId, content: 'Oops');
      final repo = FakeCommunityRepository(posts: [testPost(1, commentCount: 1)], comments: [mine]);
      final container = await open(repo);
      final comments = container.read(commentsProvider(1).notifier);

      repo.writeError = const AppException.network();
      await expectLater(comments.delete(mine), throwsA(isA<NetworkException>()));
      expect(container.read(commentsProvider(1)).requireValue.paged, [mine]);
      expect(container.read(postByIdProvider(1))!.commentCount, 1);

      repo.writeError = null;
      await comments.delete(mine);
      expect(container.read(commentsProvider(1)).requireValue.isEmpty, isTrue);
      expect(container.read(postByIdProvider(1))!.commentCount, 0);
    });

    test('the realtime channel is released when the screen closes', () async {
      final repo = FakeCommunityRepository(posts: [testPost(1)]);
      final container = _container(repo);
      final subscription = container.listen(commentsProvider(1), (_, _) {});
      await container.read(commentsProvider(1).future);
      expect(repo.realtimeListeners, 1);

      subscription.close();
      await container.pump();
      await pumpEventQueue();
      expect(repo.realtimeListeners, 0);
    });
  });
}
