import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
import '../domain/comment.dart';
import 'controllers/feed_controller.dart';
import 'controllers/post_controller.dart';
import 'widgets/comment_input.dart';
import 'widgets/comment_tile.dart';
import 'widgets/post_card.dart';

/// A post with its comments (oldest first) and a sticky comment box
/// (spec §11.21). Loads by id, so shared links open it directly.
class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({super.key, required this.postId, this.focusComment = false});

  final int postId;

  /// Opens the keyboard on the comment box (the "Comment" action of a post).
  final bool focusComment;

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Back to where the user came from; a deep link has nothing to pop to.
  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.community);
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<bool> _send(String text) async {
    final profile = ref.read(profileProvider).value;
    final sending = ref
        .read(commentsProvider(widget.postId).notifier)
        .add(text, authorName: profile?.displayName, authorAvatar: profile?.avatarUrl);
    _scrollToEnd();
    try {
      await sending;
      return true;
    } catch (e) {
      if (mounted) context.showError(e);
      return false;
    }
  }

  Future<void> _deleteComment(Comment comment) async {
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.postCommentDeleteTitle,
      confirmLabel: l10n.commonDelete,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    try {
      await ref.read(commentsProvider(widget.postId).notifier).delete(comment);
      if (mounted) context.showSnack(l10n.postCommentDeleted);
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  Future<void> _loadMoreComments() async {
    try {
      await ref.read(commentsProvider(widget.postId).notifier).loadMore();
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  Future<void> _refresh() async {
    ref.invalidate(postLoadProvider(widget.postId));
    ref.invalidate(commentsProvider(widget.postId));
    try {
      await ref.read(postLoadProvider(widget.postId).future);
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final postId = widget.postId;
    final hasPost = ref.watch(postByIdProvider(postId).select((post) => post != null));
    final load = ref.watch(postLoadProvider(postId));

    final Widget body;
    if (hasPost) {
      final comments = ref.watch(commentsProvider(postId));
      body = Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: _PostAndComments(
                postId: postId,
                comments: comments,
                controller: _scroll,
                onPostDeleted: _leave,
                onDeleteComment: _deleteComment,
                onLoadMore: _loadMoreComments,
                onRetry: () => ref.invalidate(commentsProvider(postId)),
              ),
            ),
          ),
          CommentInput(autofocus: widget.focusComment, enabled: comments.hasValue, onSend: _send),
        ],
      );
    } else if (load.hasError) {
      body = ErrorState(error: load.error, onRetry: () => ref.invalidate(postLoadProvider(postId)));
    } else if (load.isLoading) {
      body = const ShimmerList(itemCount: 2, itemHeight: 220);
    } else {
      // The post was just deleted; the screen is closing.
      body = const SizedBox.shrink();
    }

    return AppScaffold(title: l10n.postDetailTitle, body: body);
  }
}

class _PostAndComments extends ConsumerWidget {
  const _PostAndComments({
    required this.postId,
    required this.comments,
    required this.controller,
    required this.onPostDeleted,
    required this.onDeleteComment,
    required this.onLoadMore,
    required this.onRetry,
  });

  final int postId;
  final AsyncValue<CommentsState> comments;
  final ScrollController controller;
  final VoidCallback onPostDeleted;
  final ValueChanged<Comment> onDeleteComment;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final me = ref.watch(currentUserIdProvider);
    final profile = ref.watch(profileProvider).value;
    final state = comments.value;

    Widget tile(Comment comment) {
      final mine = me != null && comment.userId == me;
      final pending = CommentsController.isPending(comment);
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: CommentTile(
          key: ValueKey(comment.id),
          comment: comment,
          pending: pending,
          fallbackName: mine ? profile?.displayName : null,
          fallbackAvatar: mine ? profile?.avatarUrl : null,
          onLongPress: mine && !pending ? () => onDeleteComment(comment) : null,
        ),
      );
    }

    final Widget list;
    if (state != null && !state.isEmpty) {
      final paged = state.paged;
      final added = state.added;
      final more = state.hasMore ? 1 : 0;
      list = SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        sliver: SliverList.builder(
          itemCount: paged.length + more + added.length,
          itemBuilder: (context, index) {
            if (index < paged.length) return tile(paged[index]);
            if (index == paged.length && state.hasMore) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: state.loadingMore
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton.icon(
                        onPressed: onLoadMore,
                        icon: const Icon(Icons.expand_more_rounded),
                        label: Text(l10n.postCommentsLoadMore),
                      ),
              );
            }
            return tile(added[index - paged.length - more]);
          },
        ),
      );
    } else {
      list = SliverToBoxAdapter(
        child: AsyncValueView<CommentsState>(
          value: comments,
          compact: true,
          onRetry: onRetry,
          isEmpty: (_) => true,
          empty: EmptyState(
            compact: true,
            icon: Icons.mode_comment_outlined,
            title: l10n.postNoComments,
            message: l10n.postNoCommentsMessage,
          ),
          data: (_) => const SizedBox.shrink(),
        ),
      );
    }

    return CustomScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: AppSpacing.page,
          sliver: SliverToBoxAdapter(
            child: PostCard(postId: postId, detail: true, onDeleted: onPostDeleted),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: Text(l10n.postComments, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
        list,
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
      ],
    );
  }
}
