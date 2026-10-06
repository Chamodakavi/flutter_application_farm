import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/news_types.dart';
import 'controllers/news_controller.dart';
import 'widgets/news_card.dart';
import 'widgets/news_type_chip.dart';

/// News list (spec §11.18): type filter chips, paginated cards, cached for
/// offline reading.
class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  /// Selected `n_type`; null shows everything.
  String? _type;

  Future<void> _refresh() async {
    try {
      await ref.read(newsListProvider.notifier).refresh();
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  bool _onScroll(ScrollNotification n) {
    if (n.metrics.axis == Axis.vertical && n.metrics.extentAfter < 400) {
      ref.read(newsListProvider.notifier).loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final news = ref.watch(newsListProvider);

    return AppScaffold(
      title: l10n.newsTitle,
      subtitle: l10n.newsSubtitle,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: AsyncValueView<NewsListState>(
          value: news,
          loading: const ShimmerList(itemHeight: 128),
          onRetry: () => ref.invalidate(newsListProvider),
          isEmpty: (state) => state.items.isEmpty,
          empty: _ScrollableFill(
            child: EmptyState(
              icon: Icons.article_outlined,
              title: l10n.newsEmptyTitle,
              message: l10n.newsEmptyMessage,
            ),
          ),
          data: (state) {
            final types = newsTypesOf(state.items);
            // A refresh can remove the selected type; fall back to "All".
            final selected = filterNewsByType(state.items, _type).isEmpty ? null : _type;
            final visible = filterNewsByType(state.items, selected);
            return Column(
              children: [
                if (types.isNotEmpty)
                  _TypeFilter(
                    types: types,
                    selected: selected,
                    onSelected: (type) => setState(() => _type = type),
                  ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _onScroll,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.sm,
                        AppSpacing.lg,
                        AppSpacing.xxl,
                      ),
                      itemCount: visible.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        if (index == visible.length) return _Footer(state: state);
                        final item = visible[index];
                        return NewsCard(
                          key: ValueKey(item.id),
                          news: item,
                          onTap: () => context.push(Routes.newsDetail(item.id)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// "All" plus one chip per type found in the loaded news.
class _TypeFilter extends StatelessWidget {
  const _TypeFilter({required this.types, required this.selected, required this.onSelected});

  final List<String> types;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedKey = selected?.toLowerCase();
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xs,
        ),
        child: Row(
          children: [
            ChoiceChip(
              label: Text(l10n.newsFilterAll),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
            for (final type in types) ...[
              const SizedBox(width: AppSpacing.sm),
              ChoiceChip(
                label: Text(newsTypeLabel(l10n, type)),
                selected: type.toLowerCase() == selectedKey,
                onSelected: (_) => onSelected(type),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// End of the list: spinner while loading, or a button to load the next
/// page (also the way forward when a filter leaves the list too short to
/// scroll).
class _Footer extends ConsumerWidget {
  const _Footer({required this.state});

  final NewsListState state;

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
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              l10n.newsLoadMoreFailed,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.ink500),
            ),
          ),
        TextButton.icon(
          onPressed: () => ref.read(newsListProvider.notifier).loadMore(retry: true),
          icon: Icon(state.loadMoreFailed ? Icons.refresh_rounded : Icons.expand_more_rounded),
          label: Text(state.loadMoreFailed ? l10n.commonRetry : l10n.newsLoadMore),
        ),
      ],
    );
  }
}

/// Lets a short child (empty state) be pulled to refresh.
class _ScrollableFill extends StatelessWidget {
  const _ScrollableFill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: child,
      ),
    ),
  );
}
