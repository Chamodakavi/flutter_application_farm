import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/notifications/data/notification_repository.dart';
import 'package:farmfriend/features/notifications/data/read_notifications_store.dart';
import 'package:farmfriend/features/notifications/domain/app_notification.dart';
import 'package:farmfriend/features/notifications/domain/notification_kind.dart';
import 'package:farmfriend/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'notifications_fakes.dart';

AppNotification _n(String id, {String title = 'Title', String message = 'Message'}) =>
    AppNotification(id: id, title: title, message: message, createdAt: DateTime(2026, 10, 1));

void main() {
  group('NotificationKind.of', () {
    test('alert and warning words win over everything else', () {
      expect(
        NotificationKind.of('Surplus alert', 'Carrot is 90% registered'),
        NotificationKind.alert,
      );
      expect(
        NotificationKind.of('Price WARNING', 'Market prices are falling'),
        NotificationKind.alert,
      );
      expect(NotificationKind.of('Notice', 'Urgent: update the app'), NotificationKind.alert);
    });

    test('weather and rain', () {
      expect(NotificationKind.of('Weather update', null), NotificationKind.weather);
      expect(
        NotificationKind.of('This week', 'Heavy rain expected in Kandy'),
        NotificationKind.weather,
      );
      expect(NotificationKind.of('Rainfall', 'above normal'), NotificationKind.weather);
    });

    test('market and price', () {
      expect(
        NotificationKind.of('Market news', 'Dambulla centre reopens'),
        NotificationKind.market,
      );
      expect(NotificationKind.of('Beans', 'Wholesale prices rose 5%'), NotificationKind.market);
    });

    test('orders and deliveries', () {
      expect(NotificationKind.of('Your order', 'has been approved'), NotificationKind.order);
      expect(NotificationKind.of('Seeds', 'Delivery takes 3 days'), NotificationKind.order);
    });

    test('whole words only, bell by default', () {
      expect(NotificationKind.of('Border farms', 'Training on Friday'), NotificationKind.general);
      expect(NotificationKind.of('Brain storming', 'session'), NotificationKind.general);
      expect(NotificationKind.of(null, null), NotificationKind.general);
      expect(NotificationKind.of('', ''), NotificationKind.general);
    });

    test('recognises Sinhala and Tamil broadcasts', () {
      expect(NotificationKind.of('අනතුරු ඇඟවීම', 'කැරට් කෝටාව පිරී ඇත'), NotificationKind.alert);
      expect(NotificationKind.of('කාලගුණ නිවේදනය', ''), NotificationKind.weather);
      expect(NotificationKind.of('இன்றைய சந்தை விலை', ''), NotificationKind.market);
      expect(NotificationKind.of('மழை', 'கனமழை எதிர்பார்க்கப்படுகிறது'), NotificationKind.weather);
    });

    test('each kind has its own icon; the default is the bell', () {
      expect(NotificationKind.general.icon, Icons.notifications_none_rounded);
      expect(NotificationKind.values.map((k) => k.icon).toSet(), hasLength(5));
    });
  });

  group('countUnread', () {
    final items = [_n('a'), _n('b'), _n('c')];

    test('counts the ids missing from the read set', () {
      expect(countUnread(items, const {}), 3);
      expect(countUnread(items, {'a'}), 2);
      expect(countUnread(items, {'a', 'b', 'c'}), 0);
      expect(countUnread(const [], {'a'}), 0);
    });

    test('ignores read ids of notifications that are no longer listed', () {
      expect(countUnread(items, {'gone', 'older', 'c'}), 2);
    });
  });

  group('unread badge', () {
    late FakeNotificationRepository repository;
    late MemoryReadNotificationsStore store;

    ProviderContainer container({String? uid = 'user-1'}) {
      final c = ProviderContainer.test(
        // As in the app: a failed load goes straight to AsyncError.
        retry: (_, _) => null,
        overrides: [
          currentUserIdProvider.overrideWithValue(uid),
          notificationRepositoryProvider.overrideWithValue(repository),
          readNotificationsStoreProvider.overrideWithValue(store),
        ],
      );
      c.listen(unreadNotificationCountProvider, (_, _) {});
      return c;
    }

    Future<void> loaded(ProviderContainer c) async {
      await c.read(notificationsProvider.future);
      await c.read(readNotificationIdsProvider.future);
    }

    setUp(() {
      repository = FakeNotificationRepository([_n('a'), _n('b'), _n('c')]);
      store = MemoryReadNotificationsStore();
    });

    test('is 0 while loading, then the number not in the read set', () async {
      store.read['user-1'] = {'b'};
      final c = container();
      expect(c.read(unreadNotificationCountProvider), 0);
      await loaded(c);
      expect(c.read(unreadNotificationCountProvider), 2);
    });

    test('is 0 when signed out and nothing is fetched', () async {
      final c = container(uid: null);
      await loaded(c);
      expect(c.read(unreadNotificationCountProvider), 0);
      expect(repository.fetches, 0);
    });

    test('read state is kept per user', () async {
      store.read['someone-else'] = {'a', 'b', 'c'};
      final c = container();
      await loaded(c);
      expect(c.read(unreadNotificationCountProvider), 3);
    });

    test('marking one, then all, read lowers the badge and is stored', () async {
      final c = container();
      await loaded(c);
      final read = c.read(readNotificationIdsProvider.notifier);

      await read.markRead('a');
      expect(c.read(unreadNotificationCountProvider), 2);
      expect(store.read['user-1'], {'a'});

      await read.markAllRead(['a', 'b', 'c']);
      expect(c.read(unreadNotificationCountProvider), 0);
      expect(store.read['user-1'], {'a', 'b', 'c'});
    });

    test('a realtime insert goes on top and bumps the badge once', () async {
      store.read['user-1'] = {'a', 'b', 'c'};
      final c = container();
      await loaded(c);
      final inbox = c.read(notificationsProvider.notifier);

      inbox.prepend(_n('new', title: 'Flood warning'));
      inbox.prepend(_n('new', title: 'Flood warning'));

      final items = c.read(notificationsProvider).requireValue;
      expect(items.map((n) => n.id), ['new', 'a', 'b', 'c']);
      expect(c.read(unreadNotificationCountProvider), 1);
      await pumpEventQueue();
      expect(repository.cached?.first.id, 'new');
    });

    test('the inbox never grows past the newest 100', () async {
      repository.items = [for (var i = 0; i < NotificationRepository.maxItems; i++) _n('n$i')];
      final c = container();
      await loaded(c);
      c.read(notificationsProvider.notifier).prepend(_n('new'));

      final items = c.read(notificationsProvider).requireValue;
      expect(items, hasLength(NotificationRepository.maxItems));
      expect(items.first.id, 'new');
      expect(items.last.id, 'n98');
    });

    test('a failed load keeps the badge at 0', () async {
      repository.fetchError = const AppException.network();
      final c = container();
      await expectLater(c.read(notificationsProvider.future), throwsA(isA<NetworkException>()));
      expect(c.read(unreadNotificationCountProvider), 0);
    });

    test('when the read store cannot be opened, read state still works in memory', () async {
      store.loadError = StateError('box unavailable');
      final c = container();
      await loaded(c);
      expect(c.read(unreadNotificationCountProvider), 3);
      store.loadError = null;
      await c.read(readNotificationIdsProvider.notifier).markRead('a');
      expect(c.read(unreadNotificationCountProvider), 2);
    });
  });
}
