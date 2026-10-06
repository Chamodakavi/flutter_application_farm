import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:farmfriend/features/support/data/complaint_repository.dart';
import 'package:farmfriend/features/support/domain/complaint.dart';
import 'package:farmfriend/features/support/presentation/complaint_detail_screen.dart';
import 'package:farmfriend/features/support/presentation/contact_screen.dart';
import 'package:farmfriend/features/support/presentation/widgets/complaint_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/overflow_probe.dart';
import '../helpers/test_app.dart';
import '../unit/support_fakes.dart';

final _pending = Complaint(
  id: 1,
  subject: 'Seeds not delivered',
  body: 'Order 8 is late.',
  status: 'Pending',
  createdAt: DateTime(2026, 9, 1),
);
final _replied = Complaint(
  id: 2,
  subject: 'Wrong quota amount',
  body: 'Please check my carrot registration.',
  status: 'Pending',
  adminReply: 'Fixed, thank you for telling us.',
  repliedAt: DateTime(2026, 9, 3, 14, 30),
  createdAt: DateTime(2026, 9, 2),
);

/// A replied complaint (id 2) written in [locale]'s language, with long text.
Complaint _localized(Locale locale) => locale.languageCode == 'si'
    ? _replied.copyWith(
        subject: 'මගේ කැරට් ලියාපදිංචියේ කෝටා ප්‍රමාණය වැරදියි, කරුණාකර නිවැරදි කරන්න',
        body: 'මම මෙට්‍රික් ටොන් 2ක් ලියාපදිංචි කළ නමුත් යෙදුමේ පෙන්වන්නේ 20ක් ලෙසයි. කරුණාකර පරීක්ෂා කරන්න.',
        adminReply: 'ඔබගේ ලියාපදිංචිය නිවැරදි කර ඇත. අපට දැනුම් දීම ගැන ස්තුතියි.',
      )
    : _replied.copyWith(
        subject: 'எனது கேரட் பதிவின் ஒதுக்கீட்டு அளவு தவறாக உள்ளது, தயவுசெய்து திருத்தவும்',
        body: 'நான் 2 மெட்ரிக் டன் பதிவு செய்தேன், ஆனால் செயலியில் 20 எனக் காட்டுகிறது. சரிபார்க்கவும்.',
        adminReply: 'உங்கள் பதிவு திருத்தப்பட்டுள்ளது. தெரிவித்தமைக்கு நன்றி.',
      );

List<Override> _overrides(FakeComplaintRepository repository) => [
  currentUserIdProvider.overrideWithValue('user-1'),
  complaintRepositoryProvider.overrideWithValue(repository),
  profileProvider.overrideWith(
    () => FakeProfileController(
      const AppUser(id: 'user-1', name: 'Nimal', email: 'nimal@example.com'),
    ),
  ),
];

/// The form has two fields: Subject, then Description.
final _subjectField = find.byType(TextFormField).at(0);
final _descriptionField = find.byType(TextFormField).at(1);

void main() {
  group('ContactScreen', () {
    testWidgets('shows validation errors for an empty subject and description', (tester) async {
      final repository = FakeComplaintRepository();
      await pumpApp(tester, const ContactScreen(), overrides: _overrides(repository));
      await tester.pumpAndSettle();

      expect(find.text('Send New Message'), findsOneWidget);
      expect(find.text('Admin will review your message and reply if needed.'), findsOneWidget);

      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsNWidgets(2));
      expect(repository.sent, isEmpty);

      // Only the description missing → one error left.
      await tester.enterText(_subjectField, 'Late delivery');
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();
      expect(find.text('This field is required'), findsOneWidget);
      expect(repository.sent, isEmpty);
    });

    testWidgets('renders the sent messages with count badge, status and reply indicator', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const ContactScreen(),
        overrides: _overrides(FakeComplaintRepository([_replied, _pending])),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Sent Messages'), findsOneWidget);
      expect(find.text('2 Records'), findsOneWidget);
      expect(find.byType(ComplaintTile), findsNWidgets(2));
      expect(find.text('Wrong quota amount'), findsOneWidget);
      expect(find.text('Seeds not delivered'), findsOneWidget);
      expect(find.text('2 Sep 2026'), findsOneWidget);
      // Pending in the database + a reply reads "Replied".
      expect(find.text('Replied'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Admin replied'), findsOneWidget);
    });

    testWidgets('shows the empty state when nothing was sent', (tester) async {
      await pumpApp(
        tester,
        const ContactScreen(),
        overrides: _overrides(FakeComplaintRepository()),
      );
      await tester.pumpAndSettle();

      expect(find.text('No messages sent yet.'), findsOneWidget);
      expect(find.text('No records'), findsOneWidget);
    });

    testWidgets('shows the error with Retry when the list fails to load', (tester) async {
      final repository = FakeComplaintRepository([_pending])
        ..fetchError = const AppException.network();
      await pumpApp(tester, const ContactScreen(), overrides: _overrides(repository));
      await tester.pumpAndSettle();
      expect(find.textContaining('No internet connection'), findsOneWidget);

      repository.fetchError = null;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Seeds not delivered'), findsOneWidget);
    });

    testWidgets('initialSubject pre-fills Subject and a valid message is sent', (tester) async {
      final repository = FakeComplaintRepository();
      await pumpApp(
        tester,
        const ContactScreen(initialSubject: 'Problem with order #8'),
        overrides: _overrides(repository),
      );
      await tester.pumpAndSettle();
      expect(find.text('Problem with order #8'), findsOneWidget);

      await tester.enterText(_descriptionField, 'The seeds have not arrived.');
      await tester.tap(find.text('Send Message'));
      await tester.pumpAndSettle();

      expect(repository.sent.single, {
        'subject': 'Problem with order #8',
        'body': 'The seeds have not arrived.',
        'user_name': 'Nimal',
        'user_email': 'nimal@example.com',
      });
      expect(find.textContaining('Message sent'), findsOneWidget);
      // Form cleared, new message listed.
      expect(find.byType(ComplaintTile), findsOneWidget);
      expect(find.text('1 Record'), findsOneWidget);
      expect(find.text('Problem with order #8'), findsOneWidget);
    });

    testWidgets('tapping a message opens its detail route', (tester) async {
      await pumpApp(
        tester,
        const ContactScreen(),
        overrides: _overrides(FakeComplaintRepository([_replied])),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(ComplaintTile));
      await tester.tap(find.byType(ComplaintTile));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker('/support/2')), findsOneWidget);
    });

    testWidgets('TC_L10N_01: no overflow in Sinhala and Tamil at text scale 1.3 on 320x640', (
      tester,
    ) async {
      for (final locale in const [Locale('si'), Locale('ta')]) {
        final problems = await collectLayoutErrors(() async {
          await pumpApp(
            tester,
            const ContactScreen(),
            overrides: _overrides(FakeComplaintRepository([_localized(locale), _pending])),
            locale: locale,
            textScale: 1.3,
            surfaceSize: const Size(320, 640),
          );
          await tester.pumpAndSettle();
          // Validation messages under both fields.
          await tester.ensureVisible(find.byIcon(Icons.send_rounded));
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.send_rounded));
          await tester.pumpAndSettle();
          expect(
            tester
                .widgetList<TextField>(find.byType(TextField))
                .map((f) => f.decoration?.errorText),
            everyElement(isNotNull),
          );
          for (var i = 0; i < 6; i++) {
            await tester.drag(find.byType(ListView).first, const Offset(0, -300));
            await tester.pumpAndSettle();
          }
          expect(find.byType(ComplaintTile), findsWidgets);
        });
        expect(problems, isEmpty, reason: locale.languageCode);
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('empty and error states do not overflow in Sinhala and Tamil', (tester) async {
      for (final locale in const [Locale('si'), Locale('ta')]) {
        for (final error in [null, const AppException.network()]) {
          final problems = await collectLayoutErrors(() async {
            await pumpApp(
              tester,
              const ContactScreen(),
              overrides: _overrides(FakeComplaintRepository()..fetchError = error),
              locale: locale,
              textScale: 1.3,
              surfaceSize: const Size(320, 640),
            );
            await tester.pumpAndSettle();
            await tester.drag(find.byType(ListView).first, const Offset(0, -900));
            await tester.pumpAndSettle();
          });
          expect(problems, isEmpty, reason: '${locale.languageCode} error=$error');
          await tester.pumpWidget(const SizedBox());
        }
      }
    });
  });

  group('ComplaintDetailScreen', () {
    testWidgets('shows the message and the admin reply, and marks it read', (tester) async {
      final repository = FakeComplaintRepository([_replied, _pending]);
      await pumpApp(
        tester,
        const ComplaintDetailScreen(complaintId: 2),
        overrides: _overrides(repository),
      );
      await tester.pumpAndSettle();

      expect(find.text('Wrong quota amount'), findsOneWidget);
      expect(find.text('Please check my carrot registration.'), findsOneWidget);
      expect(find.text('Admin reply'), findsOneWidget);
      expect(find.text('Fixed, thank you for telling us.'), findsOneWidget);
      expect(find.textContaining('Replied 3 Sep 2026'), findsOneWidget);
      expect(repository.markedRead, [2]);
    });

    testWidgets('without a reply it explains that the admin will answer', (tester) async {
      final repository = FakeComplaintRepository([_pending]);
      await pumpApp(
        tester,
        const ComplaintDetailScreen(complaintId: 1),
        overrides: _overrides(repository),
      );
      await tester.pumpAndSettle();

      expect(find.text('Order 8 is late.'), findsOneWidget);
      expect(find.textContaining('No reply yet'), findsOneWidget);
      expect(find.text('Admin reply'), findsNothing);
      expect(repository.markedRead, isEmpty);
    });

    testWidgets('a missing message shows the not-found error', (tester) async {
      final repository = FakeComplaintRepository()..fetchError = const AppException.notFound();
      await pumpApp(
        tester,
        const ComplaintDetailScreen(complaintId: 77),
        overrides: _overrides(repository),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining("couldn't find"), findsOneWidget);
    });

    testWidgets('TC_L10N_01: no overflow in Sinhala and Tamil at text scale 1.3 on 320x640', (
      tester,
    ) async {
      for (final locale in const [Locale('si'), Locale('ta')]) {
        for (final id in [2, 1]) {
          final problems = await collectLayoutErrors(() async {
            await pumpApp(
              tester,
              ComplaintDetailScreen(complaintId: id),
              overrides: _overrides(FakeComplaintRepository([_localized(locale), _pending])),
              locale: locale,
              textScale: 1.3,
              surfaceSize: const Size(320, 640),
            );
            await tester.pumpAndSettle();
            await tester.drag(find.byType(ListView), const Offset(0, -600));
            await tester.pumpAndSettle();
          });
          expect(problems, isEmpty, reason: '${locale.languageCode} complaint $id');
          await tester.pumpWidget(const SizedBox());
        }
      }
    });
  });
}
