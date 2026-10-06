import 'package:farmfriend/core/notifications/local_notifications.dart';
import 'package:farmfriend/core/router/routes.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/notifications/data/notification_repository.dart';
import 'package:farmfriend/features/notifications/data/read_notifications_store.dart';
import 'package:farmfriend/features/notifications/domain/app_notification.dart';
import 'package:farmfriend/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'notifications_fakes.dart';
import 'notifications_realtime_fakes.dart';

void main() {
  late RealtimeHarness realtime;
  late FakeNotificationRepository repository;
  late List<ShownNotification> shown;

  ProviderContainer container({String? uid = 'user-1'}) => ProviderContainer.test(
    retry: (_, _) => null,
    overrides: [
      currentUserIdProvider.overrideWithValue(uid),
      supabaseClientProvider.overrideWithValue(realtime.db),
      notificationRepositoryProvider.overrideWithValue(repository),
      readNotificationsStoreProvider.overrideWithValue(MemoryReadNotificationsStore()),
      localNotificationsProvider.overrideWith((ref) => RecordingNotifications(ref, shown)),
    ],
  );

  setUp(() {
    realtime = RealtimeHarness();
    repository = FakeNotificationRepository([
      AppNotification(id: 'old', title: 'Old', message: 'Earlier', createdAt: DateTime(2026)),
    ]);
    shown = [];
  });

  test('does nothing while signed out', () {
    final c = container(uid: null);
    c.listen(notificationsRealtimeProvider, (_, _) {});
    verifyNever(() => realtime.db.channel(any()));
  });

  test('subscribes to notifications INSERT and removes the channel on dispose', () {
    final c = container();
    final sub = c.listen(notificationsRealtimeProvider, (_, _) {});

    expect(realtime.channelName, 'notifications-user-1');
    final subscription = realtime.subscription;
    expect(subscription.event, PostgresChangeEvent.insert);
    expect(subscription.table, 'notifications');
    expect(subscription.filter, isNull);
    verify(() => realtime.channel.subscribe()).called(1);

    sub.close();
    c.dispose();
    verify(() => realtime.db.removeChannel(realtime.channel)).called(1);
  });

  test('an insert is prepended, bumps the badge and shows a local notification', () async {
    final c = container();
    c.listen(notificationsRealtimeProvider, (_, _) {});
    c.listen(unreadNotificationCountProvider, (_, _) {});
    await c.read(notificationsProvider.future);
    await c.read(readNotificationIdsProvider.future);
    expect(c.read(unreadNotificationCountProvider), 1);

    realtime.subscription.emit(
      RealtimeHarness.payload(
        table: 'notifications',
        event: PostgresChangeEvent.insert,
        newRecord: {
          'id': 'new',
          'created_at': '2026-10-05T08:00:00Z',
          'title': 'Flood warning',
          'message': 'Move harvested crops to higher ground.',
        },
      ),
    );

    expect(c.read(notificationsProvider).requireValue.map((n) => n.id), ['new', 'old']);
    expect(c.read(unreadNotificationCountProvider), 2);
    expect(shown.single, (
      channel: NotifyChannel.alerts,
      title: 'Flood warning',
      body: 'Move harvested crops to higher ground.',
      route: Routes.notifications,
    ));
  });

  test('a broadcast without a title gets the localized fallback', () async {
    final c = container();
    c.listen(notificationsRealtimeProvider, (_, _) {});
    await c.read(notificationsProvider.future);

    realtime.subscription.emit(
      RealtimeHarness.payload(
        table: 'notifications',
        event: PostgresChangeEvent.insert,
        newRecord: {'id': 'new', 'title': ' ', 'message': ''},
      ),
    );

    expect(shown.single.title, 'New notification');
    expect(shown.single.body, isNull);
  });
}
