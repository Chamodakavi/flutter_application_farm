import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_providers.dart';
import '../../data/community_repository.dart';
import '../../domain/feed_kind.dart';
import '../../domain/post.dart';

export '../../domain/feed_kind.dart';

/// Every post currently known to the app, by id — the single source of truth
/// for a post's text, counters and like / saved state. The feed, My Posts,
/// Saved Posts and Post Detail all render from here, so a like made in one
/// place shows everywhere (spec §13.4).
class PostStore extends Notifier<Map<int, Post>> {
  final _likeBusy = <int>{};
  final _saveBusy = <int>{};

  @override
  Map<int, Post> build() {
    // Another account must not inherit liked / saved flags.
    ref.watch(currentUserIdProvider);
    _likeBusy.clear();
    _saveBusy.clear();
    return const {};
  }

  /// Adds or replaces [posts] with what the server returned. A toggle that is
  /// still being sent keeps its optimistic value.
  void putAll(Iterable<Post> posts) {
    if (posts.isEmpty) return;
    final next = {...state};
    for (final incoming in posts) {
      var post = incoming;
      final local = next[post.id];
      if (local != null) {
        if (_likeBusy.contains(post.id)) {
          post = post.copyWith(likedByMe: local.likedByMe, likeCount: local.likeCount);
        }
        if (_saveBusy.contains(post.id)) post = post.copyWith(savedByMe: local.savedByMe);
      }
      next[post.id] = post;
    }
    state = next;
  }

  void put(Post post) => putAll([post]);

  void remove(int id) {
    if (!state.containsKey(id)) return;
    state = {...state}..remove(id);
  }

  void _update(int id, Post Function(Post post) change) {
    final post = state[id];
    if (post == null) return;
    state = {...state, id: change(post)};
  }

  void setContent(int id, String content) => _update(id, (p) => p.copyWith(content: content));

  /// Keeps "{n} comments" in step with the comments list.
  void addToCommentCount(int id, int delta) =>
      _update(id, (p) => p.copyWith(commentCount: math.max(0, p.commentCount + delta)));

  /// Optimistic like: flips the local state at once, then writes
  /// `post_likes`. On failure the flip is undone and the error rethrown for
  /// the caller's snackbar. Taps while a request is in flight are ignored.
  Future<void> toggleLike(int id) async {
    final post = state[id];
    if (post == null || !_likeBusy.add(id)) return;
    final liked = !post.likedByMe;
    _update(id, (p) => p.toggledLike());
    try {
      await ref.read(communityRepositoryProvider).setLiked(id, liked);
    } catch (_) {
      if (ref.mounted && state[id]?.likedByMe == liked) _update(id, (p) => p.toggledLike());
      rethrow;
    } finally {
      _likeBusy.remove(id);
    }
  }

  /// Optimistic bookmark, same contract as [toggleLike] on `saved_posts`.
  Future<void> toggleSave(int id) async {
    final post = state[id];
    if (post == null || !_saveBusy.add(id)) return;
    final saved = !post.savedByMe;
    _update(id, (p) => p.toggledSave());
    try {
      await ref.read(communityRepositoryProvider).setSaved(id, saved);
    } catch (_) {
      if (ref.mounted && state[id]?.savedByMe == saved) _update(id, (p) => p.toggledSave());
      rethrow;
    } finally {
      _saveBusy.remove(id);
    }
    if (!ref.mounted) return;
    ref.invalidate(savedPostsCountProvider);
    // A newly saved post has to appear in an open Saved Posts list; an
    // unsaved one stays there (bookmark off) until the next refresh.
    if (saved) ref.invalidate(feedProvider(FeedKind.saved));
  }
}

final postStoreProvider = NotifierProvider<PostStore, Map<int, Post>>(PostStore.new);

/// One post from the store; rebuilds only when that post changes.
final postByIdProvider = Provider.family<Post?, int>(
  (ref, id) => ref.watch(postStoreProvider.select((posts) => posts[id])),
);

/// The loaded part of a feed. Holds ids only; the posts live in [PostStore].
class FeedState {
  const FeedState({
    this.ids = const [],
    this.hasMore = false,
    this.loadingMore = false,
    this.loadMoreFailed = false,
  });

  final List<int> ids;
  final bool hasMore;
  final bool loadingMore;

  /// The last "load more" failed; scrolling stops retrying until the user
  /// taps Retry.
  final bool loadMoreFailed;

  FeedState copyWith({List<int>? ids, bool? hasMore, bool? loadingMore, bool? loadMoreFailed}) =>
      FeedState(
        ids: ids ?? this.ids,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
        loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      );
}

/// Paginated list of posts from `feed_posts`, newest first (spec §11.19).
/// One instance per [FeedKind]: the community feed, My Posts and Saved Posts.
class FeedController extends AsyncNotifier<FeedState> {
  FeedController(this.kind);

  final FeedKind kind;
  int _nextPage = 1;

  /// Bumped by every first-page load, so a "load more" that was in flight
  /// during a refresh is dropped instead of appended to the new list.
  int _generation = 0;

  @override
  Future<FeedState> build() async {
    ref.watch(currentUserIdProvider);
    final page = await ref.watch(communityRepositoryProvider).fetchPosts(kind);
    return _firstPage(page);
  }

  FeedState _firstPage(PostPage page) {
    ref.read(postStoreProvider.notifier).putAll(page.posts);
    _nextPage = 1;
    _generation++;
    return FeedState(ids: [for (final p in page.posts) p.id], hasMore: page.hasMore);
  }

  /// Pull-to-refresh. Throws when the reload fails; the list already on
  /// screen is kept.
  Future<void> refresh() async {
    final page = await ref.read(communityRepositoryProvider).fetchPosts(kind);
    if (!ref.mounted) return;
    state = AsyncData(_firstPage(page));
  }

  /// Appends the next page. [retry] is the footer button after a failure.
  Future<void> loadMore({bool retry = false}) async {
    final current = state.value;
    if (current == null || current.loadingMore || !current.hasMore) return;
    if (current.loadMoreFailed && !retry) return;
    state = AsyncData(current.copyWith(loadingMore: true, loadMoreFailed: false));
    final generation = _generation;
    final PostPage page;
    try {
      page = await ref.read(communityRepositoryProvider).fetchPosts(kind, page: _nextPage);
    } catch (_) {
      if (!ref.mounted || generation != _generation) return;
      state = AsyncData(current.copyWith(loadingMore: false, loadMoreFailed: true));
      return;
    }
    if (!ref.mounted || generation != _generation) return;
    _nextPage++;
    ref.read(postStoreProvider.notifier).putAll(page.posts);
    // New posts published meanwhile push rows down a page: skip repeats.
    final known = current.ids.toSet();
    state = AsyncData(
      FeedState(
        ids: [
          ...current.ids,
          for (final p in page.posts)
            if (known.add(p.id)) p.id,
        ],
        hasMore: page.hasMore,
      ),
    );
  }
}

final feedProvider = AsyncNotifierProvider.autoDispose.family<FeedController, FeedState, FeedKind>(
  FeedController.new,
);

/// "My Posts (n)".
final myPostsCountProvider = FutureProvider.autoDispose<int>((ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(communityRepositoryProvider).countMyPosts();
});

/// "Saved Posts (n)".
final savedPostsCountProvider = FutureProvider.autoDispose<int>((ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(communityRepositoryProvider).countSavedPosts();
});
