import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/district_labels.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../data/weather_repository.dart';
import '../../domain/weather.dart';

/// The district whose centroid the forecast is for: the profile's
/// `u_district`, or Colombo until one is chosen (spec §11.9).
final weatherDistrictProvider = Provider<District>((ref) {
  final key = ref.watch(profileProvider.select((p) => p.value?.district));
  return Districts.byKey(key) ?? Districts.fallback;
});

/// Forecast for [weatherDistrictProvider]; reloads when the district changes.
class WeatherController extends AsyncNotifier<Weather> {
  @override
  Future<Weather> build() {
    final district = ref.watch(weatherDistrictProvider);
    return ref.watch(weatherRepositoryProvider).fetch(district);
  }

  /// Pull-to-refresh: skips the 30-minute cache. On failure the forecast
  /// already on screen stays and the error is rethrown for a snackbar.
  Future<void> refresh() async {
    final district = ref.read(weatherDistrictProvider);
    try {
      final fresh = await ref.read(weatherRepositoryProvider).fetch(district, forceRefresh: true);
      if (!ref.mounted) return;
      state = AsyncData(fresh);
    } catch (e, st) {
      if (!ref.mounted) return;
      if (state.hasValue) rethrow;
      state = AsyncError(e, st);
    }
  }
}

final weatherProvider = AsyncNotifierProvider<WeatherController, Weather>(WeatherController.new);

/// When the forecast on screen was downloaded; null when nothing is cached.
final weatherUpdatedAtProvider = Provider<DateTime?>((ref) {
  ref.watch(weatherProvider);
  return ref.watch(weatherRepositoryProvider).savedAt(ref.watch(weatherDistrictProvider));
});
