import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_status.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/order.dart';
import '../domain/order_item.dart';
import 'controllers/orders_controller.dart';
import 'order_l10n.dart';
import 'widgets/price_summary.dart';

/// Opens the order detail as a bottom sheet (spec §11.17, like the web modal).
Future<void> showOrderDetailSheet(BuildContext context, Order order) => showAppBottomSheet<void>(
  context,
  builder: (_) => OrderDetailSheet(order: order),
);

/// Order number, status panel, items and totals, with **Cancel Order** while
/// the order is still pending. Follows the live order, so a status change
/// (realtime or the farmer's own cancel) shows without reopening the sheet.
class OrderDetailSheet extends ConsumerStatefulWidget {
  const OrderDetailSheet({super.key, required this.order});

  /// The order as it was when the sheet opened.
  final Order order;

  @override
  ConsumerState<OrderDetailSheet> createState() => _OrderDetailSheetState();
}

class _OrderDetailSheetState extends ConsumerState<OrderDetailSheet> {
  bool _cancelling = false;

  /// Why the last cancel attempt did not work — shown inside the sheet,
  /// because a snackbar would be hidden behind it.
  String? _problem;

  Future<void> _cancel(Order order) async {
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.orderCancelConfirmTitle,
      message: l10n.orderCancelConfirmMessage('${order.id}'),
      confirmLabel: l10n.orderCancelConfirmYes,
      cancelLabel: l10n.orderCancelConfirmNo,
      destructive: true,
    );
    if (!confirmed || !mounted) return;

    setState(() {
      _cancelling = true;
      _problem = null;
    });
    String? problem;
    try {
      final result = await ref.read(ordersControllerProvider.notifier).cancel(order.id);
      problem = switch (result) {
        CancelOrderResult.success => null,
        CancelOrderResult.notCancellable => l10n.orderCancelNotCancellable,
        CancelOrderResult.notFound => l10n.orderNotFound,
        CancelOrderResult.unknown => l10n.errorUnknown,
      };
    } catch (e) {
      if (mounted) problem = context.errorMessage(e);
    }
    if (!mounted) return;
    setState(() {
      _cancelling = false;
      _problem = problem;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final locale = context.localeTag;
    final id = widget.order.id;
    final order = ref.watch(
      ordersControllerProvider.select(
        (orders) => orders.value?.where((o) => o.id == id).firstOrNull,
      ),
    ) ?? widget.order;
    final cancelledNow = widget.order.canCancel && order.statusEnum == AppStatus.cancelled;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l10n.orderNumber('${order.id}'), style: text.titleLarge),
              StatusChip(order.status, showIcon: true),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.orderPlacedOn(Fmt.dateTime(order.createdAt, locale)),
            style: text.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.orderTotalLine(Fmt.lkr(order.totalAmount)), style: text.titleSmall),
          const SizedBox(height: AppSpacing.lg),
          _StatusPanel(order: order),
          if (cancelledNow) ...[
            const SizedBox(height: AppSpacing.sm),
            InfoNote(text: l10n.orderCancelled, tone: InfoNoteTone.success),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.orderItemsTitle, style: text.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          if (order.items.isEmpty)
            Text(l10n.orderItemsUnavailable, style: text.bodySmall)
          else
            for (final item in order.items) _ItemRow(item: item),
          const Divider(height: AppSpacing.xxl),
          PriceSummary(
            subtotal: Fmt.lkr(
              order.items.isEmpty
                  ? order.totalAmount - order.shippingAmount
                  : order.itemsSubtotal,
            ),
            shipping: Fmt.lkr(order.shippingAmount),
            total: Fmt.lkr(order.totalAmount),
          ),
          if (_problem != null) ...[
            const SizedBox(height: AppSpacing.md),
            InfoNote(text: _problem!, tone: InfoNoteTone.danger),
          ],
          if (order.canCancel) ...[
            const SizedBox(height: AppSpacing.lg),
            OnlineOnly(
              builder: (context, online) => DangerButton(
                label: l10n.orderCancel,
                icon: Icons.cancel_outlined,
                loading: _cancelling,
                onPressed: online ? () => _cancel(order) : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Coloured panel explaining the status, plus the admin's note if there is
/// one.
class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final status = order.statusEnum;
    final note = order.adminNote?.trim() ?? '';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: AppRadii.inputBorder,
        border: Border.all(color: status.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(status.icon, color: status.color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.label(l10n, order.status),
                  style: text.titleSmall?.copyWith(color: status.color),
                ),
                const SizedBox(height: 2),
                Text(l10n.orderStatusMessage(status), style: text.bodyMedium),
                if (note.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.orderAdminNote, style: text.labelSmall),
                  Text(note, style: text.bodyMedium),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageBox(
            url: item.productImage,
            width: 52,
            height: 52,
            borderRadius: AppRadii.inputBorder,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall,
                ),
                Text(
                  l10n.orderItemQty('${item.quantity}', Fmt.lkr(item.productPrice)),
                  style: text.bodySmall,
                ),
                Text(
                  Fmt.lkr(item.lineTotal),
                  style: text.labelMedium?.copyWith(color: AppColors.forest900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
