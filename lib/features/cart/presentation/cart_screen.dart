import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/network/connectivity_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/cart_line.dart';
import '../domain/order.dart';
import 'controllers/cart_controller.dart';
import 'controllers/orders_controller.dart';
import 'order_detail_sheet.dart';
import 'widgets/cart_line_tile.dart';
import 'widgets/order_tile.dart';
import 'widgets/price_summary.dart';
import 'widgets/root_back.dart';

/// Shopping cart (spec §11.15): server-synced lines, estimated totals, and
/// the farmer's latest orders underneath, like the web page.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  /// Orders shown under the cart before "View all".
  static const _recentOrders = 3;

  Future<void> _refresh(WidgetRef ref) async {
    ref
      ..invalidate(cartControllerProvider)
      ..invalidate(ordersControllerProvider);
    try {
      await Future.wait([
        ref.read(cartControllerProvider.future),
        ref.read(ordersControllerProvider.future),
      ]);
    } catch (_) {
      // Each section shows its own error state.
    }
  }

  Future<void> _setQty(BuildContext context, WidgetRef ref, CartLine line, int qty) async {
    if (qty <= 0) return _remove(context, ref, line);
    try {
      await ref.read(cartControllerProvider.notifier).setQty(line.id, qty);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }

  /// Removes the line and offers Undo, which inserts it again.
  Future<void> _remove(BuildContext context, WidgetRef ref, CartLine line) async {
    // Resolved up front: Undo can be tapped after this screen is gone.
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final controller = ref.read(cartControllerProvider.notifier);
    try {
      await controller.remove(line.id);
    } catch (e) {
      if (context.mounted) context.showError(e);
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.cartRemoved(line.product.name)),
          action: SnackBarAction(
            label: l10n.commonUndo,
            onPressed: () async {
              try {
                await controller.restore(line);
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.messageFor(mapError(e)))),
                );
              }
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final cart = ref.watch(cartControllerProvider);
    final totals = ref.watch(cartTotalsProvider);
    final online = ref.watch(isOnlineProvider);
    final lines = cart.value ?? const <CartLine>[];
    final blocked = lines.any((l) => l.exceedsStock);

    return HomeOnBack(
      child: AppScaffold(
        title: l10n.cartTitle,
        appBar: rootAwareAppBar(context, l10n.cartTitle),
        bottomBar: lines.isEmpty
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SummaryRow(label: l10n.cartTotal, value: Fmt.rs(totals.total), strong: true),
                  const SizedBox(height: AppSpacing.sm),
                  PrimaryButton(
                    label: l10n.cartCheckout,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: blocked ? null : () => context.push(Routes.checkout),
                  ),
                ],
              ),
        body: RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.page,
            children: [
              Text(
                l10n.cartSubtitle,
                style: text.bodyMedium?.copyWith(color: AppColors.ink500),
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TagChip(l10n.cartCashOnDelivery, icon: Icons.payments_outlined),
              ),
              const SizedBox(height: AppSpacing.lg),
              AsyncValueView<List<CartLine>>(
                value: cart,
                loading: const ShimmerList(
                  itemCount: 3,
                  itemHeight: 120,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                ),
                onRetry: () => ref.invalidate(cartControllerProvider),
                empty: SectionCard(
                  padding: EdgeInsets.zero,
                  child: EmptyState(
                    icon: Icons.shopping_bag_outlined,
                    title: l10n.cartEmptyTitle,
                    message: l10n.cartEmptyMessage,
                    actionLabel: l10n.cartStartShopping,
                    onAction: () => context.go(Routes.market),
                  ),
                ),
                data: (items) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final line in items) ...[
                      CartLineTile(
                        key: ValueKey(line.id),
                        line: line,
                        onTap: () => context.push(Routes.product(line.product.id)),
                        onQtyChanged: online ? (qty) => _setQty(context, ref, line, qty) : null,
                        onRemove: online ? () => _remove(context, ref, line) : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    SectionCard(
                      title: l10n.cartSummaryTitle,
                      child: PriceSummary(
                        subtotal: Fmt.rs(totals.subtotal),
                        shipping: Fmt.rs(totals.shipping),
                        total: Fmt.rs(totals.total),
                        note: l10n.cartEstimateNote,
                      ),
                    ),
                    if (blocked) ...[
                      const SizedBox(height: AppSpacing.md),
                      InfoNote(text: l10n.cartFixStock, tone: InfoNoteTone.warning),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const _RecentOrders(),
            ],
          ),
        ),
      ),
    );
  }
}

/// "My Orders" under the cart: the last three orders and "View all".
class _RecentOrders extends ConsumerWidget {
  const _RecentOrders();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final orders = ref.watch(ordersControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.md,
          children: [
            Text(l10n.orderMyOrders, style: text.titleMedium),
            TextButton(
              onPressed: () => context.push(Routes.orders),
              child: Text(l10n.commonViewAll),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView<List<Order>>(
          value: orders,
          compact: true,
          onRetry: () => ref.invalidate(ordersControllerProvider),
          empty: SectionCard(
            child: Text(
              l10n.orderEmptyMessage,
              style: text.bodyMedium?.copyWith(color: AppColors.ink500),
            ),
          ),
          data: (orders) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final order in orders.take(CartScreen._recentOrders)) ...[
                OrderTile(order: order, onTap: () => showOrderDetailSheet(context, order)),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
