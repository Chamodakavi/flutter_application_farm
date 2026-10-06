import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/crop_labels.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../news/domain/news.dart';
import '../../../news/presentation/controllers/news_controller.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../../registration/domain/farmer_registration.dart';
import '../../../registration/presentation/controllers/register_controller.dart';

/// Forest hero card: greeting and the two main calls to action.
class WelcomeHero extends ConsumerWidget {
  const WelcomeHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final name = ref.watch(profileProvider.select((p) => p.value?.name?.trim()));
    return HeroCard(
      pillLabel: l10n.homePill,
      title: l10n.homeWelcome((name == null || name.isEmpty) ? l10n.homeFarmerFallback : name),
      text: l10n.homeHeroText,
      actions: [
        PillButton(
          label: l10n.homeRegisterCrop,
          icon: Icons.eco_rounded,
          onPressed: () => context.go(Routes.register),
        ),
        PillButton(
          label: l10n.homeMarketplace,
          icon: Icons.storefront_outlined,
          style: PillStyle.outlinedLight,
          onPressed: () => context.go(Routes.market),
        ),
      ],
    );
  }
}

/// Four shortcut tiles in a 2×2 grid.
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tiles = [
      QuickActionTile(
        icon: Icons.eco_rounded,
        title: l10n.homeActionRegister,
        subtitle: l10n.homeActionRegisterSub,
        onTap: () => context.go(Routes.register),
      ),
      QuickActionTile(
        icon: Icons.calculate_outlined,
        title: l10n.homeActionPlan,
        subtitle: l10n.homeActionPlanSub,
        tint: AppColors.amber200,
        iconColor: AppColors.orange600,
        onTap: () => context.push(Routes.planner),
      ),
      QuickActionTile(
        icon: Icons.storefront_outlined,
        title: l10n.homeActionBrowse,
        subtitle: l10n.homeActionBrowseSub,
        tint: AppColors.cream50,
        iconColor: AppColors.forest900,
        onTap: () => context.go(Routes.market),
      ),
      QuickActionTile(
        icon: Icons.chat_bubble_outline_rounded,
        title: l10n.homeActionAsk,
        subtitle: l10n.homeActionAskSub,
        tint: AppColors.blue100,
        iconColor: AppColors.blue600,
        onTap: () => context.push(Routes.chat),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.homeQuickActions, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        EqualHeightGrid(children: tiles),
      ],
    );
  }
}

/// Two-column grid whose rows are as tall as their tallest cell — unlike a
/// fixed-aspect `GridView`, it cannot overflow with long translations.
class EqualHeightGrid extends StatelessWidget {
  const EqualHeightGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < children.length; i += 2) ...[
        if (i > 0) const SizedBox(height: AppSpacing.md),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: children[i]),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: i + 1 < children.length ? children[i + 1] : const SizedBox()),
            ],
          ),
        ),
      ],
    ],
  );
}

/// The farmer's latest three registrations with a status chip.
class MyRegistrationsCard extends ConsumerWidget {
  const MyRegistrationsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    // `crop_registrations` carries the approval status (spec §22.1); a quota
    // accepted by `register_harvest` without such a row shows as Approved,
    // matching the web dashboard.
    final statuses = {
      for (final c
          in ref.watch(myCropRegistrationsProvider).value ?? const <CropRegistration>[])
        c.cropName.toUpperCase(): c.status,
    };
    return SectionCard(
      title: l10n.homeMyRegistrations,
      trailing: TextButton.icon(
        onPressed: () => context.go(Routes.register),
        iconAlignment: IconAlignment.end,
        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
        label: Text(l10n.homeRegisterLink),
      ),
      child: AsyncValueView<List<FarmerRegistration>>(
        value: ref.watch(myRegistrationsProvider),
        compact: true,
        onRetry: () => ref.invalidate(myRegistrationsProvider),
        empty: EmptyState(
          compact: true,
          title: l10n.homeNoRegistrations,
          message: l10n.homeNoRegistrationsBody,
        ),
        data: (rows) => Column(
          children: [
            for (final r in rows.take(3))
              InkWell(
                onTap: () => context.push(Routes.myQuotas),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      CropAvatar(r.cropName, size: 40),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(CropLabels.of(context, r.cropName), style: text.titleSmall),
                            Text(
                              l10n.homeMtRegistered(Fmt.amount(r.amountMt)),
                              style: text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: StatusChip(statuses[r.cropName.toUpperCase()] ?? 'Approved'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Three compact news rows.
class LatestNewsStrip extends ConsumerWidget {
  const LatestNewsStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return SectionCard(
      title: l10n.homeLatestNews,
      trailing: TextButton(
        onPressed: () => context.push(Routes.news),
        child: Text(l10n.commonSeeAll),
      ),
      child: AsyncValueView<List<News>>(
        value: ref.watch(latestNewsProvider),
        compact: true,
        onRetry: () => ref.invalidate(latestNewsProvider),
        empty: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(l10n.homeNoNews, style: text.bodyMedium),
        ),
        data: (items) => Column(
          children: [
            for (final n in items.take(3))
              InkWell(
                onTap: () => context.push(Routes.newsDetail(n.id)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NetworkImageBox(
                        url: n.image,
                        width: 64,
                        height: 64,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.title,
                              style: text.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              [
                                if ((n.type ?? '').isNotEmpty) n.type!,
                                Fmt.date(n.createdAt, context.localeTag),
                              ].join(' · '),
                              style: text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
