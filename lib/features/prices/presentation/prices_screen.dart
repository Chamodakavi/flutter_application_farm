import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/crop_labels.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../registration/presentation/widgets/refreshable_async.dart';
import '../domain/price_series.dart';
import 'controllers/prices_controller.dart';
import 'widgets/price_list_tile.dart';

enum PriceSort { name, biggestRise, biggestFall, bestMargin }

/// Sorts list rows; rows without the sorted figure go last.
List<PriceSummary> sortPriceSummaries(
  List<PriceSummary> rows,
  PriceSort sort,
  String Function(String cropName) label,
) {
  int byName(PriceSummary a, PriceSummary b) => label(a.cropName).compareTo(label(b.cropName));
  int nullsLast(double? a, double? b, {required bool descending}) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return descending ? b.compareTo(a) : a.compareTo(b);
  }

  int compare(PriceSummary a, PriceSummary b) => switch (sort) {
    PriceSort.name => 0,
    PriceSort.biggestRise => nullsLast(a.changePct, b.changePct, descending: true),
    PriceSort.biggestFall => nullsLast(a.changePct, b.changePct, descending: false),
    PriceSort.bestMargin => nullsLast(a.marginPerKg, b.marginPerKg, descending: true),
  };

  return rows.toList()..sort((a, b) {
    final c = compare(a, b);
    return c != 0 ? c : byName(a, b);
  });
}

/// Crop Prices (spec §11.29): this month's wholesale price per crop, change
/// vs. last month, a six-month forecast sparkline and the fair-price chip.
class PricesScreen extends ConsumerStatefulWidget {
  const PricesScreen({super.key});

  @override
  ConsumerState<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends ConsumerState<PricesScreen> {
  PriceSort _sort = PriceSort.name;
  String _query = '';

  Future<void> _refresh() async {
    refreshPrices(ref);
    try {
      await ref.read(priceSummariesProvider.future);
    } catch (_) {
      // The error state is shown by the list.
    }
  }

  static String _sortLabel(AppLocalizations l10n, PriceSort sort) => switch (sort) {
    PriceSort.name => l10n.pricesSortAz,
    PriceSort.biggestRise => l10n.pricesSortRise,
    PriceSort.biggestFall => l10n.pricesSortFall,
    PriceSort.bestMargin => l10n.pricesSortMargin,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final summaries = ref.watch(priceSummariesProvider);
    final now = ref.watch(priceClockProvider)();

    DateTime? generatedAt;
    for (final row in summaries.value ?? const <PriceSummary>[]) {
      final at = row.generatedAt;
      if (at != null && (generatedAt == null || at.isAfter(generatedAt))) generatedAt = at;
    }

    return AppScaffold(
      title: l10n.pricesTitle,
      subtitle: generatedAt == null
          ? l10n.pricesSubtitleNoDate
          : l10n.pricesSubtitle(Fmt.date(generatedAt, context.localeTag)),
      actions: [
        IconButton(
          tooltip: l10n.plannerTitle,
          onPressed: () => context.push(Routes.planner),
          icon: const Icon(Icons.calculate_outlined),
        ),
      ],
      body: RefreshableAsync<List<PriceSummary>>(
        value: summaries,
        onRefresh: _refresh,
        isEmpty: (rows) => rows.isEmpty,
        empty: EmptyState(
          icon: Icons.show_chart_rounded,
          title: l10n.pricesEmptyTitle,
          message: l10n.pricesEmptyBody,
        ),
        builder: (all) {
          final rows = sortPriceSummaries(
            all.where((r) => CropLabels.matches(r.cropName, _query)).toList(),
            _sort,
            (crop) => CropLabels.of(context, crop),
          );
          return [
            TextField(
              onChanged: (v) => setState(() => _query = v),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.pricesSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final sort in PriceSort.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(_sortLabel(l10n, sort)),
                        selected: _sort == sort,
                        onSelected: (_) => setState(() => _sort = sort),
                      ),
                    ),
                ],
              ),
            ),
            if (isForecastStale(generatedAt, now)) ...[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TagChip(
                  l10n.pricesStale,
                  color: AppColors.orange600,
                  icon: Icons.history_toggle_off_rounded,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            if (rows.isEmpty)
              EmptyState(
                compact: true,
                icon: Icons.search_off_rounded,
                title: l10n.commonNoResults,
              )
            else
              for (final row in rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: PriceListTile(
                    summary: row,
                    onTap: () => context.push(Routes.priceDetail(row.cropName)),
                  ),
                ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.pricesFooterNote, style: text.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
          ];
        },
      ),
    );
  }
}
