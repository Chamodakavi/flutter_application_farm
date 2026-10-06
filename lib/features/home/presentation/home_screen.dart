import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config_provider.dart';
import '../../../core/config/env.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../app_gate/presentation/update_required_screen.dart';
import '../../marketplace/presentation/controllers/products_controller.dart';
import '../../news/presentation/controllers/news_controller.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
import '../../registration/presentation/controllers/register_controller.dart';
import '../../weather/presentation/widgets/weather_card.dart';
import 'controllers/home_controller.dart';
import 'widgets/home_cards.dart';
import 'widgets/outlook_strips.dart';

/// Dashboard — bottom-nav tab 1 (spec §11.8).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _updateDismissed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAdmin = ref.watch(profileProvider.select((p) => p.value?.isAdmin ?? false));
    final showUpdate = ref.watch(updateAvailableProvider) && !_updateDismissed;

    return AppScaffold(
      appBar: const FarmAppBar(),
      body: RefreshIndicator(
        onRefresh: () => refreshHome(ref),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            kFabClearance,
          ),
          children: [
            if (showUpdate) ...[
              _UpdateBanner(onDismiss: () => setState(() => _updateDismissed = true)),
              const SizedBox(height: AppSpacing.md),
            ],
            if (isAdmin) ...[
              // Admin work stays on the web; mobile shows the farmer view.
              InfoNote(
                text: l10n.adminBanner,
                icon: Icons.admin_panel_settings_outlined,
                actionLabel: l10n.adminBannerOpen,
                onAction: () =>
                    launchUrl(Uri.parse(Env.webAppUrl), mode: LaunchMode.externalApplication),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            const WelcomeHero(),
            const SizedBox(height: AppSpacing.lg),
            const _StatGrid(),
            const SizedBox(height: AppSpacing.xxl),
            const CropOutlookStrip(),
            const SizedBox(height: AppSpacing.xxl),
            const PriceOutlookStrip(),
            const SizedBox(height: AppSpacing.xxl),
            const QuickActionsGrid(),
            const SizedBox(height: AppSpacing.xxl),
            const MyRegistrationsCard(),
            const SizedBox(height: AppSpacing.lg),
            const LatestNewsStrip(),
          ],
        ),
      ),
    );
  }
}

/// Weather, my crops, marketplace and news — each card loads on its own.
class _StatGrid extends ConsumerWidget {
  const _StatGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final registrations = ref.watch(myRegistrationsProvider);
    final products = ref.watch(inStockProductCountProvider);
    final news = ref.watch(recentNewsCountProvider);
    final totalMt = registrations.value?.fold<double>(0, (sum, r) => sum + r.amountMt);

    return EqualHeightGrid(
      children: [
        const WeatherCard(),
        StatCard(
          title: l10n.homeMyCrops,
          value: _count(registrations.value?.length),
          caption: l10n.homeTotalMt(totalMt == null ? '—' : Fmt.amount(totalMt)),
          icon: Icons.eco_outlined,
          loading: registrations.isLoading && !registrations.hasValue,
          onTap: () => context.push(Routes.myQuotas),
        ),
        StatCard(
          title: l10n.homeMarketItems,
          value: _count(products.value),
          caption: l10n.homeProductsAvailable,
          icon: Icons.storefront_outlined,
          iconColor: AppColors.orange600,
          loading: products.isLoading && !products.hasValue,
          onTap: () => context.go(Routes.market),
        ),
        StatCard(
          title: l10n.homeFarmingNews,
          value: _count(news.value),
          caption: l10n.homeLatestUpdates,
          icon: Icons.newspaper_outlined,
          iconColor: AppColors.blue600,
          loading: news.isLoading && !news.hasValue,
          onTap: () => context.push(Routes.news),
        ),
      ],
    );
  }

  /// A card whose request failed shows a dash instead of an error.
  String _count(int? value) => value == null ? '—' : '$value';
}

class _UpdateBanner extends ConsumerWidget {
  const _UpdateBanner({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return SectionCard(
      color: AppColors.green100,
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.xs, AppSpacing.sm),
      child: Row(
        children: [
          const Icon(Icons.system_update_rounded, color: AppColors.green600),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.updateAvailable, style: text.titleSmall),
                Text(l10n.homeUpdateBody, style: text.bodySmall),
              ],
            ),
          ),
          TextButton(
            onPressed: () => openStore(context, ref.read(appConfigOrDefaultProvider)),
            child: Text(l10n.updateButton),
          ),
          IconButton(
            tooltip: l10n.commonClose,
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}
