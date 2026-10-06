import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/crop_labels.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/bucket_rules.dart';
import '../domain/bucket_status.dart';
import 'controllers/bucket_controller.dart';
import 'widgets/bucket_card.dart';
import 'widgets/bucket_live_scope.dart';
import 'widgets/refreshable_async.dart';

/// Crop Outlook — the national bucket (spec §11.12): demand vs. registered
/// supply for every active crop, so farmers can plan before planting.
class CropOutlookScreen extends ConsumerStatefulWidget {
  const CropOutlookScreen({super.key, this.availableOnly = false});

  /// Opens with the "Available" filter on (from the planner's alternatives).
  final bool availableOnly;

  @override
  ConsumerState<CropOutlookScreen> createState() => _CropOutlookScreenState();
}

class _CropOutlookScreenState extends ConsumerState<CropOutlookScreen> {
  late OutlookFilter _filter = widget.availableOnly ? OutlookFilter.available : OutlookFilter.all;
  OutlookSort _sort = OutlookSort.mostRoom;
  String _query = '';

  Future<void> _refresh() async {
    ref.invalidate(bucketStatusProvider);
    try {
      await ref.read(bucketStatusProvider.future);
    } catch (_) {
      // The error state is shown by the list.
    }
  }

  List<BucketStatus> _visible(List<BucketStatus> all, SurplusThresholds thresholds) {
    final rows = all
        .where((b) => _filter.matches(thresholds.levelOf(b)))
        .where((b) => CropLabels.matches(b.cropName, _query))
        .toList();
    int byName(BucketStatus a, BucketStatus b) =>
        CropLabels.of(context, a.cropName).compareTo(CropLabels.of(context, b.cropName));
    switch (_sort) {
      case OutlookSort.mostRoom:
        rows.sort((a, b) {
          final c = b.roomMt.compareTo(a.roomMt);
          return c != 0 ? c : byName(a, b);
        });
      case OutlookSort.highestPrice:
        rows.sort((a, b) {
          final c = (b.fairPrice ?? -1).compareTo(a.fairPrice ?? -1);
          return c != 0 ? c : byName(a, b);
        });
      case OutlookSort.name:
        rows.sort(byName);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bucketAsync = ref.watch(bucketStatusProvider);
    final thresholds = ref.watch(surplusThresholdsProvider);
    final savedAt = ref.watch(bucketSavedAtProvider);

    return AppScaffold(
      title: l10n.outlookTitle,
      subtitle: l10n.outlookSubtitle,
      actions: [
        IconButton(
          tooltip: l10n.pricesTitle,
          onPressed: () => context.push(Routes.prices),
          icon: const Icon(Icons.show_chart_rounded),
        ),
      ],
      body: BucketLiveScope(
        child: RefreshableAsync<List<BucketStatus>>(
          value: bucketAsync,
          onRefresh: _refresh,
          isEmpty: (all) => all.isEmpty,
          empty: EmptyState(
            icon: Icons.inventory_2_outlined,
            title: l10n.outlookEmptyTitle,
            message: l10n.outlookEmptyBody,
          ),
          builder: (all) {
            final rows = _visible(all, thresholds);
            return [
              TextField(
                onChanged: (v) => setState(() => _query = v),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.outlookSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _ChipRow(
                children: [
                  for (final filter in OutlookFilter.values)
                    ChoiceChip(
                      label: Text(_filterLabel(l10n, filter)),
                      selected: _filter == filter,
                      onSelected: (_) => setState(() => _filter = filter),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      savedAt == null
                          ? l10n.outlookCropCount(rows.length)
                          : '${l10n.outlookCropCount(rows.length)} · '
                                '${l10n.commonUpdatedAgo(context.relativeTime(savedAt))}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: _SortButton(
                      value: _sort,
                      onChanged: (sort) => setState(() => _sort = sort),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const _Legend(),
              const SizedBox(height: AppSpacing.md),
              if (rows.isEmpty)
                EmptyState(
                  compact: true,
                  icon: Icons.search_off_rounded,
                  title: l10n.outlookNoMatch,
                )
              else
                for (final bucket in rows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: BucketCard(
                      bucket: bucket,
                      level: thresholds.levelOf(bucket),
                      onTap: () => context.push(Routes.outlookCrop(bucket.key)),
                    ),
                  ),
            ];
          },
        ),
      ),
    );
  }

  static String _filterLabel(AppLocalizations l10n, OutlookFilter filter) => switch (filter) {
    OutlookFilter.all => l10n.outlookFilterAll,
    OutlookFilter.available => l10n.outlookFilterAvailable,
    OutlookFilter.almostFull => l10n.outlookFilterAlmostFull,
    OutlookFilter.full => l10n.outlookFilterFull,
  };
}

/// Chips on one horizontally scrolling line.
class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (final child in children)
          Padding(padding: const EdgeInsets.only(right: AppSpacing.sm), child: child),
      ],
    ),
  );
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.value, required this.onChanged});

  final OutlookSort value;
  final ValueChanged<OutlookSort> onChanged;

  static String _label(AppLocalizations l10n, OutlookSort sort) => switch (sort) {
    OutlookSort.mostRoom => l10n.outlookSortMostRoom,
    OutlookSort.highestPrice => l10n.outlookSortHighestPrice,
    OutlookSort.name => l10n.outlookSortAz,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<OutlookSort>(
      tooltip: l10n.outlookSortLabel,
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (_) => [
        for (final sort in OutlookSort.values)
          PopupMenuItem(value: sort, child: Text(_label(l10n, sort))),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTap),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_rounded, size: 18, color: AppColors.forest900),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(_label(l10n, value), style: Theme.of(context).textTheme.labelMedium),
            ),
          ],
        ),
      ),
    );
  }
}

/// Colour key for the four surplus levels.
class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final level in SurplusLevel.values)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: level.color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(child: Text(level.label(l10n), style: text.bodySmall)),
            ],
          ),
      ],
    );
  }
}
