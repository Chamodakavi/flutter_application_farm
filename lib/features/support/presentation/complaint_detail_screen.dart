import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/complaint.dart';
import 'controllers/complaints_controller.dart';

/// One Contact Support message with the admin's reply (spec §11.23). Loaded
/// by id so a "complaint reply" push can open it directly.
class ComplaintDetailScreen extends ConsumerStatefulWidget {
  const ComplaintDetailScreen({super.key, required this.complaintId});

  final int complaintId;

  @override
  ConsumerState<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends ConsumerState<ComplaintDetailScreen> {
  bool _markedRead = false;

  @override
  void initState() {
    super.initState();
    // Opening a reply marks it as read — once, as soon as the row is loaded.
    ref.listenManual(complaintProvider(widget.complaintId), (_, next) {
      final complaint = next.value;
      if (_markedRead || complaint == null || !complaint.hasUnreadReply) return;
      _markedRead = true;
      unawaited(ref.read(complaintsProvider.notifier).markRead(complaint));
    }, fireImmediately: true);
  }

  Future<void> _refresh() async {
    try {
      ref.invalidate(complaintProvider(widget.complaintId));
      await ref.read(complaintProvider(widget.complaintId).future);
    } catch (_) {
      // The error state offers Retry.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final complaint = ref.watch(complaintProvider(widget.complaintId));
    return AppScaffold(
      title: l10n.supportDetailTitle,
      body: AsyncValueView<Complaint>(
        value: complaint,
        onRetry: () => ref.invalidate(complaintProvider(widget.complaintId)),
        data: (c) => RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: AppSpacing.page,
            children: [
              _MessageCard(complaint: c),
              const SizedBox(height: AppSpacing.lg),
              if (c.hasReply)
                _ReplyBubble(complaint: c)
              else
                InfoNote(text: l10n.supportNoReplyYet, icon: Icons.schedule_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

/// What the farmer wrote.
class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.supportYourMessage, style: text.labelMedium?.copyWith(color: AppColors.ink500)),
          const SizedBox(height: AppSpacing.xs),
          SelectableText(complaint.subject, style: text.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StatusChip(complaint.chipStatus, showIcon: true),
              if (complaint.createdAt != null)
                Text(
                  l10n.supportSentOn(Fmt.dateTime(complaint.createdAt, context.localeTag)),
                  style: text.bodySmall,
                ),
            ],
          ),
          const Divider(height: AppSpacing.xxl),
          SelectableText(complaint.body, style: text.bodyLarge),
        ],
      ),
    );
  }
}

/// The admin's answer, as a chat-style bubble with its `replied_at` time.
class _ReplyBubble extends StatelessWidget {
  const _ReplyBubble({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(color: AppColors.green600, shape: BoxShape.circle),
          child: const Icon(Icons.support_agent_rounded, color: AppColors.white, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: AppColors.green100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.supportAdminReply,
                  style: text.labelMedium?.copyWith(color: AppColors.green600),
                ),
                const SizedBox(height: AppSpacing.xs),
                SelectableText(complaint.adminReply!.trim(), style: text.bodyLarge),
                if (complaint.repliedAt != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.supportRepliedOn(Fmt.dateTime(complaint.repliedAt, context.localeTag)),
                    style: text.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
