import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:farmfriend/features/settings/presentation/account_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import 'settings_test_fakes.dart';

void main() {
  // Tall surface: the whole form is on screen, so nothing needs scrolling.
  const surface = Size(390, 1700);

  // Field order in the form: name, surname, email (read-only), telephone.
  Finder field(int index) => find.byType(TextFormField).at(index);

  Future<FakeProfileController> pumpAccount(WidgetTester tester, {Locale? locale}) async {
    final fake = FakeProfileController(testFarmer);
    await pumpApp(
      tester,
      const AccountSettingsScreen(),
      overrides: [profileProvider.overrideWith(() => fake)],
      surfaceSize: surface,
      locale: locale ?? const Locale('en'),
    );
    await tester.pump();
    return fake;
  }

  testWidgets('fills the form from the profile', (tester) async {
    await pumpAccount(tester);

    expect(find.text('Nimal'), findsOneWidget);
    expect(find.text('Perera'), findsOneWidget);
    expect(find.text('nimal@example.com'), findsOneWidget);
    expect(find.text('Email cannot be changed here.'), findsOneWidget);
    // Stored as +94771234567, shown after the fixed +94 prefix.
    expect(find.text('771234567'), findsOneWidget);
    expect(find.text('Farmer'), findsOneWidget);
    expect(find.text('Kandy'), findsOneWidget);
    expect(find.text('Delete account'), findsOneWidget);
  });

  testWidgets('a bad phone number shows the validation error and does not save', (tester) async {
    final fake = await pumpAccount(tester);

    await tester.enterText(field(3), '12345');
    await tester.tap(find.text('Update Profile'));
    await tester.pump();

    expect(find.text('Enter a valid mobile number (7XXXXXXXX)'), findsOneWidget);
    expect(fake.saved, isEmpty);
  });

  testWidgets('an empty name is rejected', (tester) async {
    final fake = await pumpAccount(tester);

    await tester.enterText(field(0), '  ');
    await tester.tap(find.text('Update Profile'));
    await tester.pump();

    expect(find.text('This field is required'), findsOneWidget);
    expect(fake.saved, isEmpty);
  });

  testWidgets('a good number is saved normalized, with the other fields', (tester) async {
    final fake = await pumpAccount(tester);

    await tester.enterText(field(0), ' Sunil ');
    await tester.enterText(field(1), '');
    await tester.enterText(field(3), '0712345678');
    await tester.tap(find.text('Update Profile'));
    await tester.pump();
    await tester.pump();

    final saved = fake.saved.single;
    expect(saved.phone, '+94712345678');
    expect(saved.name, 'Sunil');
    expect(saved.surname, isNull);
    expect(saved.district, 'Kandy', reason: 'the English key is stored');
    expect(saved.userType, 'Farmer', reason: 'the English value is stored');
    expect(saved.email, 'nimal@example.com');
    expect(saved.id, 'user-1');
    expect(find.text('Profile updated.'), findsOneWidget);
    // The field now shows the stored number after the +94 prefix.
    expect(find.text('712345678'), findsOneWidget);
  });

  testWidgets('picking a district in Sinhala stores the English key', (tester) async {
    final fake = await pumpAccount(tester, locale: const Locale('si'));

    // Localized labels are shown…
    expect(find.text('මහනුවර'), findsOneWidget);
    expect(find.text('ගොවියා'), findsOneWidget);

    await tester.tap(find.text('මහනුවර'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ගාල්ල'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('පැතිකඩ යාවත්කාලීන කරන්න'));
    await tester.pump();
    await tester.pump();

    // …and the database value stays English.
    expect(fake.saved.single.district, 'Galle');
    expect(fake.saved.single.userType, 'Farmer');
  });

  testWidgets('delete needs the word DELETE typed first', (tester) async {
    await pumpAccount(tester);

    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();

    expect(find.text('Delete your account?'), findsOneWidget);
    TextButton confirm() => tester.widget<TextButton>(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextButton, 'Delete account'),
      ),
    );
    expect(confirm().onPressed, isNull);

    await tester.enterText(
      find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextField)),
      'DELETE',
    );
    await tester.pump();
    expect(confirm().onPressed, isNotNull);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Delete your account?'), findsNothing);
  });

  testWidgets('no overflow in Tamil at 320 dp and text scale 1.3', (tester) async {
    final fake = FakeProfileController(testFarmer);
    await pumpApp(
      tester,
      const AccountSettingsScreen(),
      overrides: [profileProvider.overrideWith(() => fake)],
      locale: const Locale('ta'),
      textScale: 1.3,
      surfaceSize: const Size(320, 640),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
