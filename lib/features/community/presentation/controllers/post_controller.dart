import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/supabase/storage_service.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../data/community_repository.dart';
import '../../domain/comment.dart';
import 'feed_controller.dart';

/// Fetches one post by id into [PostStore] — Post Detail and Edit Post watch
/// this next to [postByIdProvider], so a post opened from the feed shows at
/// once and a deep link still loads (spec §9.3).
final postLoadProvider = FutureProvider.autoDispose.family<void, int>((ref, id) async {
  final post = await ref.watch(communityRepositoryProvider).fetchPost(id);
  ref.read(postStoreProvider.notifier).put(post);
});

/// Create, edit and delete posts; each keeps the lists that show the post in
/// step.
class PostActions {
  PostActions(this._ref);

  final Ref _ref;

  /// Uploads the photo (if any), then inserts the post (spec §11.20).
  Future<void> create({required String content, String? imagePath}) async {
    final imageUrl = imagePath == null
        ? null
        : await _ref.read(storageServiceProvider).uploadPostImage(imagePath);
    await _ref.read(communityRepositoryProvider).createPost(content: content, imageUrl: imageUrl);
    _ref
      ..invalidate(feedProvider(FeedKind.all))
      ..invalidate(feedProvider(FeedKind.mine))
      ..invalidate(myPostsCountProvider);
  }

  /// Changes the text of an own post.
  Future<void> edit(int id, String content) async {
    await _ref.read(communityRepositoryProvider).updatePost(id, content);
    _ref.read(postStoreProvider.notifier).setContent(id, content);
  }

  Future<void> delete(int id) async {
    await _ref.read(communityRepositoryProvider).deletePost(id);
    _ref.read(postStoreProvider.notifier).remove(id);
    for (final kind in FeedKind.values) {
      _ref.invalidate(feedProvider(kind));
    }
    _ref
      ..invalidate(myPostsCountProvider)
      ..invalidate(savedPostsCountProvider);
  }
}

final postActionsProvider = Provider<PostActions>(PostActions.new);

/// Comments of one post, oldest first.
class CommentsState {
  const CommentsState({
    this.paged = const [],
    this.added = const [],
    this.hasMore = false,
    this.loadingMore = false,
  });

  /// Loaded page by page from the start of the conversation.
  final List<Comment> paged;

  /// Written while the screen is open — mine and other people's (realtime).
  /// They are the newest, so they are shown after [paged] even while older
  /// pages are still to be loaded.
  final List<Comment> added;
  final bool hasMore;
  final bool loadingMore;

  bool get isEmpty => paged.isEmpty && added.isEmpty;

  bool contains(int id) => paged.any((c) => c.id == id) || added.any((c) => c.id == id);

  CommentsState copyWith({
    List<Comment>? paged,
    List<Comment>? added,
    bool? hasMore,
    bool? loadingMore,
  }) => CommentsState(
    paged: paged ?? this.paged,
    added: added ?? this.added,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
  );
}

/// Paginated comments with a realtime subscription on `comments` INSERT for
/// this post (spec §11.21, §17.1). The channel lives as long as the screen.
class CommentsController extends AsyncNotifier<CommentsState> {
  CommentsController(this.postId);

  final int postId;

  /// Placeholder ids for comments that are still being sent (negative, so
  /// they never collide with database ids).
  int _lastTempId = 0;

  /// True for a comment that has not reached the server yet.
  static bool isPending(Comment comment) => comment.id < 0;

  @override
  Future<CommentsState> build() async {
    final repo = ref.watch(communityRepositoryProvider);
    final inserts = repo.commentInserts(postId).listen(_onRemoteInsert, onError: (Object _) {});
    ref.onDispose(inserts.cancel);
    final page = await repo.fetchComments(postId);
    return CommentsState(paged: page, hasMore: page.length >= AppConst.pageSize);
  }

  PostStore get _posts => ref.read(postStoreProvider.notifier);

  void _onRemoteInsert(Comment comment) {
    final current = state.value;
    if (current == null || current.contains(comment.id)) return;
    if (comment.userId != null && comment.userId == ref.read(currentUserIdProvider)) {
      // My own insert echoed back before its response: it replaces the
      // placeholder instead of showing twice.
      final index = current.added.indexWhere((c) => isPending(c) && c.content == comment.content);
      if (index != -1) {
        final placeholder = current.added[index];
        final added = [...current.added];
        added[index] = comment.copyWith(
          authorName: comment.authorName ?? placeholder.authorName,
          authorAvatar: comment.authorAvatar ?? placeholder.authorAvatar,
        );
        state = AsyncData(current.copyWith(added: added));
        return;
      }
    }
    state = AsyncData(current.copyWith(added: [...current.added, comment]));
    _posts.addToCommentCount(postId, 1);
  }

  /// Next page of older-to-newer comments. Rethrows on failure.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.loadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final page = await ref
          .read(communityRepositoryProvider)
          .fetchComments(postId, offset: current.paged.length);
      if (!ref.mounted) return;
      final latest = state.value ?? current;
      final known = latest.paged.map((c) => c.id).toSet();
      final fresh = [
        for (final c in page)
          if (known.add(c.id)) c,
      ];
      state = AsyncData(
        CommentsState(
          paged: [...latest.paged, ...fresh],
          // The pages have caught up with comments shown ahead of them.
          added: latest.added.where((c) => !known.contains(c.id)).toList(),
          hasMore: page.length >= AppConst.pageSize,
        ),
      );
    } catch (_) {
      if (ref.mounted) {
        state = AsyncData((state.value ?? current).copyWith(loadingMore: false));
      }
      rethrow;
    }
  }

  /// Optimistic insert: the comment shows at once and is swapped for the
  /// saved row, or removed (and the error rethrown) when sending fails.
  /// [authorName] / [authorAvatar] are the signed-in user's, for display.
  Future<void> add(String text, {String? authorName, String? authorAvatar}) async {
    final content = text.trim();
    final current = state.value;
    if (content.isEmpty || current == null) return;
    final placeholder = Comment(
      id: --_lastTempId,
      userId: ref.read(currentUserIdProvider),
      postId: postId,
      content: content,
      createdAt: DateTime.now(),
      authorName: authorName,
      authorAvatar: authorAvatar,
    );
    state = AsyncData(current.copyWith(added: [...current.added, placeholder]));
    _posts.addToCommentCount(postId, 1);

    final Comment saved;
    try {
      saved = await ref.read(communityRepositoryProvider).addComment(postId, content);
    } catch (_) {
      if (ref.mounted) {
        _mapAdded((added) => added.where((c) => c.id != placeholder.id).toList());
        _posts.addToCommentCount(postId, -1);
      }
      rethrow;
    }
    if (!ref.mounted) return;
    final echoed = state.value?.contains(saved.id) ?? false;
    _mapAdded(
      (added) => echoed
          // Realtime already delivered the row; drop the placeholder if it
          // is somehow still there.
          ? added.where((c) => c.id != placeholder.id).toList()
          : [
              for (final c in added)
                if (c.id == placeholder.id)
                  saved.copyWith(
                    authorName: saved.authorName ?? authorName,
                    authorAvatar: saved.authorAvatar ?? authorAvatar,
                  )
                else
                  c,
            ],
    );
  }

  void _mapAdded(List<Comment> Function(List<Comment> added) change) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(added: change(current.added)));
  }

  /// Removes an own comment; it comes back if the delete fails.
  Future<void> delete(Comment comment) async {
    final current = state.value;
    if (current == null || isPending(comment) || !current.contains(comment.id)) return;
    bool other(Comment c) => c.id != comment.id;
    state = AsyncData(
      current.copyWith(
        paged: current.paged.where(other).toList(),
        added: current.added.where(other).toList(),
      ),
    );
    _posts.addToCommentCount(postId, -1);
    try {
      await ref.read(communityRepositoryProvider).deleteComment(comment.id);
    } catch (_) {
      if (ref.mounted) {
        final latest = state.value ?? current;
        final wasPaged = current.paged.any((c) => c.id == comment.id);
        int byAge(Comment a, Comment b) {
          final at = a.createdAt, bt = b.createdAt;
          final byTime = (at == null || bt == null) ? 0 : at.compareTo(bt);
          return byTime != 0 ? byTime : a.id.compareTo(b.id);
        }

        state = AsyncData(
          latest.copyWith(
            paged: wasPaged ? ([...latest.paged, comment]..sort(byAge)) : null,
            added: wasPaged ? null : ([...latest.added, comment]..sort(byAge)),
          ),
        );
        _posts.addToCommentCount(postId, 1);
      }
      rethrow;
    }
  }
}

final commentsProvider = AsyncNotifierProvider.autoDispose
    .family<CommentsController, CommentsState, int>(CommentsController.new);
