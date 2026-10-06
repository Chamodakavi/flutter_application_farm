import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../../../core/notifications/local_notifications.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/notification_repository.dart';
import '../../data/read_notifications_store.dart';
import '../../domain/app_notification.dart';

/// How many of [items] have not been opened yet, given the ids read on this
/// device.
int countUnread(Iterable<AppNotification> items, Set<String> readIds) =>
    items.where((n) => !readIds.contains(n.id)).length;

/// The broadcast inbox, newest first (spec §11.24).
class NotificationsController extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    final uid = ref.watch(currentUserIdProvider);
    if (uid == null) return const [];
    return ref.watch(notificationRepositoryProvider).fetchLatest(uid);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  /// Adds a broadcast that arrived over realtime to the top of the inbox.
  void prepend(AppNotification notification) {
    final current = state.value;
    // Still loading: the fetch in progress already includes the new row.
    if (current == null || current.any((n) => n.id == notification.id)) return;
    final items = [notification, ...current].take(NotificationRepository.maxItems).toList();
    state = AsyncData(items);
    final uid = ref.read(currentUserIdProvider);
    if (uid != null) unawaited(_cache(uid, items));
  }

  Future<void> _cache(String uid, List<AppNotification> items) async {
    try {
      await ref.read(notificationRepositoryProvider).saveToCache(uid, items);
    } catch (_) {
      // The offline copy is refreshed on the next successful load.
    }
  }
}

final notificationsProvider = AsyncNotifierProvider<NotificationsController, List<AppNotification>>(
  NotificationsController.new,
);

/// Ids of the broadcasts this user has opened on this device.
class ReadNotificationsController extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final uid = ref.watch(currentUserIdProvider);
    if (uid == null) return const {};
    try {
      return await ref.watch(readNotificationsStoreProvider).load(uid);
    } catch (_) {
      // Storage unavailable: read state then lasts for this session only.
      return {};
    }
  }

  Future<void> markRead(String id) => markAllRead([id]);

  Future<void> markAllRead(Iterable<String> ids) async {
    final current = state.value ?? await future;
    final added = ids.where((id) => !current.contains(id)).toList();
    if (added.isEmpty || !ref.mounted) return;
    state = AsyncData({...current, ...added});
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) return;
    try {
      await ref.read(readNotificationsStoreProvider).addAll(uid, added);
    } catch (_) {
      // Kept in memory; see build().
    }
  }
}

final readNotificationIdsProvider = AsyncNotifierProvider<ReadNotificationsController, Set<String>>(
  ReadNotificationsController.new,
);

/// Unread broadcast notifications — the bell badge. 0 while loading or signed
/// out.
final unreadNotificationCountProvider = Provider<int>((ref) {
  if (ref.watch(currentUserIdProvider) == null) return 0;
  final items = ref.watch(notificationsProvider).value;
  final readIds = ref.watch(readNotificationIdsProvider).value;
  if (items == null || readIds == null) return 0;
  return countUnread(items, readIds);
});

/// Watched by the app shell while signed in: realtime `notifications` inserts
/// prepend to the inbox, bump the badge and show a local notification
/// (spec §17.1).
final notificationsRealtimeProvider = Provider<void>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return;
  final db = ref.watch(supabaseClientProvider);

  void onInsert(PostgresChangePayload payload) {
    if (!ref.mounted) return;
    final AppNotification notification;
    try {
      notification = AppNotification.fromJson(payload.newRecord);
    } catch (_) {
      ref.invalidate(notificationsProvider);
      return;
    }
    ref.read(notificationsProvider.notifier).prepend(notification);

    final title = notification.title.trim();
    final message = notification.message.trim();
    final l10n = lookupAppLocalizations(ref.read(localeControllerProvider));
    // `show` respects the master switch (`u_notify`) and the per-type toggle.
    unawaited(
      ref
          .read(localNotificationsProvider)
          .show(
            channel: NotifyChannel.alerts,
            title: title.isEmpty ? l10n.notifNewTitle : title,
            body: message.isEmpty ? null : message,
            route: Routes.notifications,
          ),
    );
  }

  final channel = db
      .channel('notifications-$uid')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: Tables.notifications,
        callback: onInsert,
      )
      .subscribe();
  ref.onDispose(() => unawaited(db.removeChannel(channel)));
});
