import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/district_labels.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
import '../domain/cart_line.dart';
import '../domain/order_item.dart';
import 'controllers/cart_controller.dart';
import 'controllers/orders_controller.dart';
import 'widgets/price_summary.dart';

/// Cash-on-Delivery checkout (spec §11.16): delivery contact, payment method,
/// order summary and **Place order** through the `place_order` RPC.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

/// The only payment method (spec §1.1).
enum _Payment { cashOnDelivery }

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _form = GlobalKey<FormState>();
  final _phone = TextEditingController();
  bool _phonePrefilled = false;
  bool _placing = false;

  /// True once the order went through: keeps the progress view up while the
  /// cart empties and the success screen opens.
  bool _placed = false;

  @override
  void initState() {
    super.initState();
    _prefillPhone(ref.read(profileProvider).value?.phone);
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  /// Fills the phone from the profile (`u_tel`) once, without overwriting
  /// what the user has typed.
  void _prefillPhone(String? phone) {
    if (_phonePrefilled || phone == null || phone.trim().isEmpty) return;
    _phonePrefilled = true;
    if (_phone.text.isEmpty) _phone.text = phone.trim();
  }

  void _backToCart() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.cart);
    }
  }

  Future<void> _placeOrder() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    final l10n = context.l10n;
    setState(() => _placing = true);
    final PlaceOrderResult result;
    try {
      result = await ref.read(ordersControllerProvider.notifier).placeOrder(_phone.text.trim());
    } catch (e) {
      if (!mounted) return;
      setState(() => _placing = false);
      context.showError(e);
      return;
    }
    if (!mounted) return;
    setState(() {
      _placing = false;
      _placed = result is PlaceOrderSuccess;
    });
    switch (result) {
      case PlaceOrderSuccess(:final orderId):
        context.go(Routes.orderSuccess(orderId));
      case PlaceOrderInsufficientStock():
        await _showStockSheet(result);
      case PlaceOrderEmptyCart():
        context.showSnack(l10n.checkoutEmptyCart);
        _backToCart();
      case PlaceOrderUnknown():
        context.showSnack(l10n.checkoutFailed);
    }
  }

  /// Names the product that ran short and how many are left, then sends the
  /// user back to the cart to fix the quantity.
  Future<void> _showStockSheet(PlaceOrderInsufficientStock result) async {
    final l10n = context.l10n;
    final name = result.productName?.trim() ?? '';
    final update = await showAppBottomSheet<bool>(
      context,
      title: l10n.checkoutStockTitle,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoNote(
              tone: InfoNoteTone.warning,
              text: name.isEmpty
                  ? l10n.checkoutStockGeneric
                  : result.available > 0
                  ? l10n.checkoutStockMessage(name, '${result.available}')
                  : l10n.checkoutStockNone(name),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: l10n.checkoutUpdateCart,
              icon: Icons.shopping_cart_outlined,
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      ),
    );
    if (update == true && mounted) _backToCart();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    ref.listen(profileProvider, (_, next) => _prefillPhone(next.value?.phone));
    final cart = ref.watch(cartControllerProvider);
    final lines = cart.value ?? const <CartLine>[];
    final ready = !_placed && lines.isNotEmpty;

    return AppScaffold(
      title: l10n.checkoutTitle,
      bottomBar: !ready
          ? null
          : OnlineOnly(
              builder: (context, online) => PrimaryButton(
                label: l10n.checkoutPlaceOrder,
                icon: Icons.check_circle_outline_rounded,
                loading: _placing,
                onPressed: online ? _placeOrder : null,
              ),
            ),
      body: _placed
          ? const Center(child: CircularProgressIndicator())
          : AsyncValueView<List<CartLine>>(
              value: cart,
              onRetry: () => ref.invalidate(cartControllerProvider),
              empty: EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: l10n.cartEmptyTitle,
                message: l10n.checkoutEmptyCart,
                actionLabel: l10n.cartStartShopping,
                onAction: () => context.go(Routes.market),
              ),
              data: _buildForm,
            ),
    );
  }

  Widget _buildForm(List<CartLine> lines) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final profile = ref.watch(profileProvider).value;
    final totals = ref.watch(cartTotalsProvider);
    final name = profile?.displayName ?? '';
    final district = Districts.label(context, profile?.district);

    return Form(
      key: _form,
      child: ListView(
        padding: AppSpacing.page,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          SectionCard(
            title: l10n.checkoutContactTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  key: ValueKey('name-$name'),
                  label: l10n.checkoutName,
                  initialValue: name.isEmpty ? '—' : name,
                  enabled: false,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: l10n.checkoutPhone,
                  controller: _phone,
                  required: true,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  prefixIcon: Icons.phone_outlined,
                  helper: l10n.checkoutPhoneHelper,
                  validator: Validators.phone(l10n),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  key: ValueKey('district-$district'),
                  label: l10n.checkoutDistrict,
                  initialValue: district.isEmpty ? '—' : district,
                  enabled: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SectionCard(
            title: l10n.checkoutPaymentTitle,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: RadioGroup<_Payment>(
              groupValue: _Payment.cashOnDelivery,
              onChanged: (_) {},
              child: RadioListTile<_Payment>(
                value: _Payment.cashOnDelivery,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.green600,
                title: Text(l10n.cartCashOnDelivery, style: text.titleSmall),
                subtitle: Text(l10n.checkoutCodHint, style: text.bodySmall),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SectionCard(
            title: l10n.checkoutSummaryTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final line in lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: SummaryRow(
                      label: l10n.checkoutLine(line.product.name, '${line.qty}'),
                      value: Fmt.rs(line.subtotal),
                    ),
                  ),
                const Divider(height: AppSpacing.lg),
                PriceSummary(
                  subtotal: Fmt.rs(totals.subtotal),
                  shipping: Fmt.rs(totals.shipping),
                  total: Fmt.rs(totals.total),
                  note: l10n.cartEstimateNote,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          InfoNote(text: l10n.checkoutReviewNote),
        ],
      ),
    );
  }
}
