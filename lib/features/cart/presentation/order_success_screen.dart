import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/notifications/push_service.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import 'controllers/orders_controller.dart';
import 'widgets/root_back.dart';

/// Shown after `place_order` succeeds (spec §11.16): order number, the total
/// confirmed by the server and "Waiting for admin review".
class OrderSuccessScreen extends ConsumerStatefulWidget {
  const OrderSuccessScreen({super.key, required this.orderId});

  final int orderId;

  @override
  ConsumerState<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends ConsumerState<OrderSuccessScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterFirstOrder());
  }

  /// A good moment to ask for feedback (once, after the first order) and for
  /// the notification permission, so status updates can reach the farmer
  /// (spec §17.2, §18.4).
  Future<void> _afterFirstOrder() async {
    if (!mounted) return;
    try {
      await FeedbackSheet.maybeShowOnce(context, ref, contextKey: FeedbackContexts.firstOrder);
      if (!mounted) return;
      await ref.read(pushServiceProvider).requestPermission();
    } catch (_) {
      // Neither prompt may get in the way of the confirmation.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final id = widget.orderId;

    // The server total: from the RPC result first, then from the reloaded list.
    final placed = ref.watch(lastPlacedOrderProvider);
    final order = ref.watch(
      ordersControllerProvider.select((o) => o.value?.where((e) => e.id == id).firstOrNull),
    );
    final total = (placed?.orderId == id ? placed?.total : null) ?? order?.totalAmount;

    return HomeOnBack(
      child: AppScaffold(
        title: l10n.orderSuccessTitle,
        appBar: rootAwareAppBar(context, l10n.orderSuccessTitle),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.green100, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, size: 56, color: AppColors.green600),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.orderSuccessHeading, style: text.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.orderSuccessMessage,
              style: text.bodyMedium?.copyWith(color: AppColors.ink500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Row(label: l10n.orderSuccessNumber, value: '#$id'),
                  const Divider(height: AppSpacing.xl),
                  _Row(
                    label: l10n.cartTotal,
                    value: total == null ? '—' : Fmt.lkr(total),
                  ),
                  const Divider(height: AppSpacing.xl),
                  _Row(label: l10n.cartPayment, value: l10n.cartCashOnDelivery),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            InfoNote(
              text: l10n.orderWaitingReview,
              icon: Icons.schedule_rounded,
              tone: InfoNoteTone.warning,
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: l10n.orderViewMyOrders,
              icon: Icons.receipt_long_outlined,
              onPressed: () => context.go(Routes.orders),
            ),
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              label: l10n.orderContinueShopping,
              icon: Icons.storefront_outlined,
              onPressed: () => context.go(Routes.market),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: text.bodyMedium?.copyWith(color: AppColors.ink500)),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(value, style: text.titleSmall, textAlign: TextAlign.end),
        ),
      ],
    );
  }
}
