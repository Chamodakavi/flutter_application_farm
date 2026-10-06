import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:farmfriend/features/support/data/complaint_repository.dart';
import 'package:farmfriend/features/support/domain/complaint.dart';
import 'package:farmfriend/features/support/presentation/controllers/complaints_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support_fakes.dart';

final _pending = Complaint(
  id: 1,
  subject: 'Seeds not delivered',
  body: 'Order 8 is late.',
  status: 'Pending',
  createdAt: DateTime(2026, 9, 1),
);
final _replied = Complaint(
  id: 2,
  subject: 'Wrong quota',
  body: 'Please check.',
  status: 'Pending',
  adminReply: 'Fixed, thank you.',
  repliedAt: DateTime(2026, 9, 3),
  createdAt: DateTime(2026, 9, 2),
);

void main() {
  group('isNewAdminReply', () {
    test('no reply → never new', () {
      expect(isNewAdminReply(previous: null, updated: _pending), isFalse);
      expect(isNewAdminReply(previous: _pending, updated: _pending), isFalse);
      expect(
        isNewAdminReply(previous: null, updated: _pending.copyWith(adminReply: '  ')),
        isFalse,
      );
    });

    test('a reply that the copy on screen does not have is new', () {
      final before = _replied.copyWith(adminReply: null, repliedAt: null);
      expect(isNewAdminReply(previous: before, updated: _replied), isTrue);
      expect(
        isNewAdminReply(
          previous: _replied,
          updated: _replied.copyWith(adminReply: 'Edited.'),
        ),
        isTrue,
      );
    });

    test('the same reply again (status change, mark-read) is not new', () {
      expect(
        isNewAdminReply(
          previous: _replied,
          updated: _replied.copyWith(status: 'Closed'),
        ),
        isFalse,
      );
      expect(
        isNewAdminReply(
          previous: _replied,
          updated: _replied.copyWith(readAt: DateTime(2026)),
        ),
        isFalse,
      );
    });

    test('without a local copy the old realtime row decides, when it is complete', () {
      expect(
        isNewAdminReply(
          previous: null,
          updated: _replied,
          oldRecord: {'id': 2, 'admin_reply': null},
        ),
        isTrue,
      );
      expect(
        isNewAdminReply(
          previous: null,
          updated: _replied,
          oldRecord: {'id': 2, 'admin_reply': 'Fixed, thank you.'},
        ),
        isFalse,
      );
    });

    test('with nothing to compare, only an unread reply counts', () {
      expect(isNewAdminReply(previous: null, updated: _replied, oldRecord: {'id': 2}), isTrue);
      expect(
        isNewAdminReply(
          previous: null,
          updated: _replied.copyWith(readAt: DateTime(2026)),
          oldRecord: {'id': 2},
        ),
        isFalse,
      );
    });
  });

  test('chipStatus shows Replied for a pending message with a reply', () {
    expect(_pending.chipStatus, 'pending');
    expect(_replied.chipStatus, 'replied');
    expect(_replied.copyWith(status: 'Closed').chipStatus, 'closed');
    // Values the app does not know are shown as stored.
    expect(_pending.copyWith(status: 'Escalated').chipStatus, 'Escalated');
  });

  group('ComplaintsController', () {
    late FakeComplaintRepository repository;

    ProviderContainer container({String? uid = 'user-1'}) => ProviderContainer.test(
      // As in the app: a failed load goes straight to AsyncError.
      retry: (_, _) => null,
      overrides: [
        currentUserIdProvider.overrideWithValue(uid),
        complaintRepositoryProvider.overrideWithValue(repository),
        profileProvider.overrideWith(
          () => FakeProfileController(
            const AppUser(id: 'user-1', name: 'Nimal', surname: 'Perera', email: 'n@example.com'),
          ),
        ),
      ],
    );

    setUp(() => repository = FakeComplaintRepository([_replied, _pending]));

    test('loads the user messages; empty when signed out', () async {
      final c = container();
      expect(await c.read(complaintsProvider.future), [_replied, _pending]);

      final signedOut = container(uid: null);
      expect(await signedOut.read(complaintsProvider.future), isEmpty);
      expect(repository.fetches, 1);
    });

    test('send signs the message with the profile and puts it on top', () async {
      final c = container();
      await c.read(complaintsProvider.future);
      final created = await c
          .read(complaintsProvider.notifier)
          .send(subject: '  Need help  ', body: ' Details ');

      expect(repository.sent.single, {
        'subject': 'Need help',
        'body': 'Details',
        'user_name': 'Nimal Perera',
        'user_email': 'n@example.com',
      });
      final list = c.read(complaintsProvider).requireValue;
      expect(list.first, created);
      expect(list, hasLength(3));
      await pumpEventQueue();
      expect(repository.cached, list);
    });

    test('a failed send surfaces the error and leaves the list alone', () async {
      repository.sendError = const AppException.network();
      final c = container();
      await c.read(complaintsProvider.future);

      await expectLater(
        c.read(complaintsProvider.notifier).send(subject: 'a', body: 'b'),
        throwsA(isA<NetworkException>()),
      );
      expect(c.read(complaintsProvider).requireValue, hasLength(2));
    });

    test('applyUpdate replaces the row in place', () async {
      final c = container();
      await c.read(complaintsProvider.future);
      final updated = _pending.copyWith(adminReply: 'On its way.', status: 'Replied');
      c.read(complaintsProvider.notifier).applyUpdate(updated);

      expect(c.read(complaintsProvider).requireValue, [_replied, updated]);
    });

    test('markRead updates read_at once and ignores failures', () async {
      final c = container();
      await c.read(complaintsProvider.future);
      final controller = c.read(complaintsProvider.notifier);

      await controller.markRead(_pending); // nothing to read
      expect(repository.markedRead, isEmpty);

      await controller.markRead(_replied);
      expect(repository.markedRead, [2]);
      final after = c.read(complaintsProvider).requireValue.first;
      expect(after.readAt, isNotNull);
      expect(after.hasUnreadReply, isFalse);

      repository.markReadError = const AppException.permission();
      await controller.markRead(_replied.copyWith(id: 9));
      expect(repository.markedRead, [2]);
    });

    test('complaintProvider loads one message by id', () async {
      final c = container();
      final sub = c.listen(complaintProvider(2), (_, _) {});
      addTearDown(sub.close);
      expect(await c.read(complaintProvider(2).future), _replied);
    });
  });
}
