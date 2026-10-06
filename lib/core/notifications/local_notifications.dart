import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../features/profile/presentation/controllers/profile_controller.dart';
import '../cache/hive_boxes.dart';

/// Android notification channels (spec §17.2).
enum NotifyChannel {
  alerts('alerts', 'Alerts'),
  orders('orders', 'Orders'),
  community('community', 'Community');

  const NotifyChannel(this.id, this.title);

  final String id;
  final String title;
}

/// Per-type notification switches kept on the device (Settings →
/// Notifications). The master switch is `users.u_notify` on the profile.
class NotificationPrefs {
  const NotificationPrefs({this.orders = true, this.community = true, this.news = true});

  final bool orders;
  final bool community;
  final bool news;

  bool allows(NotifyChannel channel) => switch (channel) {
    NotifyChannel.orders => orders,
    NotifyChannel.community => community,
    NotifyChannel.alerts => news,
  };
}

class NotificationPrefsController extends Notifier<NotificationPrefs> {
  Box<dynamic>? get _prefs =>
      Hive.isBoxOpen(HiveBoxes.prefs) ? Hive.box<dynamic>(HiveBoxes.prefs) : null;

  @override
  NotificationPrefs build() => NotificationPrefs(
    orders: _prefs?.get(PrefKeys.notifyOrders) as bool? ?? true,
    community: _prefs?.get(PrefKeys.notifyCommunity) as bool? ?? true,
    news: _prefs?.get(PrefKeys.notifyNews) as bool? ?? true,
  );

  Future<void> setOrders(bool v) => _set(PrefKeys.notifyOrders, v);
  Future<void> setCommunity(bool v) => _set(PrefKeys.notifyCommunity, v);
  Future<void> setNews(bool v) => _set(PrefKeys.notifyNews, v);

  Future<void> _set(String key, bool value) async {
    await _prefs?.put(key, value);
    ref.invalidateSelf();
  }
}

final notificationPrefsProvider =
    NotifierProvider<NotificationPrefsController, NotificationPrefs>(
      NotificationPrefsController.new,
    );

/// Shows system notifications for realtime events and foreground pushes.
class LocalNotifications {
  LocalNotifications(this._ref);

  final Ref _ref;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  int _nextId = 0;

  /// Set by the app shell: opens the route carried by a tapped notification.
  void Function(String route)? onOpenRoute;

  Future<void> init() async {
    if (_ready || kIsWeb) return;
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          // Permission is requested later, at a meaningful moment.
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (response) {
          final route = response.payload;
          if (route != null && route.isNotEmpty) onOpenRoute?.call(route);
        },
      );
      final android = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      for (final channel in NotifyChannel.values) {
        await android?.createNotificationChannel(
          AndroidNotificationChannel(channel.id, channel.title, importance: Importance.high),
        );
      }
      _ready = true;
    } catch (_) {
      // Unsupported platform (tests, desktop): notifications are simply off.
    }
  }

  /// Asks for the OS notification permission (Android 13+, iOS).
  Future<bool> requestPermission() async {
    if (!_ready) return false;
    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final granted =
        await android?.requestNotificationsPermission() ??
        await ios?.requestPermissions(alert: true, badge: true, sound: true);
    return granted ?? false;
  }

  /// Shows a notification unless the user switched this type off.
  /// [route] is opened when the notification is tapped.
  Future<void> show({
    required NotifyChannel channel,
    required String title,
    String? body,
    String? route,
  }) async {
    if (!_ready) return;
    final master = _ref.read(profileProvider).value?.notify ?? true;
    if (!master || !_ref.read(notificationPrefsProvider).allows(channel)) return;
    try {
      await _plugin.show(
        id: _nextId++,
        title: title,
        body: body,
        payload: route,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.title,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    } catch (_) {}
  }
}

final localNotificationsProvider = Provider<LocalNotifications>(LocalNotifications.new);
