import 'package:flutter/material.dart';

import '../../../../core/l10n/crop_labels.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/bucket_rules.dart';
import '../../domain/bucket_status.dart';

/// Searchable list of crops with an active national target (spec §11.10).
/// Each row shows a mini fill bar and the remaining MT; full crops are listed
/// last and cannot be picked. Search works in English, Sinhala and Tamil.
class CropPickerSheet extends StatefulWidget {
  const CropPickerSheet({
    super.key,
    required this.buckets,
    required this.thresholds,
    this.selected,
  });

  final List<BucketStatus> buckets;
  final SurplusThresholds thresholds;

  /// Database key of the crop currently chosen.
  final String? selected;

  /// Resolves to the database key of the picked crop, or null when dismissed.
  static Future<String?> show(
    BuildContext context, {
    required List<BucketStatus> buckets,
    required SurplusThresholds thresholds,
    String? selected,
  }) => showAppBottomSheet<String>(
    context,
    title: context.l10n.registerSelectCrop,
    expand: true,
    builder: (_) => CropPickerSheet(buckets: buckets, thresholds: thresholds, selected: selected),
  );

  @override
  State<CropPickerSheet> createState() => _CropPickerSheetState();
}

class _CropPickerSheetState extends State<CropPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = sortForPicker(
      widget.buckets.where((b) => CropLabels.matches(b.cropName, _query)),
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.registerSearchCrop,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? EmptyState(icon: Icons.search_off_rounded, title: l10n.commonNoResults, compact: true)
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
                  itemBuilder: (context, index) {
                    final bucket = items[index];
                    return _CropRow(
                      bucket: bucket,
                      level: widget.thresholds.levelOf(bucket),
                      selected: bucket.key == widget.selected,
                      onTap: () => Navigator.of(context).pop(bucket.key),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CropRow extends StatelessWidget {
  const _CropRow({
    required this.bucket,
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final BucketStatus bucket;
  final SurplusLevel level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final full = level == SurplusLevel.full;
    final label = CropLabels.of(context, bucket.cropName);
    final english = CropLabels.english(bucket.cropName);

    return Opacity(
      opacity: full ? 0.55 : 1,
      child: InkWell(
        onTap: full ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              CropAvatar(bucket.cropName),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: text.titleSmall),
                    if (english != label) Text(english, style: text.bodySmall),
                    const SizedBox(height: 6),
                    QuotaProgressBar(
                      filledMt: bucket.filledMt,
                      limitMt: bucket.limitMt,
                      level: level,
                      showLabels: false,
                      height: 6,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.quotaRemaining(Fmt.amount(bucket.roomMt)),
                      style: text.bodySmall?.copyWith(color: level.color, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (full)
                const Flexible(child: SurplusChip(SurplusLevel.full))
              else if (selected)
                const Icon(Icons.check_circle_rounded, color: AppColors.green600)
              else
                const Icon(Icons.chevron_right_rounded, color: AppColors.ink500),
            ],
          ),
        ),
      ),
    );
  }
}
