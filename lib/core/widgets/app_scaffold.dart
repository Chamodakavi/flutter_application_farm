import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/controllers/cart_controller.dart';
import '../../features/notifications/presentation/controllers/notifications_controller.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';
import '../l10n/l10n_ext.dart';
import '../router/routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'small_widgets.dart';
import 'states.dart';

/// Bottom padding for scrollable content on the five tab screens, so the
/// AgriBot bubble never covers the last item.
const kFabClearance = 96.0;

/// Standard page: app bar (title + subtitle or a custom bar), offline banner
/// slot and body.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.subtitle,
    this.actions,
    this.appBar,
    required this.body,
    this.backgroundColor,
    this.bottomBar,
    this.floatingActionButton,
    this.showOfflineBanner = true,
    this.resizeToAvoidBottomInset,
  });

  final String? title;
  final String? subtitle;
  final List<Widget>? actions;

  /// Overrides the bar built from [title]; tab screens pass [FarmAppBar].
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Color? backgroundColor;

  /// Sticky bottom area (e.g. "Add to cart" bar); padded for the safe area.
  final Widget? bottomBar;
  final Widget? floatingActionButton;
  final bool showOfflineBanner;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar:
          appBar ??
          (title == null
              ? null
              : AppBar(
                  titleSpacing: 0,
                  // Opened directly (deep link, notification, checkout result):
                  // nothing to pop, so the arrow returns to Home.
                  leading: Navigator.of(context).canPop()
                      ? null
                      : IconButton(
                          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                          icon: const BackButtonIcon(),
                          onPressed: () => GoRouter.maybeOf(context)?.go(Routes.home),
                        ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall?.copyWith(color: Colors.white70),
                        ),
                    ],
                  ),
                  actions: actions,
                )),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomBar == null
          ? null
          : Material(
              color: AppColors.white,
              elevation: 8,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: bottomBar,
                ),
              ),
            ),
      body: Column(
        children: [
          if (showOfflineBanner) const OfflineBanner(),
          Expanded(child: body),
        ],
      ),
    );
  }
}

/// The app bar shared by the five tabs: logo, cart and bell with badges, and
/// the avatar (→ Settings). `showBack` turns it into a titled bar for pushed
/// screens that still want the cart and bell.
class FarmAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const FarmAppBar({super.key, this.showBack = false, this.title});

  final bool showBack;
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cartCount = ref.watch(cartCountProvider);
    final unread = ref.watch(unreadNotificationCountProvider);
    final profile = ref.watch(profileProvider).value;

    return AppBar(
      automaticallyImplyLeading: showBack,
      titleSpacing: showBack ? 0 : AppSpacing.lg,
      title: showBack
          ? Text(title ?? l10n.appName, maxLines: 1, overflow: TextOverflow.ellipsis)
          : const AppLogo(size: 26),
      actions: [
        IconButton(
          tooltip: l10n.appBarCart,
          onPressed: () => context.push(Routes.cart),
          icon: _Badged(count: cartCount, child: const Icon(Icons.shopping_cart_outlined)),
        ),
        IconButton(
          tooltip: l10n.appBarNotifications,
          onPressed: () => context.push(Routes.notifications),
          icon: _Badged(count: unread, child: const Icon(Icons.notifications_none_rounded)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md, left: AppSpacing.xs),
          child: Tooltip(
            message: l10n.appBarProfile,
            child: InkResponse(
              onTap: () => context.push(Routes.settings),
              radius: 24,
              child: AvatarCircle(
                url: profile?.avatarUrl,
                name: profile?.displayName.isNotEmpty == true ? profile!.displayName : profile?.email,
                radius: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Badged extends StatelessWidget {
  const _Badged({required this.count, required this.child});

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) => Badge(
    isLabelVisible: count > 0,
    label: Text(count > 99 ? '99+' : '$count'),
    backgroundColor: AppColors.orange500,
    textColor: AppColors.forest900,
    child: child,
  );
}

/// Green circular chat bubble, bottom-right above the navigation bar (same as
/// web). Hidden while the keyboard is open.
class AgriBotFab extends StatelessWidget {
  const AgriBotFab({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.viewInsetsOf(context).bottom > 0) return const SizedBox.shrink();
    return FloatingActionButton(
      heroTag: 'agribot-fab',
      tooltip: context.l10n.chatFabTooltip,
      onPressed: () => context.push(Routes.chat),
      child: const Icon(Icons.chat_bubble_outline_rounded),
    );
  }
}
