import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/notifications/data/notification_repository.dart';
import 'package:farmfriend/features/notifications/data/read_notifications_store.dart';
import 'package:farmfriend/features/notifications/domain/app_notification.dart';
import 'package:farmfriend/features/notifications/presentation/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/overflow_probe.dart';
import '../helpers/test_app.dart';
import '../unit/notifications_fakes.dart';

const _longMessage =
    'Heavy rain is expected across the hill country for the next three days. '
    'Delay fertiliser application, clear your drains and harvest mature carrots '
    'before Thursday. Contact your agriculture officer for seed protection advice.';

List<AppNotification> _inbox() => [
  AppNotification(
    id: 'n1',
    title: 'Weather advisory',
    message: _longMessage,
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  AppNotification(
    id: 'n2',
    title: 'Carrot surplus alert',
    message: 'Carrot is 90% registered for March.',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  AppNotification(
    id: 'n3',
    title: 'Welcome to FarmFriend',
    message: 'Thank you for joining.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

void main() {
  late FakeNotificationRepository repository;
  late MemoryReadNotificationsStore store;

  List<Override> overrides() => [
    currentUserIdProvider.overrideWithValue('user-1'),
    notificationRepositoryProvider.overrideWithValue(repository),
    readNotificationsStoreProvider.overrideWithValue(store),
  ];

  setUp(() {
    repository = FakeNotificationRepository(_inbox());
    store = MemoryReadNotificationsStore();
  });

  testWidgets('lists broadcasts newest first with icons and relative time', (tester) async {
    store.read['user-1'] = {'n3'};
    await pumpApp(tester, const NotificationsScreen(), overrides: overrides());
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Weather advisory'), findsOneWidget);
    expect(find.text('Carrot surplus alert'), findsOneWidget);
    expect(find.text('Welcome to FarmFriend'), findsOneWidget);
    expect(find.text('5 min ago'), findsOneWidget);
    expect(find.text('3 h ago'), findsOneWidget);
    expect(find.text('2 d ago'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_outlined), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    // Opening the inbox does not mark anything as read.
    expect(find.text('2 unread'), findsOneWidget);
    expect(store.read['user-1'], {'n3'});
  });

  testWidgets('tapping an item marks it read and shows the full message', (tester) async {
    await pumpApp(tester, const NotificationsScreen(), overrides: overrides());
    await tester.pumpAndSettle();
    expect(find.text('3 unread'), findsOneWidget);
    expect(tester.widget<Text>(find.text(_longMessage)).maxLines, 2);

    await tester.tap(find.text('Weather advisory'));
    await tester.pumpAndSettle();

    expect(find.text('2 unread'), findsOneWidget);
    expect(store.read['user-1'], {'n1'});
    expect(tester.widget<Text>(find.text(_longMessage)).maxLines, isNull);
  });

  testWidgets('"Mark all read" clears the unread header', (tester) async {
    await pumpApp(tester, const NotificationsScreen(), overrides: overrides());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mark all read'));
    await tester.pumpAndSettle();

    expect(find.text('Mark all read'), findsNothing);
    expect(find.textContaining('unread'), findsNothing);
    expect(store.read['user-1'], {'n1', 'n2', 'n3'});
  });

  testWidgets('empty inbox', (tester) async {
    repository.items = [];
    await pumpApp(tester, const NotificationsScreen(), overrides: overrides());
    await tester.pumpAndSettle();

    expect(find.text('No notifications yet'), findsOneWidget);
  });

  testWidgets('load failure shows Retry, which reloads', (tester) async {
    repository.fetchError = const AppException.network();
    await pumpApp(tester, const NotificationsScreen(), overrides: overrides());
    await tester.pumpAndSettle();
    expect(find.textContaining('No internet connection'), findsOneWidget);

    repository.fetchError = null;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Weather advisory'), findsOneWidget);
  });

  testWidgets('TC_L10N_01: no overflow in Sinhala and Tamil at text scale 1.3 on 320x640', (
    tester,
  ) async {
    const titles = {
      'si': 'කාලගුණ අනතුරු ඇඟවීම: කඳුකරයට තද වැසි අපේක්ෂා කෙරේ',
      'ta': 'வானிலை எச்சரிக்கை: மலைநாட்டில் கனமழை எதிர்பார்க்கப்படுகிறது',
    };
    const messages = {
      'si': 'ඉදිරි දින තුන තුළ කඳුකර ප්‍රදේශවලට තද වැසි ඇති විය හැක. පොහොර යෙදීම කල් දමා කාණු පිරිසිදු කරන්න.',
      'ta': 'அடுத்த மூன்று நாட்களில் மலைநாட்டில் கனமழை பெய்யக்கூடும். உரமிடுவதைத் தள்ளிவைத்து வடிகால்களைச் சுத்தம் செய்யுங்கள்.',
    };
    for (final locale in const [Locale('si'), Locale('ta')]) {
      final code = locale.languageCode;
      repository.items = [
        AppNotification(
          id: 'local',
          title: titles[code]!,
          message: messages[code]!,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        ..._inbox(),
      ];
      final problems = await collectLayoutErrors(() async {
        await pumpApp(
          tester,
          const NotificationsScreen(),
          overrides: overrides(),
          locale: locale,
          textScale: 1.3,
          surfaceSize: const Size(320, 640),
        );
        await tester.pumpAndSettle();
        // Unread header with "Mark all read", then an expanded item.
        expect(find.byIcon(Icons.done_all_rounded), findsOneWidget);
        await tester.tap(find.text(titles[code]!));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), const Offset(0, -600));
        await tester.pumpAndSettle();
      });
      expect(problems, isEmpty, reason: code);
      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets('empty and error states do not overflow in Sinhala and Tamil', (tester) async {
    for (final locale in const [Locale('si'), Locale('ta')]) {
      for (final error in [null, const AppException.network()]) {
        repository
          ..items = []
          ..fetchError = error;
        final problems = await collectLayoutErrors(() async {
          await pumpApp(
            tester,
            const NotificationsScreen(),
            overrides: overrides(),
            locale: locale,
            textScale: 1.3,
            surfaceSize: const Size(320, 640),
          );
          await tester.pumpAndSettle();
        });
        expect(problems, isEmpty, reason: '${locale.languageCode} error=$error');
        await tester.pumpWidget(const SizedBox());
      }
    }
  });
}
