import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../marketplace/presentation/controllers/products_controller.dart';
import '../../../news/presentation/controllers/news_controller.dart';
import '../../../prices/domain/price_overview.dart';
import '../../../prices/presentation/controllers/prices_controller.dart';
import '../../../registration/domain/bucket_status.dart';
import '../../../registration/presentation/controllers/bucket_controller.dart';
import '../../../registration/presentation/controllers/register_controller.dart';

/// The dashboard has no data of its own: every card watches the provider of
/// the feature it summarises, and handles its own loading and error state so
/// one failure never blanks the screen (spec §11.8).

/// Top five crops by how full their national quota is.
final topBucketsProvider = Provider<AsyncValue<List<BucketStatus>>>((ref) {
  return ref.watch(bucketStatusProvider).whenData((buckets) {
    final sorted = [...buckets]..sort((a, b) => b.fillRatio.compareTo(a.fillRatio));
    return sorted.take(5).toList();
  });
});

/// Top five crops by the size of this month's price change.
final topPriceMoversProvider = Provider<AsyncValue<List<PriceOverview>>>((ref) {
  return ref.watch(priceOverviewProvider).whenData((prices) {
    final moved = prices.where((p) => p.wholesalePrice != null).toList()
      ..sort((a, b) => (b.change?.abs() ?? -1).compareTo(a.change?.abs() ?? -1));
    return moved.take(5).toList();
  });
});

/// Pull-to-refresh: re-fetches every dashboard card and waits for them.
Future<void> refreshHome(WidgetRef ref) async {
  ref
    ..invalidate(bucketStatusProvider)
    ..invalidate(myRegistrationsProvider)
    ..invalidate(myCropRegistrationsProvider)
    ..invalidate(priceOverviewProvider)
    ..invalidate(inStockProductCountProvider)
    ..invalidate(latestNewsProvider)
    ..invalidate(recentNewsCountProvider);
  Future<void> settle(Future<Object?> f) => f.then((_) {}, onError: (_) {});
  await Future.wait([
    settle(ref.read(bucketStatusProvider.future)),
    settle(ref.read(myRegistrationsProvider.future)),
    settle(ref.read(priceOverviewProvider.future)),
    settle(ref.read(inStockProductCountProvider.future)),
    settle(ref.read(latestNewsProvider.future)),
    settle(ref.read(recentNewsCountProvider.future)),
  ]);
}
