import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/order.dart';
import 'controllers/orders_controller.dart';
import 'order_detail_sheet.dart';
import 'widgets/order_tile.dart';
import 'widgets/root_back.dart';

/// My Orders (spec §11.17). The detail opens as a bottom sheet; with
/// [openOrderId] (from a notification) that order's sheet opens by itself
/// once the list has loaded.
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key, this.openOrderId});

  final int? openOrderId;

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  /// The sheet for [OrdersScreen.openOrderId] opens only once.
  late bool _autoOpened = widget.openOrderId == null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _autoOpen(ref.read(ordersControllerProvider)),
    );
  }

  void _autoOpen(AsyncValue<List<Order>> orders) {
    if (_autoOpened || !mounted || !orders.hasValue) return;
    _autoOpened = true;
    final order = orders.requireValue.where((o) => o.id == widget.openOrderId).firstOrNull;
    if (order == null) {
      context.showSnack(context.l10n.orderNotFound);
    } else {
      showOrderDetailSheet(context, order);
    }
  }

  Future<void> _refresh() async {
    try {
      await ref.read(ordersControllerProvider.notifier).refresh();
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    ref.listen(ordersControllerProvider, (_, next) => _autoOpen(next));
    final orders = ref.watch(ordersControllerProvider);

    return HomeOnBack(
      child: AppScaffold(
        title: l10n.orderMyOrders,
        appBar: rootAwareAppBar(context, l10n.orderMyOrders),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: AsyncValueView<List<Order>>(
            value: orders,
            error: (e) => ListView(
              children: [
                ErrorState(error: e, onRetry: () => ref.invalidate(ordersControllerProvider)),
              ],
            ),
            empty: ListView(
              children: [
                EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.orderEmptyTitle,
                  message: l10n.orderEmptyMessage,
                  actionLabel: l10n.cartStartShopping,
                  onAction: () => context.go(Routes.market),
                ),
              ],
            ),
            data: (orders) => ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.page,
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderTile(
                  key: ValueKey(order.id),
                  order: order,
                  onTap: () => showOrderDetailSheet(context, order),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
