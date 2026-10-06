import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config_provider.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../data/cart_repository.dart';
import '../../domain/cart_line.dart';

/// Server-synced cart (spec §13.3). Rebuilds when the account changes and is
/// empty while signed out.
class CartController extends AsyncNotifier<List<CartLine>> {
  @override
  Future<List<CartLine>> build() async {
    final uid = ref.watch(currentUserIdProvider);
    if (uid == null) return const [];
    return ref.read(cartRepositoryProvider).fetch();
  }

  /// The lines as the server has them: the loaded list, the load in flight,
  /// or a fresh read when the last load failed.
  Future<List<CartLine>> _current() async {
    if (state.hasValue) return state.requireValue;
    if (state.isLoading) return future;
    return ref.read(cartRepositoryProvider).fetch();
  }

  Future<void> _reload() async {
    final lines = await ref.read(cartRepositoryProvider).fetch();
    if (ref.mounted) state = AsyncData(lines);
  }

  /// Adds [qty] of a product: an existing line is incremented, otherwise a
  /// new line is inserted (`cart.product_id` is `varchar`).
  Future<void> add(int productId, int qty) async {
    if (qty <= 0) return;
    final repo = ref.read(cartRepositoryProvider);
    final lines = await _current();
    final existing = lines.where((l) => l.productId.trim() == '$productId').firstOrNull;
    if (existing != null) {
      await repo.updateQty(existing.id, existing.qty + qty);
    } else {
      await repo.insert(productId: '$productId', qty: qty);
    }
    if (ref.mounted) await _reload();
  }

  /// Sets the quantity of a line; zero or less removes it. The change shows
  /// at once and is rolled back if the server refuses it.
  Future<void> setQty(int cartId, int qty) async {
    if (qty <= 0) return remove(cartId);
    final before = state.value;
    if (before == null || !before.any((l) => l.id == cartId)) return;
    state = AsyncData([
      for (final line in before) line.id == cartId ? line.copyWith(qty: qty) : line,
    ]);
    try {
      await ref.read(cartRepositoryProvider).updateQty(cartId, qty);
    } catch (_) {
      if (ref.mounted) state = AsyncData(before);
      rethrow;
    }
  }

  /// Removes a line (optimistic). The screen offers Undo through [restore].
  Future<void> remove(int cartId) async {
    final before = state.value;
    if (before == null || !before.any((l) => l.id == cartId)) return;
    state = AsyncData(before.where((l) => l.id != cartId).toList());
    try {
      await ref.read(cartRepositoryProvider).delete(cartId);
    } catch (_) {
      if (ref.mounted) state = AsyncData(before);
      rethrow;
    }
  }

  /// Undo of [remove]: inserts the line again with its old quantity.
  Future<void> restore(CartLine line) async {
    await ref.read(cartRepositoryProvider).insert(productId: line.productId, qty: line.qty);
    if (ref.mounted) await _reload();
  }
}

final cartControllerProvider = AsyncNotifierProvider<CartController, List<CartLine>>(
  CartController.new,
);

/// Number of cart lines — the app bar badge.
final cartCountProvider = Provider<int>(
  (ref) => ref.watch(cartControllerProvider).value?.length ?? 0,
);

/// Subtotal of [lines] plus [shippingFee]; an empty cart ships nothing.
CartTotals cartTotalsFor(List<CartLine> lines, {required double shippingFee}) => CartTotals(
  subtotal: lines.fold<double>(0, (sum, line) => sum + line.subtotal),
  shipping: lines.isEmpty ? 0 : shippingFee,
);

/// Display totals (estimate; `place_order` returns the real total).
final cartTotalsProvider = Provider<CartTotals>((ref) {
  final lines = ref.watch(cartControllerProvider).value ?? const <CartLine>[];
  if (lines.isEmpty) return const CartTotals();
  return cartTotalsFor(lines, shippingFee: ref.watch(appConfigOrDefaultProvider).shippingFee);
});
