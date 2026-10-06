import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/controllers/orders_controller.dart';
import '../../features/notifications/presentation/controllers/notifications_controller.dart';
import '../../features/support/presentation/controllers/complaints_controller.dart';
import '../l10n/l10n_ext.dart';
import '../theme/app_colors.dart';
import '../widgets/app_scaffold.dart';

/// Bottom-navigation shell with five destinations and the AgriBot bubble
/// (spec §9.1). Each tab keeps its own navigation stack and scroll position.
class ShellScaffold extends ConsumerWidget {
  const ShellScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _select(int index) => navigationShell.goBranch(
    index,
    // Tapping the active tab again returns to its first screen.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Realtime listeners that must stay alive on every tab while signed in:
    // order status, admin broadcasts and complaint replies (spec §17.1).
    ref
      ..watch(ordersRealtimeProvider)
      ..watch(notificationsRealtimeProvider)
      ..watch(complaintsRealtimeProvider);

    final l10n = context.l10n;
    return Scaffold(
      body: navigationShell,
      floatingActionButton: const AgriBotFab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _select,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view_rounded),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront_rounded),
            label: l10n.navMarket,
          ),
          // Centre tab, emphasised: the core research feature.
          NavigationDestination(
            icon: const _RegisterIcon(),
            selectedIcon: const _RegisterIcon(selected: true),
            label: l10n.navRegister,
          ),
          NavigationDestination(
            icon: const Icon(Icons.forum_outlined),
            selectedIcon: const Icon(Icons.forum_rounded),
            label: l10n.navCommunity,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_rounded),
            selectedIcon: const Icon(Icons.menu_open_rounded),
            label: l10n.navMore,
          ),
        ],
      ),
    );
  }
}

class _RegisterIcon extends StatelessWidget {
  const _RegisterIcon({this.selected = false});

  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 32,
    decoration: BoxDecoration(
      color: selected ? AppColors.green500 : AppColors.green600,
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Icon(Icons.eco_rounded, color: AppColors.white, size: 22),
  );
}
