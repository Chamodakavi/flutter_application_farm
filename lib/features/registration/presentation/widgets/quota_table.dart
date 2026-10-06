import 'package:flutter/material.dart';

import '../../../../core/l10n/crop_labels.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/farmer_registration.dart';

/// Crop | Amount (MT) | Date table of the farmer's locked-in quotas (matches
/// the web's "My Registered Quotas"). A status chip appears under the crop
/// when a matching `crop_registrations` row exists.
class QuotaTable extends StatelessWidget {
  const QuotaTable({super.key, required this.rows, this.statuses = const {}});

  final List<FarmerRegistration> rows;

  /// `crop_registrations.status` by UPPERCASE crop key.
  final Map<String, String> statuses;

  static const _cropFlex = 5, _amountFlex = 3, _dateFlex = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final header = text.labelSmall?.copyWith(color: AppColors.ink500);
    final locale = context.localeTag;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(flex: _cropFlex, child: Text(l10n.quotasColCrop, style: header)),
            Expanded(
              flex: _amountFlex,
              child: Text(l10n.quotasColAmount, style: header, textAlign: TextAlign.end),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: _dateFlex,
              child: Text(l10n.quotasColDate, style: header, textAlign: TextAlign.end),
            ),
          ],
        ),
        const Divider(height: AppSpacing.lg),
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const Divider(height: AppSpacing.lg),
          _row(context, rows[i], locale, text),
        ],
      ],
    );
  }

  Widget _row(BuildContext context, FarmerRegistration row, String locale, TextTheme text) {
    final status = statuses[row.cropName.trim().toUpperCase()];
    return Row(
      children: [
        Expanded(
          flex: _cropFlex,
          child: Row(
            children: [
              CropAvatar(row.cropName, size: 32),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CropLabels.of(context, row.cropName),
                      style: text.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (status != null)
                      Padding(padding: const EdgeInsets.only(top: 2), child: StatusChip(status)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: _amountFlex,
          child: Text(Fmt.amount(row.amountMt), style: text.titleSmall, textAlign: TextAlign.end),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: _dateFlex,
          child: Text(
            Fmt.date(row.registeredAt, locale),
            style: text.bodySmall,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
