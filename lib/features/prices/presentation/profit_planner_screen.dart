import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/l10n/crop_labels.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../registration/domain/bucket_rules.dart';
import '../../registration/presentation/controllers/bucket_controller.dart';
import '../../registration/presentation/widgets/land_to_tonnes_sheet.dart' show LandUnitToggle;
import '../../registration/presentation/widgets/refreshable_async.dart';
import '../domain/price_forecast.dart';
import '../domain/price_series.dart';
import '../domain/profit_plan.dart';
import 'controllers/prices_controller.dart';
import 'widgets/profit_result_card.dart';

/// Upcoming forecast rows (this month on, at most 12) per crop key. [rows]
/// must already hold one model version per crop.
Map<String, List<PriceForecast>> upcomingByCrop(Iterable<PriceForecast> rows, DateTime now) {
  final thisMonth = monthOf(now);
  final byCrop = <String, List<PriceForecast>>{};
  for (final row in rows) {
    if (row.harvestDate.isBefore(thisMonth)) continue;
    byCrop.putIfAbsent(cropKey(row.cropName), () => []).add(row);
  }
  for (final entry in byCrop.entries.toList()) {
    final sorted = entry.value..sort((a, b) => a.harvestDate.compareTo(b.harvestDate));
    byCrop[entry.key] = sorted.take(12).toList();
  }
  return byCrop;
}

/// Parses the `month=yyyy-MM` route parameter.
DateTime? parsePlannerMonth(String? value) {
  final match = RegExp(r'^(\d{4})-(\d{1,2})$').firstMatch(value?.trim() ?? '');
  if (match == null) return null;
  final month = int.parse(match[2]!);
  return (month < 1 || month > 12) ? null : DateTime(int.parse(match[1]!), month);
}

/// Profit Planner (spec §11.31): crop + harvest month + land size → expected
/// harvest, cost, income and profit, straight from the model's numbers.
/// Pure client-side maths on cached forecasts, so it also works offline.
class ProfitPlannerScreen extends ConsumerStatefulWidget {
  const ProfitPlannerScreen({super.key, this.initialCrop, this.initialMonth});

  /// Database crop key.
  final String? initialCrop;

  /// Harvest month as `yyyy-MM`.
  final String? initialMonth;

  @override
  ConsumerState<ProfitPlannerScreen> createState() => _ProfitPlannerScreenState();
}

class _ProfitPlannerScreenState extends ConsumerState<ProfitPlannerScreen> {
  static const _maxCompare = 3;

  final _land = TextEditingController();
  final _usage = Debouncer(delay: const Duration(seconds: 2));

  String? _crop;
  DateTime? _month;
  LandUnit _unit = LandUnit.acres;
  final List<String> _compare = [];
  String? _lastTracked;

  @override
  void initState() {
    super.initState();
    final crop = widget.initialCrop?.trim() ?? '';
    if (crop.isNotEmpty) _crop = cropKey(crop);
    _month = parsePlannerMonth(widget.initialMonth);
  }

  @override
  void dispose() {
    _usage.dispose();
    _land.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    refreshPrices(ref);
    ref.invalidate(bucketStatusProvider);
    try {
      await ref.read(priceForecastsProvider.future);
    } catch (_) {
      // The error state is shown by the list.
    }
  }

  double? get _landSize {
    final size = double.tryParse(_land.text.trim());
    return (size == null || size <= 0) ? null : size;
  }

  /// The row planned for: the chosen month, else the best month of the crop.
  PriceForecast? _selectedRow(List<PriceForecast> months) {
    final month = _month;
    if (month != null) {
      for (final row in months) {
        if (row.isFor(month.year, month.month)) return row;
      }
    }
    return bestHarvestMonth(months);
  }

  ProfitPlan? _planFor(PriceForecast? row) {
    final size = _landSize;
    return (row == null || size == null) ? null : ProfitPlan.forLand(row, size, _unit);
  }

  /// Any input changed: rebuild now, and report the settled plan once.
  void _changed(VoidCallback update) {
    setState(update);
    _usage.run(_trackUsage);
  }

  void _trackUsage() {
    if (!mounted) return;
    final crop = _crop;
    final rows = ref.read(priceForecastsProvider).value;
    if (crop == null || rows == null) return;
    final months = upcomingByCrop(rows, ref.read(priceClockProvider)())[crop] ?? const [];
    final plan = _planFor(_selectedRow(months));
    if (plan == null) return;
    final landHa = Fmt.round(plan.landHa, 2);
    final signature = '$crop|${plan.forecast.year}-${plan.forecast.month}|$landHa';
    if (signature == _lastTracked) return;
    _lastTracked = signature;
    ref.read(analyticsProvider).track(AnalyticsEvents.plannerUsed, {
      'crop': crop,
      'land_ha': landHa,
      'profit': plan.profitSign,
    });
  }

  String _cropItemLabel(String crop) {
    final label = CropLabels.of(context, crop);
    final english = CropLabels.english(crop);
    return english == label ? label : '$label · $english';
  }

  Future<void> _addCompare(List<String> candidates) async {
    final l10n = context.l10n;
    final picked = await showAppBottomSheet<String>(
      context,
      title: l10n.plannerCompareAdd,
      builder: (sheetContext) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        children: [
          for (final crop in candidates)
            ListTile(
              leading: CropAvatar(crop, size: 36),
              title: Text(_cropItemLabel(crop)),
              onTap: () => Navigator.of(sheetContext).pop(crop),
            ),
        ],
      ),
    );
    if (picked != null && mounted && !_compare.contains(picked)) {
      setState(() => _compare.add(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final forecasts = ref.watch(priceForecastsProvider);
    final now = ref.watch(priceClockProvider)();

    return AppScaffold(
      title: l10n.plannerTitle,
      subtitle: l10n.plannerSubtitle,
      body: RefreshableAsync<List<PriceForecast>>(
        value: forecasts,
        onRefresh: _refresh,
        isEmpty: (rows) => upcomingByCrop(rows, now).isEmpty,
        empty: EmptyState(
          icon: Icons.calculate_outlined,
          title: l10n.plannerNoForecastTitle,
          message: l10n.plannerNoForecastBody,
        ),
        builder: (rows) => _content(context, upcomingByCrop(rows, now)),
      ),
    );
  }

  List<Widget> _content(BuildContext context, Map<String, List<PriceForecast>> byCrop) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final locale = context.localeTag;

    final crops = byCrop.keys.toList()
      ..sort((a, b) => CropLabels.of(context, a).compareTo(CropLabels.of(context, b)));
    final crop = byCrop.containsKey(_crop) ? _crop : null;
    final months = crop == null ? const <PriceForecast>[] : byCrop[crop]!;
    final best = bestHarvestMonth(months);
    final selected = _selectedRow(months);
    final plan = _planFor(selected);
    final size = _landSize;

    return [
      SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDropdownField<String>(
              label: l10n.plannerCrop,
              hint: l10n.plannerCropHint,
              items: crops,
              value: crop,
              searchable: true,
              itemLabel: _cropItemLabel,
              leadingBuilder: (c) => CropAvatar(c, size: 36),
              onChanged: (c) => _changed(() {
                _crop = c;
                _month = null;
                _compare.remove(c);
              }),
            ),
            if (months.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.plannerMonth, style: text.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final row in months)
                    ChoiceChip(
                      label: Text(
                        identical(row, best)
                            ? '⭐ ${Fmt.monthShort(row.harvestDate, locale)}'
                            : Fmt.monthShort(row.harvestDate, locale),
                      ),
                      selected: identical(row, selected),
                      onSelected: (_) => _changed(() => _month = row.harvestDate),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.plannerBestMonthHint, style: text.bodySmall),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.plannerLand, style: text.labelMedium),
            const SizedBox(height: AppSpacing.sm),
            LandUnitToggle(value: _unit, onChanged: (unit) => _changed(() => _unit = unit)),
            const SizedBox(height: AppSpacing.md),
            AppTextField.number(
              label: _unit == LandUnit.acres ? l10n.plannerAcres : l10n.plannerHectares,
              controller: _land,
              decimal: true,
              hint: l10n.plannerLandHint,
              prefixIcon: Icons.straighten_rounded,
              helper: (size != null && _unit == LandUnit.acres)
                  ? l10n.plannerLandInHa(Fmt.amount(_unit.toHa(size)))
                  : null,
              onChanged: (_) => _changed(() {}),
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      if (crop == null)
        InfoNote(text: l10n.plannerPickCrop)
      else if (plan == null)
        InfoNote(text: l10n.plannerEnterLand)
      else ...[
        ProfitResultCard(plan: plan, footer: _QuotaRoom(crop: crop, plan: plan)),
        const SizedBox(height: AppSpacing.lg),
        _CompareCard(
          crop: crop,
          plan: plan,
          compare: _compare,
          byCrop: byCrop,
          landHa: plan.landHa,
          canAdd: _compare.length < _maxCompare && crops.length > _compare.length + 1,
          onAdd: () => _addCompare(
            crops.where((c) => c != crop && !_compare.contains(c)).toList(),
          ),
          onRemove: (c) => setState(() => _compare.remove(c)),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: l10n.plannerRegisterCta(
            Fmt.amount(plan.expectedMt ?? 0),
            CropLabels.of(context, crop),
          ),
          icon: Icons.verified_outlined,
          // Register is a bottom-navigation tab: switch to it, prefilled.
          onPressed: (plan.expectedMt ?? 0) < 0.01
              ? null
              : () => context.go(
                  Routes.registerWith(crop: crop, amountMt: Fmt.round(plan.expectedMt!, 2)),
                ),
        ),
      ],
      const SizedBox(height: AppSpacing.md),
      Text(l10n.plannerDisclaimer, style: text.bodySmall, textAlign: TextAlign.center),
      const SizedBox(height: AppSpacing.lg),
    ];
  }
}

/// "{remaining} MT left — your {MT} MT fits ✅" or the warning with a link to
/// crops that still have room.
class _QuotaRoom extends ConsumerWidget {
  const _QuotaRoom({required this.crop, required this.plan});

  final String crop;
  final ProfitPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bucket = ref.watch(bucketForCropProvider(crop));
    final amount = plan.expectedMt;
    if (bucket == null || amount == null) return const SizedBox.shrink();
    final room = Fmt.amount(bucket.roomMt);
    if (bucket.fits(amount)) {
      return InfoNote(
        tone: InfoNoteTone.success,
        text: l10n.plannerQuotaFits(room, Fmt.amount(amount)),
      );
    }
    return InfoNote(
      tone: InfoNoteTone.warning,
      text: l10n.plannerQuotaExceeds(room, Fmt.amount(amount)),
      actionLabel: l10n.plannerSeeAlternatives,
      onAction: () => context.push(Routes.outlookAvailable),
    );
  }
}

/// Side-by-side profit table for up to three more crops on the same land and
/// harvest month; the highest profit is highlighted.
class _CompareCard extends StatelessWidget {
  const _CompareCard({
    required this.crop,
    required this.plan,
    required this.compare,
    required this.byCrop,
    required this.landHa,
    required this.canAdd,
    required this.onAdd,
    required this.onRemove,
  });

  final String crop;
  final ProfitPlan plan;
  final List<String> compare;
  final Map<String, List<PriceForecast>> byCrop;
  final double landHa;
  final bool canAdd;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  ProfitPlan? _planOf(String other) {
    for (final row in byCrop[other] ?? const <PriceForecast>[]) {
      if (row.isFor(plan.forecast.year, plan.forecast.month)) {
        return ProfitPlan(forecast: row, landHa: landHa);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final columns = <String, ProfitPlan?>{crop: plan, for (final c in compare) c: _planOf(c)};

    String? winner;
    for (final entry in columns.entries) {
      final profit = entry.value?.profitLkr;
      if (profit == null) continue;
      if (winner == null || profit > columns[winner]!.profitLkr!) winner = entry.key;
    }

    Widget cell(String value, {bool header = false, bool highlight = false, Color? color}) =>
        Container(
          color: highlight ? AppColors.green100 : null,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          alignment: header ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
          child: Text(
            value,
            style: (header ? text.bodySmall : text.titleSmall)?.copyWith(color: color),
          ),
        );

    TableRow row(String label, String Function(ProfitPlan plan) value, {bool profit = false}) =>
        TableRow(
          children: [
            cell(label, header: true),
            for (final entry in columns.entries)
              cell(
                entry.value == null ? '—' : value(entry.value!),
                highlight: entry.key == winner,
                color: !profit || entry.value?.profitLkr == null
                    ? null
                    : (entry.value!.isLoss ? AppColors.red600 : AppColors.green600),
              ),
          ],
        );

    return SectionCard(
      title: l10n.plannerCompareTitle,
      subtitle: l10n.plannerCompareSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (compare.isNotEmpty) ...[
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                for (final c in compare)
                  InputChip(
                    label: Text(CropLabels.of(context, c)),
                    onDeleted: () => onRemove(c),
                    deleteButtonTooltipMessage: l10n.plannerCompareRemove(CropLabels.of(context, c)),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: const TableBorder(
                  horizontalInside: BorderSide(color: AppColors.line200),
                ),
                children: [
                  TableRow(
                    children: [
                      cell('', header: true),
                      for (final entry in columns.entries)
                        Container(
                          color: entry.key == winner ? AppColors.green100 : null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          alignment: AlignmentDirectional.centerEnd,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(CropLabels.of(context, entry.key), style: text.labelMedium),
                              if (entry.key == winner)
                                Text(
                                  l10n.plannerCompareBest,
                                  style: text.bodySmall?.copyWith(color: AppColors.green600),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  row(l10n.plannerShortHarvest, (p) => Fmt.mt(p.expectedMt)),
                  row(l10n.plannerShortCost, (p) => Fmt.rsWhole(p.costLkr)),
                  row(l10n.plannerShortIncome, (p) => Fmt.rsWhole(p.revenueLkr)),
                  row(l10n.plannerShortProfit, (p) => Fmt.rsWhole(p.profitLkr), profit: true),
                ],
              ),
            ),
            if (columns.values.any((p) => p == null)) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.plannerCompareNoData, style: text.bodySmall),
            ],
            const SizedBox(height: AppSpacing.md),
          ],
          SecondaryButton(
            label: l10n.plannerCompareAdd,
            icon: Icons.add_rounded,
            onPressed: canAdd ? onAdd : null,
          ),
        ],
      ),
    );
  }
}
