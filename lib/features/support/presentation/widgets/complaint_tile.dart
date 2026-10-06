import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/complaint.dart';
import '../controllers/complaints_controller.dart';

/// One row of "My Sent Messages": subject, date, status and whether the admin
/// has replied (spec §11.23).
class ComplaintTile extends StatelessWidget {
  const ComplaintTile({super.key, required this.complaint, this.onTap});

  final Complaint complaint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final unread = complaint.hasUnreadReply;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTap),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaint.subject,
                      style: text.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(Fmt.date(complaint.createdAt, context.localeTag), style: text.bodySmall),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusChip(complaint.chipStatus),
                        if (complaint.hasReply)
                          TagChip(l10n.supportAdminReplied, icon: Icons.mark_chat_read_outlined),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (unread)
                // A reply the farmer has not opened yet.
                Semantics(
                  label: l10n.supportNewReply,
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 6, right: AppSpacing.xs),
                    decoration: const BoxDecoration(
                      color: AppColors.orange600,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.ink500),
            ],
          ),
        ),
      ),
    );
  }
}
