import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config_provider.dart';
import '../../data/registration_repository.dart';
import '../../domain/bucket_rules.dart';
import '../../domain/bucket_status.dart';

final _bucketGateProvider = Provider<RefreshGate>((ref) => RefreshGate());

/// National bucket (quota vs. registered supply) for every active crop.
///
/// The first read may come from the Hive cache (10 min); invalidating the
/// provider always asks the server again and falls back to the saved copy
/// when offline.
final bucketStatusProvider = FutureProvider<List<BucketStatus>>((ref) {
  final force = ref.watch(_bucketGateProvider).take();
  return ref.watch(registrationRepositoryProvider).bucketStatus(forceRefresh: force);
});

/// Surplus colour thresholds from `app_config` (spec §13.2).
final surplusThresholdsProvider = Provider<SurplusThresholds>((ref) {
  final config = ref.watch(appConfigOrDefaultProvider);
  return SurplusThresholds(medium: config.mediumRatio, high: config.highRatio);
});

/// One crop's bucket by database key, or null while loading / when the crop
/// has no active target.
final bucketForCropProvider = Provider.family<BucketStatus?, String>(
  (ref, crop) => bucketFor(ref.watch(bucketStatusProvider).value ?? const [], crop),
);

/// When the bucket on screen was fetched — for the "Updated … ago" label.
/// Null until it has been saved to the cache.
final bucketSavedAtProvider = Provider<DateTime?>((ref) {
  final bucket = ref.watch(bucketStatusProvider);
  return bucket.hasValue ? ref.watch(registrationRepositoryProvider).bucketSavedAt : null;
});

/// Realtime half of the live bucket (spec §17.1): any `farmer_registrations`
/// INSERT the user can see refreshes the bucket. Alive only while a screen
/// watches it; the channel is removed on dispose (and so on sign-out).
final bucketRealtimeProvider = Provider.autoDispose<void>((ref) {
  final unsubscribe = ref
      .watch(registrationRepositoryProvider)
      .watchRegistrations(() => ref.invalidate(bucketStatusProvider));
  ref.onDispose(unsubscribe);
});
