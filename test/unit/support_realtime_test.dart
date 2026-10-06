import 'package:farmfriend/core/notifications/local_notifications.dart';
import 'package:farmfriend/core/router/routes.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/support/data/complaint_repository.dart';
import 'package:farmfriend/features/support/domain/complaint.dart';
import 'package:farmfriend/features/support/presentation/controllers/complaints_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'notifications_realtime_fakes.dart';
import 'support_fakes.dart';

final _pending = Complaint(
  id: 5,
  subject: 'Seeds not delivered',
  body: 'Order 8 is late.',
  userId: 'user-1',
  status: 'Pending',
  createdAt: DateTime.utc(2026, 9, 1),
);

Map<String, dynamic> _row({String? reply, String status = 'Pending', String? readAt}) => {
  'id': 5,
  'created_at': '2026-09-01T00:00:00.000Z',
  'subject': 'Seeds not delivered',
  'body': 'Order 8 is late.',
  'user_id': 'user-1',
  'status': status,
  'admin_reply': reply,
  'replied_at': reply == null ? null : '2026-09-03T10:00:00.000Z',
  'read_at': readAt,
};

void main() {
  late RealtimeHarness realtime;
  late FakeComplaintRepository repository;
  late List<ShownNotification> shown;

  ProviderContainer container({String? uid = 'user-1'}) => ProviderContainer.test(
    retry: (_, _) => null,
    overrides: [
      currentUserIdProvider.overrideWithValue(uid),
      supabaseClientProvider.overrideWithValue(realtime.db),
      complaintRepositoryProvider.overrideWithValue(repository),
      localNotificationsProvider.overrideWith((ref) => RecordingNotifications(ref, shown)),
    ],
  );

  void emit(Map<String, dynamic> newRecord, {Map<String, dynamic> oldRecord = const {'id': 5}}) =>
      realtime.subscription.emit(
        RealtimeHarness.payload(
          table: 'complaints',
          event: PostgresChangeEvent.update,
          newRecord: newRecord,
          oldRecord: oldRecord,
        ),
      );

  setUp(() {
    realtime = RealtimeHarness();
    repository = FakeComplaintRepository([_pending]);
    shown = [];
  });

  test('does nothing while signed out', () {
    final c = container(uid: null);
    c.listen(complaintsRealtimeProvider, (_, _) {});
    verifyNever(() => realtime.db.channel(any()));
  });

  test('subscribes to the user\'s complaints UPDATE and removes the channel on dispose', () {
    final c = container();
    c.listen(complaintsRealtimeProvider, (_, _) {});

    expect(realtime.channelName, 'complaints-user-1');
    final subscription = realtime.subscription;
    expect(subscription.event, PostgresChangeEvent.update);
    expect(subscription.table, 'complaints');
    expect(subscription.filter?.type, PostgresChangeFilterType.eq);
    expect(subscription.filter?.column, 'user_id');
    expect(subscription.filter?.value, 'user-1');

    c.dispose();
    verify(() => realtime.db.removeChannel(realtime.channel)).called(1);
  });

  test('a new admin reply refreshes the list and shows a local notification', () async {
    final c = container();
    c.listen(complaintsRealtimeProvider, (_, _) {});
    await c.read(complaintsProvider.future);

    emit(_row(reply: 'It ships tomorrow.', status: 'Replied'));

    final updated = c.read(complaintsProvider).requireValue.single;
    expect(updated.adminReply, 'It ships tomorrow.');
    expect(updated.hasUnreadReply, isTrue);
    expect(shown.single, (
      channel: NotifyChannel.alerts,
      title: 'Admin replied to your message',
      body: 'Seeds not delivered',
      route: Routes.complaint(5),
    ));
  });

  test('later updates of the same reply stay silent', () async {
    final c = container();
    c.listen(complaintsRealtimeProvider, (_, _) {});
    await c.read(complaintsProvider.future);

    emit(_row(reply: 'It ships tomorrow.'));
    emit(_row(reply: 'It ships tomorrow.', status: 'Closed'));
    emit(_row(reply: 'It ships tomorrow.', status: 'Closed', readAt: '2026-09-04T08:00:00.000Z'));

    expect(shown, hasLength(1));
    final latest = c.read(complaintsProvider).requireValue.single;
    expect(latest.status, 'Closed');
    expect(latest.readAt, isNotNull);
  });

  test('a status change without a reply is applied but not announced', () async {
    final c = container();
    c.listen(complaintsRealtimeProvider, (_, _) {});
    await c.read(complaintsProvider.future);

    emit(_row(status: 'Closed'));

    expect(c.read(complaintsProvider).requireValue.single.status, 'Closed');
    expect(shown, isEmpty);
  });

  test('announces a reply even when the list was never opened', () {
    final c = container();
    c.listen(complaintsRealtimeProvider, (_, _) {});

    emit(_row(reply: 'It ships tomorrow.'));
    emit(_row(reply: 'It ships tomorrow.', status: 'Closed'));

    expect(shown, hasLength(1));
    // The list is not loaded just because of a realtime event.
    expect(repository.fetches, 0);
  });
}
