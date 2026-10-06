import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../analytics/analytics_service.dart';
import '../cache/hive_boxes.dart';
import '../config/constants.dart';
import '../l10n/locale_provider.dart';
import '../router/routes.dart';
import '../supabase/supabase_providers.dart';
import 'local_notifications.dart';

/// FCM push (spec §17.2): surplus alerts, order status, complaint replies and
/// admin broadcasts sent by the backend.
///
/// Firebase needs `google-services.json` / `GoogleService-Info.plist`. Until
/// those are added the service stays disabled and every call is a no-op, so
/// the rest of the app runs unchanged.
class PushService {
  PushService(this._ref);

  final Ref _ref;
  bool _available = false;
  String? _token;
  final _subs = <StreamSubscription<dynamic>>[];

  bool get isAvailable => _available;

  Future<void> init() async {
    if (_available || kIsWeb) return;
    try {
      await Firebase.initializeApp();
      _available = true;
    } catch (_) {
      return; // Firebase not configured for this build.
    }
    _subs
      ..add(FirebaseMessaging.onMessage.listen(_onForeground))
      ..add(FirebaseMessaging.onMessageOpenedApp.listen(_onOpened))
      ..add(FirebaseMessaging.instance.onTokenRefresh.listen(_saveToken));
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _onOpened(initial);
  }

  /// Stores this device's token for the signed-in user. Called after sign-in
  /// and when the language changes.
  Future<void> registerDevice() async {
    if (!_available) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _saveToken(token);
    } catch (_) {}
  }

  /// Removes this device's token row. Called before sign-out (spec §8.5).
  Future<void> unregisterDevice() async {
    if (!_available) return;
    try {
      final token = _token ?? await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _ref.read(supabaseClientProvider).from(Tables.deviceTokens).delete().eq('token', token);
    } catch (_) {}
  }

  /// Asks for the OS permission, once, at a meaningful moment (after the first
  /// registration or order, or from Settings → Notifications).
  Future<bool> requestPermission({bool force = false}) async {
    final prefs = Hive.isBoxOpen(HiveBoxes.prefs) ? Hive.box<dynamic>(HiveBoxes.prefs) : null;
    if (!force && prefs?.get(PrefKeys.pushPrompted) == true) return false;
    await prefs?.put(PrefKeys.pushPrompted, true);
    final local = await _ref.read(localNotificationsProvider).requestPermission();
    if (!_available) return local;
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      if (granted) await registerDevice();
      return granted;
    } catch (_) {
      return local;
    }
  }

  Future<void> _saveToken(String token) async {
    _token = token;
    final db = _ref.read(supabaseClientProvider);
    final uid = db.auth.currentUser?.id;
    if (uid == null) return;
    try {
      // The unique key of device_tokens is not part of the contract, so
      // replace the row instead of relying on an upsert conflict target.
      await db.from(Tables.deviceTokens).delete().eq('token', token);
      await db.from(Tables.deviceTokens).insert({
        'user_id': uid,
        'token': token,
        'platform': defaultTargetPlatform.name,
        'locale': _ref.read(localeControllerProvider).languageCode,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {}
  }

  void _onForeground(RemoteMessage message) {
    final n = message.notification;
    final title = n?.title ?? message.data['title']?.toString();
    if (title == null) return;
    _ref.read(localNotificationsProvider).show(
      channel: _channelFor(message.data),
      title: title,
      body: n?.body ?? message.data['body']?.toString(),
      route: routeFor(message.data),
    );
  }

  void _onOpened(RemoteMessage message) {
    _ref.read(analyticsProvider).track(
      AnalyticsEvents.pushOpened,
      {'type': message.data['type']?.toString()},
    );
    _ref.read(localNotificationsProvider).onOpenRoute?.call(routeFor(message.data));
  }

  NotifyChannel _channelFor(Map<String, dynamic> data) => switch (data['type']) {
    'order' => NotifyChannel.orders,
    'community' => NotifyChannel.community,
    _ => NotifyChannel.alerts,
  };

  /// Deep link for a push payload: an explicit `route`, or one derived from
  /// `type` (surplus → crop outlook, order → orders, complaint → its thread).
  @visibleForTesting
  static String routeFor(Map<String, dynamic> data) {
    final route = data['route']?.toString();
    if (route != null && route.startsWith('/')) return route;
    switch (data['type']) {
      case 'surplus':
        final crop = (data['crop'] ?? data['crop_name'])?.toString();
        return crop == null || crop.isEmpty ? Routes.outlook : Routes.outlookCrop(crop);
      case 'order':
        final id = int.tryParse('${data['order_id'] ?? ''}');
        return id == null ? Routes.orders : Routes.ordersWith(id);
      case 'complaint':
        final id = int.tryParse('${data['complaint_id'] ?? data['id'] ?? ''}');
        return id == null ? Routes.support : Routes.complaint(id);
      default:
        return Routes.notifications;
    }
  }

  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
  }
}

final pushServiceProvider = Provider<PushService>((ref) {
  final service = PushService(ref);
  ref.onDispose(service.dispose);
  return service;
});
