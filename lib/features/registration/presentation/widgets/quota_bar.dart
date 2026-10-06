import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/bucket_rules.dart';
import '../../domain/bucket_status.dart';

/// Fill bar of one crop with "filled of limit" and "remaining" underneath.
/// The two labels sit side by side when they fit and stack when they do not
/// (long Sinhala / Tamil text, large fonts), so the row never overflows.
class QuotaBar extends StatelessWidget {
  const QuotaBar({super.key, required this.bucket, required this.level});

  final BucketStatus bucket;
  final SurplusLevel level;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        QuotaProgressBar(
          filledMt: bucket.filledMt,
          limitMt: bucket.limitMt,
          level: level,
          showLabels: false,
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: AppSpacing.sm,
          children: [
            Text(
              l10n.quotaFilledOfLimit(Fmt.amount(bucket.filledMt), Fmt.amount(bucket.limitMt)),
              style: text.bodySmall,
            ),
            Text(
              l10n.quotaRemaining(Fmt.amount(bucket.roomMt)),
              style: text.bodySmall?.copyWith(color: level.color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
