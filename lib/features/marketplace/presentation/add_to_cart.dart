import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../cart/presentation/controllers/cart_controller.dart';

/// Adds [qty] of a product to the server cart and confirms with the
/// "Added to cart · View cart" snackbar (spec §11.13). Returns false, after
/// showing the error, when the cart could not be updated.
Future<bool> addToCart(
  BuildContext context,
  WidgetRef ref,
  int productId, {
  int qty = 1,
  bool confirm = true,
}) async {
  // Resolved up front: the snackbar can outlive the widget that asked.
  final l10n = context.l10n;
  final router = GoRouter.of(context);
  try {
    await ref.read(cartControllerProvider.notifier).add(productId, qty);
  } catch (e) {
    if (context.mounted) context.showError(e);
    return false;
  }
  if (confirm && context.mounted) {
    context.showSnack(
      l10n.cartAdded,
      action: SnackBarAction(
        label: l10n.cartViewCart,
        onPressed: () => router.push(Routes.cart),
      ),
    );
  }
  return true;
}
