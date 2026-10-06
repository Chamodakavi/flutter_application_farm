import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../cache/cache_policy.dart';
import '../cache/hive_boxes.dart';
import '../supabase/supabase_providers.dart';
import 'app_config.dart';
import 'constants.dart';

/// The `app_config` row, cached for an hour. Never fails: when the table is
/// unreachable the defaults apply, so a config problem cannot lock users out.
final appConfigProvider = FutureProvider<AppConfig>((ref) async {
  final db = ref.watch(supabaseClientProvider);
  final cache = ref.watch(cacheStoreProvider);
  try {
    return await cache.fetch<AppConfig>(
      box: HiveBoxes.cacheConfig,
      key: 'app_config',
      ttl: CacheTtl.config,
      load: () => db.from(Tables.appConfig).select().limit(1).maybeSingle(),
      decode: (json) => json is Map
          ? AppConfig.fromJson(Map<String, dynamic>.from(json))
          : const AppConfig(),
    );
  } catch (_) {
    return const AppConfig();
  }
});

/// Synchronous view of the config with defaults until it loads.
final appConfigOrDefaultProvider = Provider<AppConfig>(
  (ref) => ref.watch(appConfigProvider).value ?? const AppConfig(),
);

/// Installed app version, e.g. `1.0.0`.
final appVersionProvider = FutureProvider<String>((ref) async {
  try {
    return (await PackageInfo.fromPlatform()).version;
  } catch (_) {
    return '0.0.0';
  }
});

enum AppGate { open, maintenance, updateRequired }

/// Version gate / maintenance switch (spec §11.33). Stays [AppGate.open] until
/// both the config and the installed version are known.
final appGateProvider = Provider<AppGate>((ref) {
  final config = ref.watch(appConfigProvider).value;
  final version = ref.watch(appVersionProvider).value;
  if (config == null) return AppGate.open;
  if (config.inMaintenance) return AppGate.maintenance;
  if (version != null && version != '0.0.0' && config.requiresUpdate(version)) {
    return AppGate.updateRequired;
  }
  return AppGate.open;
});

/// A newer optional version is in the store — Home shows a dismissible banner.
final updateAvailableProvider = Provider<bool>((ref) {
  final config = ref.watch(appConfigProvider).value;
  final version = ref.watch(appVersionProvider).value;
  if (config == null || version == null || version == '0.0.0') return false;
  return config.hasUpdate(version);
});
