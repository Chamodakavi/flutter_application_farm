import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../data/registration_repository.dart';
import '../../domain/bucket_rules.dart';
import '../../domain/farmer_registration.dart';
import '../../domain/register_result.dart';
import 'bucket_controller.dart';

final _registrationsGateProvider = Provider<RefreshGate>((ref) => RefreshGate());
final _cropRegistrationsGateProvider = Provider<RefreshGate>((ref) => RefreshGate());

/// The signed-in farmer's `farmer_registrations`, newest first.
final myRegistrationsProvider = FutureProvider<List<FarmerRegistration>>((ref) async {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return const [];
  final force = ref.watch(_registrationsGateProvider).take();
  return ref.watch(registrationRepositoryProvider).myRegistrations(uid, forceRefresh: force);
});

/// The signed-in farmer's `crop_registrations` (status badge on Home). Never
/// fails: an unreadable table yields an empty list.
final myCropRegistrationsProvider = FutureProvider<List<CropRegistration>>((ref) async {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return const [];
  final force = ref.watch(_cropRegistrationsGateProvider).take();
  try {
    return await ref
        .watch(registrationRepositoryProvider)
        .myCropRegistrations(uid, forceRefresh: force);
  } catch (_) {
    return const [];
  }
});

/// Status of the newest `crop_registrations` row per crop key — shown as a
/// chip next to a quota when a matching row exists (spec §11.11, §22.1).
final cropRegistrationStatusProvider = Provider<Map<String, String>>((ref) {
  final rows = ref.watch(myCropRegistrationsProvider).value ?? const <CropRegistration>[];
  final byCrop = <String, String>{};
  for (final row in rows) {
    final status = row.status?.trim() ?? '';
    if (status.isEmpty) continue;
    byCrop.putIfAbsent(row.cropName.trim().toUpperCase(), () => status);
  }
  return byCrop;
});

/// "Check & Register" (spec §11.10). State is true while the RPC is running.
class RegisterController extends Notifier<bool> {
  @override
  bool build() => false;

  /// Instant answer from the cached bucket: a warning when the amount cannot
  /// fit, null otherwise. [submit] still has the final say.
  RegisterSurplus? preCheck(String cropName, double amountMt) => preCheckSurplus(
    ref.read(bucketStatusProvider).value ?? const [],
    cropName,
    amountMt,
  );

  /// Calls `register_harvest` and refreshes everything that shows quotas.
  Future<RegisterResult> submit(String cropName, double amountMt) async {
    final analytics = ref.read(analyticsProvider);
    state = true;
    analytics.track(AnalyticsEvents.registerCheck, {'crop': cropName, 'amount_mt': amountMt});
    try {
      final result = await ref.read(registrationRepositoryProvider).register(cropName, amountMt);
      switch (result) {
        case RegisterSuccess():
          analytics.track(AnalyticsEvents.registerSuccess, {
            'crop': cropName,
            'amount_mt': amountMt,
          });
          _refreshQuotas();
        case RegisterSurplus(:final limitMt, :final filledMt):
          analytics.track(AnalyticsEvents.registerSurplus, {
            'crop': cropName,
            'fill_pct': limitMt <= 0 ? 100 : (filledMt / limitMt * 100).clamp(0, 100).round(),
          });
          // The cached bucket was wrong or is about to be: reload it.
          ref.invalidate(bucketStatusProvider);
        case RegisterUnknown():
          // The row may or may not exist — show the truth.
          _refreshQuotas();
        case RegisterNoTarget():
          ref.invalidate(bucketStatusProvider);
        case RegisterInvalid():
          break;
      }
      return result;
    } finally {
      if (ref.mounted) state = false;
    }
  }

  void _refreshQuotas() {
    ref.invalidate(bucketStatusProvider);
    ref.invalidate(myRegistrationsProvider);
    ref.invalidate(myCropRegistrationsProvider);
  }

  /// The farmer picked a suggested crop from the surplus warning.
  void alternativeChosen({required String from, required String to}) {
    ref.read(analyticsProvider).track(AnalyticsEvents.altCropChosen, {'from': from, 'to': to});
  }
}

final registerControllerProvider = NotifierProvider<RegisterController, bool>(
  RegisterController.new,
);
