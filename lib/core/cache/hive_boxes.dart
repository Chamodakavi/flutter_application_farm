import 'package:hive_ce_flutter/hive_flutter.dart';

/// Hive box names (spec §17.3). Boxes hold JSON strings and primitives only,
/// so no type adapters are needed.
abstract final class HiveBoxes {
  static const prefs = 'prefs';
  static const cacheNews = 'cache_news';
  static const cacheBucket = 'cache_bucket';
  static const cacheProducts = 'cache_products';
  static const cacheWeather = 'cache_weather';
  static const cachePrices = 'cache_prices';
  static const cacheConfig = 'cache_config';

  /// Per-user cached reads (profile, cart, orders, registrations, feed).
  static const cacheUser = 'cache_user';

  static const _shared = [
    prefs,
    cacheNews,
    cacheBucket,
    cacheProducts,
    cacheWeather,
    cachePrices,
    cacheConfig,
    cacheUser,
  ];

  static String chat(String uid) => 'chat_$uid';
  static String readNotifications(String uid) => 'read_notifications_$uid';

  static Future<void> init() async {
    await Hive.initFlutter();
    for (final name in _shared) {
      await Hive.openBox<dynamic>(name);
    }
  }

  /// Opens a per-user box on demand.
  static Future<Box<dynamic>> open(String name) async =>
      Hive.isBoxOpen(name) ? Hive.box<dynamic>(name) : Hive.openBox<dynamic>(name);

  /// Removes everything tied to a signed-in user (called on sign out, §8.5).
  static Future<void> clearUserData(String uid) async {
    if (Hive.isBoxOpen(cacheUser)) await Hive.box<dynamic>(cacheUser).clear();
    for (final name in [chat(uid), readNotifications(uid)]) {
      final box = await open(name);
      await box.clear();
    }
  }
}

/// Keys inside the `prefs` box.
abstract final class PrefKeys {
  static const locale = 'locale';
  static const onboardingDone = 'onboarding_done';
  static const notifyOrders = 'notify_orders';
  static const notifyCommunity = 'notify_community';
  static const notifyNews = 'notify_news';
  static const pushPrompted = 'push_prompted';

  static String feedbackShown(String uid, String context) => 'feedback_${uid}_$context';
  static String chatCount(String uid) => 'chat_count_$uid';
}
