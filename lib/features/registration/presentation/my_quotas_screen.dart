import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/farmer_registration.dart';
import 'controllers/register_controller.dart';
import 'widgets/quota_table.dart';
import 'widgets/refreshable_async.dart';

/// Full list of the farmer's own `farmer_registrations`, newest first, with a
/// total-MT summary (spec §11.11).
class MyQuotasScreen extends ConsumerWidget {
  const MyQuotasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final registrations = ref.watch(myRegistrationsProvider);
    final statuses = ref.watch(cropRegistrationStatusProvider);

    Future<void> refresh() async {
      ref.invalidate(myRegistrationsProvider);
      ref.invalidate(myCropRegistrationsProvider);
      try {
        await ref.read(myRegistrationsProvider.future);
      } catch (_) {
        // The error state is shown by the list.
      }
    }

    return AppScaffold(
      title: l10n.quotasTitle,
      subtitle: l10n.quotasSubtitle,
      body: RefreshableAsync<List<FarmerRegistration>>(
        value: registrations,
        onRefresh: refresh,
        isEmpty: (rows) => rows.isEmpty,
        empty: EmptyState(
          icon: Icons.assignment_outlined,
          title: l10n.quotasEmptyTitle,
          message: l10n.quotasEmptyBody,
          actionLabel: l10n.quotasEmptyAction,
          // Register is a bottom-navigation tab: switch to it.
          onAction: () => context.go(Routes.register),
        ),
        builder: (rows) => [
          _TotalCard(rows: rows),
          const SizedBox(height: AppSpacing.lg),
          SectionCard(
            title: l10n.quotasTitle,
            trailing: TagChip(l10n.recordsCount(rows.length)),
            child: QuotaTable(rows: rows, statuses: statuses),
          ),
          const SizedBox(height: AppSpacing.lg),
          InfoNote(
            text: l10n.quotasLockedNote,
            actionLabel: l10n.quotasRequestChange,
            onAction: () => context.push(Routes.supportWith(l10n.quotasChangeSubject)),
          ),
        ],
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.rows});

  final List<FarmerRegistration> rows;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final total = rows.fold<double>(0, (sum, r) => sum + r.amountMt);
    final crops = rows.map((r) => r.cropName.trim().toUpperCase()).toSet().length;
    return SectionCard(
      color: AppColors.cream50,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: AppColors.green100, shape: BoxShape.circle),
            child: const Icon(Icons.scale_outlined, color: AppColors.green600),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.quotasTotal, style: text.labelMedium),
                Text(Fmt.mt(total), key: const Key('quotas-total'), style: text.displaySmall),
                Text(l10n.quotasCropCount(crops), style: text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
