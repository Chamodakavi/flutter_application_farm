import 'package:farmfriend/core/config/app_config.dart';
import 'package:farmfriend/core/config/app_config_provider.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/cart/data/cart_repository.dart';
import 'package:farmfriend/features/cart/domain/cart_line.dart';
import 'package:farmfriend/features/cart/presentation/controllers/cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cart_fakes.dart';

ProviderContainer _container(
  FakeCartRepository repo, {
  String? uid = 'u1',
  double? shippingFee,
}) {
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      currentUserIdProvider.overrideWithValue(uid),
      cartRepositoryProvider.overrideWithValue(repo),
      appConfigOrDefaultProvider.overrideWithValue(AppConfig(shippingFeeLkr: shippingFee)),
    ],
  );
  addTearDown(container.dispose);
  // Keeps the providers alive for the duration of the test.
  container.listen(cartTotalsProvider, (_, _) {});
  return container;
}

void main() {
  final seeds = product(1, name: 'Carrot seeds', price: 160, stock: 10);
  final hoe = product(2, name: 'Hoe', price: 1250.50, stock: 3);

  group('cart totals', () {
    test('an empty cart has no subtotal and no shipping', () {
      final totals = cartTotalsFor(const [], shippingFee: 350);
      expect(totals.subtotal, 0);
      expect(totals.shipping, 0);
      expect(totals.total, 0);
    });

    test('subtotal is price × qty over all lines, plus the shipping fee', () {
      final lines = [
        CartLine(id: 1, productId: '1', qty: 3, product: seeds),
        CartLine(id: 2, productId: '2', qty: 2, product: hoe),
      ];
      final totals = cartTotalsFor(lines, shippingFee: 350);
      expect(totals.subtotal, closeTo(160 * 3 + 1250.50 * 2, 0.001));
      expect(totals.shipping, 350);
      expect(totals.total, closeTo(2981 + 350, 0.001));
    });

    test('the provider takes the shipping fee from app_config', () async {
      final repo = FakeCartRepository(products: [seeds], initial: {1: 2});
      final container = _container(repo, shippingFee: 400);
      await container.read(cartControllerProvider.future);

      final totals = container.read(cartTotalsProvider);
      expect(totals.subtotal, 320);
      expect(totals.shipping, 400);
      expect(totals.total, 720);
    });

    test('the provider falls back to the default fee and ships nothing when empty', () async {
      final repo = FakeCartRepository(products: [seeds], initial: {1: 1});
      final container = _container(repo);
      final lines = await container.read(cartControllerProvider.future);
      expect(container.read(cartTotalsProvider).shipping, 350);

      await container.read(cartControllerProvider.notifier).remove(lines.single.id);
      expect(container.read(cartTotalsProvider), const CartTotals());
    });
  });

  group('CartController', () {
    test('is empty and does not touch the server while signed out', () async {
      final repo = FakeCartRepository(products: [seeds], initial: {1: 2});
      final container = _container(repo, uid: null);

      expect(await container.read(cartControllerProvider.future), isEmpty);
      expect(repo.fetchCount, 0);
      expect(container.read(cartCountProvider), 0);
    });

    test('adding a new product inserts a line with the id as text', () async {
      final repo = FakeCartRepository(products: [seeds, hoe]);
      final container = _container(repo);
      await container.read(cartControllerProvider.future);

      await container.read(cartControllerProvider.notifier).add(1, 2);

      final lines = container.read(cartControllerProvider).requireValue;
      expect(lines, hasLength(1));
      expect(lines.single.productId, '1');
      expect(lines.single.qty, 2);
      expect(repo.insertCount, 1);
      expect(repo.updateCount, 0);
      expect(repo.stored, {'1': 2});
      expect(container.read(cartCountProvider), 1);
    });

    test('adding a product that is already in the cart increments its line', () async {
      final repo = FakeCartRepository(products: [seeds, hoe], initial: {1: 2});
      final container = _container(repo);
      await container.read(cartControllerProvider.future);

      await container.read(cartControllerProvider.notifier).add(1, 3);

      final lines = container.read(cartControllerProvider).requireValue;
      expect(lines, hasLength(1));
      expect(lines.single.qty, 5);
      expect(repo.insertCount, 0);
      expect(repo.updateCount, 1);
      expect(repo.stored, {'1': 5});
    });

    test('add waits for the first load instead of inserting a duplicate', () async {
      final repo = FakeCartRepository(products: [seeds], initial: {1: 1});
      final container = _container(repo);

      // No await on the first load: `add` races it.
      await container.read(cartControllerProvider.notifier).add(1, 1);

      expect(repo.insertCount, 0);
      expect(repo.stored, {'1': 2});
    });

    test('setting the quantity to 0 deletes the line', () async {
      final repo = FakeCartRepository(products: [seeds, hoe], initial: {1: 2, 2: 1});
      final container = _container(repo);
      final lines = await container.read(cartControllerProvider.future);
      final seedsLine = lines.firstWhere((l) => l.productId == '1');

      await container.read(cartControllerProvider.notifier).setQty(seedsLine.id, 0);

      expect(container.read(cartControllerProvider).requireValue.map((l) => l.productId), ['2']);
      expect(repo.deleteCount, 1);
      expect(repo.stored, {'2': 1});
    });

    test('setQty updates the line and the totals', () async {
      final repo = FakeCartRepository(products: [seeds], initial: {1: 2});
      final container = _container(repo);
      final lines = await container.read(cartControllerProvider.future);

      await container.read(cartControllerProvider.notifier).setQty(lines.single.id, 4);

      expect(container.read(cartControllerProvider).requireValue.single.qty, 4);
      expect(container.read(cartTotalsProvider).subtotal, 640);
      expect(repo.stored, {'1': 4});
    });

    test('a refused quantity change is rolled back and rethrown', () async {
      final repo = FakeCartRepository(products: [seeds], initial: {1: 2});
      final container = _container(repo);
      final lines = await container.read(cartControllerProvider.future);
      repo.failWrites = const AppException.network();

      await expectLater(
        container.read(cartControllerProvider.notifier).setQty(lines.single.id, 4),
        throwsA(isA<NetworkException>()),
      );
      expect(container.read(cartControllerProvider).requireValue.single.qty, 2);
    });

    test('restore puts a removed line back (Undo)', () async {
      final repo = FakeCartRepository(products: [seeds], initial: {1: 3});
      final container = _container(repo);
      final line = (await container.read(cartControllerProvider.future)).single;
      final controller = container.read(cartControllerProvider.notifier);

      await controller.remove(line.id);
      expect(container.read(cartControllerProvider).requireValue, isEmpty);

      await controller.restore(line);
      final restored = container.read(cartControllerProvider).requireValue.single;
      expect(restored.productId, '1');
      expect(restored.qty, 3);
    });

    test('lines whose product no longer exists are dropped', () async {
      final repo = FakeCartRepository(products: [seeds], initial: {1: 1, 99: 4});
      final container = _container(repo);

      final lines = await container.read(cartControllerProvider.future);
      expect(lines.map((l) => l.productId), ['1']);
    });
  });
}
