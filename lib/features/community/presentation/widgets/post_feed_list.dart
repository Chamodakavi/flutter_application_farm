import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../controllers/feed_controller.dart';
import 'post_card.dart';

/// Scrolling list of posts with pull-to-refresh and infinite scroll — shared
/// by the community feed, My Posts and Saved Posts (spec §11.19, §11.22).
class PostFeedList extends ConsumerStatefulWidget {
  const PostFeedList({
    super.key,
    required this.kind,
    this.header,
    required this.emptyTitle,
    this.emptyMessage,
    this.emptyIcon = Icons.forum_outlined,
    this.emptyActionLabel,
    this.onEmptyAction,
    this.bottomPadding = AppSpacing.xxl,
  });

  final FeedKind kind;

  /// Scrolls with the list, above the first post (composer, shortcut chips).
  final Widget? header;
  final String emptyTitle;
  final String? emptyMessage;
  final IconData emptyIcon;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;

  /// Tab screens pass `kFabClearance` so the chat bubble never hides a post.
  final double bottomPadding;

  @override
  ConsumerState<PostFeedList> createState() => _PostFeedListState();
}

class _PostFeedListState extends ConsumerState<PostFeedList> {
  Future<void> _refresh() async {
    ref
      ..invalidate(myPostsCountProvider)
      ..invalidate(savedPostsCountProvider);
    try {
      await ref.read(feedProvider(widget.kind).notifier).refresh();
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical && metrics.extentAfter < 600) {
      ref.read(feedProvider(widget.kind).notifier).loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = feedProvider(widget.kind);
    final feed = ref.watch(provider);
    final state = feed.value;
    final header = widget.header;

    final Widget content;
    if (state != null && state.ids.isNotEmpty) {
      final ids = state.ids;
      content = SliverPadding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
        sliver: SliverList.builder(
          itemCount: ids.length + 1,
          itemBuilder: (context, index) => index == ids.length
              ? _FeedFooter(kind: widget.kind, state: state)
              : PostCard(
                  key: ValueKey(ids[index]),
                  postId: ids[index],
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                ),
        ),
      );
    } else if (state == null && !feed.hasError) {
      content = const SliverToBoxAdapter(
        child: ShimmerList(itemCount: 3, itemHeight: 200, shrinkWrap: true),
      );
    } else {
      // Error with nothing to show, or an empty feed.
      content = SliverFillRemaining(
        hasScrollBody: false,
        child: AsyncValueView<FeedState>(
          value: feed,
          onRetry: () => ref.invalidate(provider),
          isEmpty: (_) => true,
          empty: EmptyState(
            icon: widget.emptyIcon,
            title: widget.emptyTitle,
            message: widget.emptyMessage,
            actionLabel: widget.emptyActionLabel,
            onAction: widget.onEmptyAction,
          ),
          data: (_) => const SizedBox.shrink(),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (header != null)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                sliver: SliverToBoxAdapter(child: header),
              ),
            content,
            SliverToBoxAdapter(child: SizedBox(height: widget.bottomPadding)),
          ],
        ),
      ),
    );
  }
}

/// End of the list: spinner while the next page loads, Retry after a failure.
class _FeedFooter extends ConsumerWidget {
  const _FeedFooter({required this.kind, required this.state});

  final FeedKind kind;
  final FeedState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (state.loadingMore) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (!state.hasMore) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state.loadMoreFailed)
          Text(
            l10n.communityLoadMoreFailed,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.ink500),
          ),
        TextButton.icon(
          onPressed: () => ref.read(feedProvider(kind).notifier).loadMore(retry: true),
          icon: Icon(state.loadMoreFailed ? Icons.refresh_rounded : Icons.expand_more_rounded),
          label: Text(state.loadMoreFailed ? l10n.commonRetry : l10n.communityLoadMore),
        ),
      ],
    );
  }
}
