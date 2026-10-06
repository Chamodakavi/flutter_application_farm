// In-memory repositories shared by the marketplace and cart tests.
import 'package:farmfriend/core/config/constants.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/features/cart/data/cart_repository.dart';
import 'package:farmfriend/features/cart/data/order_repository.dart';
import 'package:farmfriend/features/cart/domain/cart_line.dart';
import 'package:farmfriend/features/cart/domain/order.dart';
import 'package:farmfriend/features/cart/domain/order_item.dart';
import 'package:farmfriend/features/marketplace/data/product_repository.dart';
import 'package:farmfriend/features/marketplace/domain/product.dart';

Product product(int id, {String? name, double price = 100, int stock = 10, String? type}) =>
    Product(id: id, name: name ?? 'Product $id', price: price, stock: stock, type: type);

Order order(int id, {String status = 'Pending', String? adminNote}) => Order(
  id: id,
  userId: 'u1',
  totalAmount: 650,
  shippingAmount: 350,
  status: status,
  adminNote: adminNote,
  createdAt: DateTime(2026, 10, 5, 9, 41),
  items: [
    OrderItem(
      id: id * 10,
      orderId: id,
      productId: '1',
      productName: 'Carrot seeds',
      productPrice: 100,
      quantity: 3,
      subtotal: 300,
    ),
  ],
);

/// A `cart` table in memory; lines are joined with [products] on fetch.
class FakeCartRepository implements CartRepository {
  FakeCartRepository({List<Product> products = const [], Map<int, int> initial = const {}})
    : products = {for (final p in products) p.id: p} {
    initial.forEach((productId, qty) => _rows.add(_row(productId: '$productId', qty: qty)));
  }

  final Map<int, Product> products;
  final _rows = <Map<String, dynamic>>[];
  int _nextId = 1;

  /// Thrown by every write while set.
  AppException? failWrites;

  int fetchCount = 0;
  int insertCount = 0;
  int updateCount = 0;
  int deleteCount = 0;

  /// product id (text) → qty, as stored.
  Map<String, int> get stored => {
    for (final r in _rows) r['product_id'] as String: r['qty'] as int,
  };

  Map<String, dynamic> _row({required String productId, required int qty}) => {
    'id': _nextId++,
    'product_id': productId,
    'qty': qty,
  };

  void _checkWrite() {
    if (failWrites != null) throw failWrites!;
  }

  @override
  Future<List<CartLine>> fetch() async {
    fetchCount++;
    return [
      for (final r in _rows)
        if (products[int.tryParse(r['product_id'] as String)] case final p?)
          CartLine.fromRow(r, p),
    ];
  }

  @override
  Future<void> insert({required String productId, required int qty}) async {
    _checkWrite();
    insertCount++;
    _rows.add(_row(productId: productId, qty: qty));
  }

  @override
  Future<void> updateQty(int cartId, int qty) async {
    _checkWrite();
    updateCount++;
    _rows.firstWhere((r) => r['id'] == cartId)['qty'] = qty;
  }

  @override
  Future<void> delete(int cartId) async {
    _checkWrite();
    deleteCount++;
    _rows.removeWhere((r) => r['id'] == cartId);
  }
}

class FakeOrderRepository implements OrderRepository {
  FakeOrderRepository([List<Order> orders = const []]) : orders = [...orders];

  List<Order> orders;
  PlaceOrderResult placeResult = const PlaceOrderResult.success(orderId: 9, total: 650);
  CancelOrderResult cancelResult = CancelOrderResult.success;

  String? placedWithPhone;
  final cancelled = <int>[];
  OrderUpdateCallback? onUpdate;
  bool channelRemoved = false;

  @override
  Future<List<Order>> fetchOrders() async => [...orders];

  @override
  Future<PlaceOrderResult> placeOrder({required String phone}) async {
    placedWithPhone = phone;
    return placeResult;
  }

  @override
  Future<CancelOrderResult> cancelOrder(int orderId) async {
    cancelled.add(orderId);
    if (cancelResult == CancelOrderResult.success) {
      orders = [for (final o in orders) o.id == orderId ? o.copyWith(status: 'Cancelled') : o];
    }
    return cancelResult;
  }

  @override
  void Function() watchUpdates(String uid, OrderUpdateCallback onUpdate) {
    this.onUpdate = onUpdate;
    return () => channelRemoved = true;
  }
}

class FakeProductRepository implements ProductRepository {
  FakeProductRepository(this.products);

  final List<Product> products;
  final requestedPages = <int>[];
  bool cacheCleared = false;

  @override
  Future<List<Product>> page({
    String? category,
    String query = '',
    required int page,
    bool forceRefresh = false,
  }) async {
    requestedPages.add(page);
    final matching = products
        .where((p) => category == null || p.category == category)
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return matching.skip(page * AppConst.pageSize).take(AppConst.pageSize).toList();
  }

  @override
  Future<List<String>> categories({bool forceRefresh = false}) async =>
      products.map((p) => p.category).nonNulls.toSet().toList()..sort();

  @override
  Future<Product> byId(int id) async =>
      products.firstWhere((p) => p.id == id, orElse: () => throw const AppException.notFound());

  @override
  Future<int> inStockCount() async => products.where((p) => p.inStock).length;

  @override
  Future<void> clearCache() async => cacheCleared = true;
}
