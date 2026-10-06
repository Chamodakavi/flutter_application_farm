import 'dart:async';

import 'package:farmfriend/core/analytics/analytics_service.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/network/connectivity_provider.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/chatbot/data/chat_repository.dart';
import 'package:farmfriend/features/chatbot/data/chat_store.dart';
import 'package:farmfriend/features/chatbot/data/speech_services.dart';
import 'package:farmfriend/features/chatbot/domain/chat_message.dart';
import 'package:farmfriend/features/chatbot/presentation/chat_screen.dart';
import 'package:farmfriend/features/chatbot/presentation/widgets/suggestion_chips.dart';
import 'package:farmfriend/features/chatbot/presentation/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/overflow_probe.dart';
import '../helpers/test_app.dart';
import '../unit/chat_fakes.dart';

const _suggestions = [
  'Which crop should I plant next month?',
  'Price of carrot this month?',
  'What seeds are in the marketplace?',
  'How to control leaf curl in chilli?',
];

/// Text inside bubbles: bot replies are Markdown (rich, selectable) text.
Finder _bubbleText(String text) => find.textContaining(text, findRichText: true);

void main() {
  late FakeChatRepository repository;
  late MemoryChatStore store;

  setUp(() {
    repository = FakeChatRepository();
    store = MemoryChatStore();
  });

  Future<void> pumpChat(
    WidgetTester tester, {
    String? initialPrompt,
    FakeSpeechInput? speechInput,
    FakeSpeechOutput? speechOutput,
    bool online = true,
    Locale locale = const Locale('en'),
    double textScale = 1.0,
    Size surfaceSize = const Size(390, 844),
  }) async {
    final screen = ChatScreen(initialPrompt: initialPrompt);
    await pumpApp(
      tester,
      // pumpApp pins the app online; a nested scope takes the screen offline.
      online
          ? screen
          : ProviderScope(overrides: [isOnlineProvider.overrideWithValue(false)], child: screen),
      overrides: chatOverrides(
        repository: repository,
        store: store,
        speechInput: speechInput,
        speechOutput: speechOutput,
      ),
      locale: locale,
      textScale: textScale,
      surfaceSize: surfaceSize,
    );
    // Restore the saved conversation.
    await tester.pump();
    await tester.pump();
  }

  testWidgets('empty state shows the header, disclaimer and four suggestion chips', (tester) async {
    await pumpChat(tester);

    expect(find.text('AgriBot'), findsOneWidget);
    expect(find.text('FarmFriend Assistant'), findsOneWidget);
    expect(find.textContaining('AgriBot can make mistakes'), findsOneWidget);
    expect(find.byType(SuggestionChips), findsOneWidget);
    for (final suggestion in _suggestions) {
      expect(find.text(suggestion), findsOneWidget);
    }
    // No plugin voice available in this test: no mic.
    expect(find.byIcon(Icons.mic_none_rounded), findsNothing);
    expect(repository.sent, isEmpty);
  });

  testWidgets('tapping a suggestion sends it and shows the reply', (tester) async {
    final reply = Completer<String>();
    repository.script.add(reply);
    await pumpChat(tester);

    await tester.tap(find.text(_suggestions[1]));
    await tester.pump();
    await tester.pump();

    expect(repository.sent, [_suggestions[1]]);
    expect(find.byType(SuggestionChips), findsNothing);
    expect(_bubbleText(_suggestions[1]), findsOneWidget);
    expect(find.byType(TypingIndicator), findsOneWidget);

    reply.complete('Carrot is about **Rs. 240/kg** this month.');
    await tester.pumpAndSettle();

    expect(find.byType(TypingIndicator), findsNothing);
    // Markdown is rendered: the asterisks are gone.
    expect(_bubbleText('Rs. 240/kg'), findsOneWidget);
    expect(_bubbleText('**'), findsNothing);
    expect(store.messages['user-1'], hasLength(2));
  });

  testWidgets('typing a question and pressing send delivers it', (tester) async {
    await pumpChat(tester);

    final send = find.widgetWithIcon(IconButton, Icons.send_rounded);
    expect(tester.widget<IconButton>(send).onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'When do I plant beans?');
    await tester.pump();
    await tester.tap(send);
    await tester.pumpAndSettle();

    expect(repository.sent, ['When do I plant beans?']);
    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, isEmpty);
    expect(_bubbleText('Reply to: When do I plant beans?'), findsOneWidget);
  });

  testWidgets('a failed message shows "Tap to retry" and retrying sends it again', (tester) async {
    repository.script.addAll([const AppException.network('chat_502'), 'Use neem oil.']);
    await pumpChat(tester);

    await tester.tap(find.text(_suggestions[3]));
    await tester.pumpAndSettle();

    expect(find.text('Not sent. Tap to retry'), findsOneWidget);
    expect(_bubbleText(_suggestions[3]), findsOneWidget);
    expect(store.messages['user-1']?.single.status, ChatStatus.failed);

    await tester.tap(find.text('Not sent. Tap to retry'));
    await tester.pumpAndSettle();

    expect(repository.sent, [_suggestions[3], _suggestions[3]]);
    expect(find.text('Not sent. Tap to retry'), findsNothing);
    expect(_bubbleText('Use neem oil.'), findsOneWidget);
  });

  testWidgets('429 shows the "too many questions" notice', (tester) async {
    repository.script.add(const AppException.conflict('chat_rate_limited'));
    await pumpChat(tester);

    await tester.tap(find.text(_suggestions[0]));
    await tester.pumpAndSettle();

    expect(find.text('Too many questions — please wait a minute.'), findsOneWidget);
    expect(find.text('Not sent. Tap to retry'), findsOneWidget);
  });

  testWidgets('initialPrompt fills the input without sending', (tester) async {
    await pumpChat(tester, initialPrompt: 'What will carrot sell for in March?');

    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'What will carrot sell for in March?',
    );
    expect(repository.sent, isEmpty);
    expect(find.byType(SuggestionChips), findsOneWidget);
  });

  testWidgets('offline: suggestions and send are disabled', (tester) async {
    await pumpChat(tester, online: false, initialPrompt: 'Hello');

    expect(find.textContaining("You're offline"), findsOneWidget);
    await tester.tap(find.text(_suggestions[0]));
    await tester.pump();
    expect(repository.sent, isEmpty);
    final send = find.widgetWithIcon(IconButton, Icons.send_rounded);
    expect(tester.widget<IconButton>(send).onPressed, isNull);
  });

  testWidgets('restored conversation: speaker reads a bot reply without Markdown', (tester) async {
    final output = FakeSpeechOutput(available: true);
    store.messages['user-1'] = [
      ChatMessage(
        id: 'q',
        role: ChatRole.user,
        text: 'Carrot price?',
        createdAt: DateTime(2026, 3, 1, 9),
      ),
      ChatMessage(
        id: 'a',
        role: ChatRole.bot,
        text: '## Price\n**Rs. 240** per kg',
        createdAt: DateTime(2026, 3, 1, 9, 1),
      ),
    ];
    await pumpChat(tester, speechOutput: output);
    await tester.pumpAndSettle();

    expect(find.byType(SuggestionChips), findsNothing);
    expect(_bubbleText('Carrot price?'), findsOneWidget);
    // One speaker, on the bot bubble only.
    expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.volume_up_outlined));
    await tester.pump();
    expect(output.spoken, ['Price\nRs. 240 per kg']);
    expect(find.byIcon(Icons.stop_circle_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.stop_circle_outlined));
    await tester.pump();
    expect(output.stops, greaterThan(0));
    expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);
  });

  testWidgets('no speaker when no voice is installed', (tester) async {
    store.messages['user-1'] = [
      ChatMessage(id: 'a', role: ChatRole.bot, text: 'Hello', createdAt: DateTime(2026, 3)),
    ];
    await pumpChat(tester);
    await tester.pumpAndSettle();

    expect(_bubbleText('Hello'), findsOneWidget);
    expect(find.byIcon(Icons.volume_up_outlined), findsNothing);
  });

  testWidgets('hold-to-talk writes the recognised words into the input', (tester) async {
    final input = FakeSpeechInput(availability: MicAvailability.available);
    await pumpChat(tester, speechInput: input);

    final mic = find.byIcon(Icons.mic_none_rounded);
    expect(mic, findsOneWidget);

    final gesture = await tester.startGesture(tester.getCenter(mic));
    await tester.pump();
    expect(input.starts, 1);
    expect(find.textContaining('Listening'), findsOneWidget);

    input.onWords?.call('carrot price');
    await tester.pump();
    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, 'carrot price');

    await gesture.up();
    await tester.pump();
    expect(input.stops, 1);
    expect(find.textContaining('Listening'), findsNothing);
    // Dictation never sends by itself.
    expect(repository.sent, isEmpty);
  });

  testWidgets('the mic disappears when the language turns out to be unsupported', (tester) async {
    final input = FakeSpeechInput(
      availability: MicAvailability.unknown,
      startResult: SpeechStartResult.unsupported,
    );
    await pumpChat(tester, speechInput: input);

    final mic = find.byIcon(Icons.mic_none_rounded);
    expect(mic, findsOneWidget);
    final gesture = await tester.startGesture(tester.getCenter(mic));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(find.byIcon(Icons.mic_none_rounded), findsNothing);
    expect(find.textContaining('Voice typing is not available'), findsOneWidget);
  });

  testWidgets('the mic disappears when the recognizer rejects the language mid-way', (
    tester,
  ) async {
    final input = FakeSpeechInput(availability: MicAvailability.available);
    await pumpChat(tester, speechInput: input);

    final gesture = await tester.startGesture(
      tester.getCenter(find.byIcon(Icons.mic_none_rounded)),
    );
    await tester.pump();
    expect(find.textContaining('Listening'), findsOneWidget);

    // "error_language_not_supported" arrives after listening started.
    input.availability = MicAvailability.unavailable;
    input.onDone?.call();
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(find.textContaining('Listening'), findsNothing);
    expect(find.byIcon(Icons.mic_none_rounded), findsNothing);
    expect(find.byIcon(Icons.mic_rounded), findsNothing);
    expect(find.textContaining('Voice typing is not available'), findsOneWidget);
  });

  testWidgets('without the speech plugins the screen still works, with no mic or speaker', (
    tester,
  ) async {
    store.messages['user-1'] = [
      ChatMessage(id: 'a', role: ChatRole.bot, text: 'Hello', createdAt: DateTime(2026, 3)),
    ];
    // The real plugin wrappers: every platform call fails in a test.
    await pumpApp(
      tester,
      const ChatScreen(),
      overrides: [
        currentUserIdProvider.overrideWithValue('user-1'),
        chatRepositoryProvider.overrideWithValue(repository),
        chatStoreProvider.overrideWithValue(store),
        analyticsProvider.overrideWith((ref) => RecordingAnalytics(ref, [])),
      ],
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(_bubbleText('Hello'), findsOneWidget);
    expect(find.byIcon(Icons.mic_none_rounded), findsNothing);
    expect(find.byIcon(Icons.volume_up_outlined), findsNothing);

    await tester.enterText(find.byType(TextField), 'Still works?');
    await tester.pump();
    await tester.tap(find.widgetWithIcon(IconButton, Icons.send_rounded));
    await tester.pumpAndSettle();
    expect(repository.sent, ['Still works?']);
  });

  testWidgets('clear chat asks first, then empties the conversation', (tester) async {
    await pumpChat(tester);
    await tester.tap(find.text(_suggestions[2]));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_sweep_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Clear this chat?'), findsOneWidget);

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(find.byType(SuggestionChips), findsOneWidget);
    expect(store.messages['user-1'], isEmpty);
  });

  group('TC_L10N_01: no overflow at text scale 1.3 on 320x640', () {
    const small = Size(320, 640);
    const questions = {
      'si': 'ලබන මාසයේ මා වගා කළ යුත්තේ කුමන බෝගයද?',
      'ta': 'அடுத்த மாதம் நான் எந்தப் பயிரை நட வேண்டும்?',
    };
    const answers = {
      'si':
          '## නිර්දේශය\n**බෝංචි** වගා කරන්න. කැරට් කෝටාව දැනටමත් පිරී ඇත.\n\n'
          '- බීජ වෙළඳපොළෙන් ලබාගත හැක\n- මිල ගණන් පහත වගුවේ ඇත\n\n'
          '| බෝගය | මිල |\n|---|---|\n| කැරට් | 240 |\n| බෝංචි | 310 |',
      'ta':
          '## பரிந்துரை\n**பீன்ஸ்** நடவும். கேரட் ஒதுக்கீடு ஏற்கனவே நிரம்பியுள்ளது.\n\n'
          '- விதைகள் சந்தையில் கிடைக்கும்\n- விலைகள் கீழே உள்ள அட்டவணையில்\n\n'
          '| பயிர் | விலை |\n|---|---|\n| கேரட் | 240 |\n| பீன்ஸ் | 310 |',
    };

    for (final code in ['si', 'ta']) {
      testWidgets('$code: empty state with the mic', (tester) async {
        final problems = await collectLayoutErrors(() async {
          await pumpChat(
            tester,
            speechInput: FakeSpeechInput(availability: MicAvailability.available),
            locale: Locale(code),
            textScale: 1.3,
            surfaceSize: small,
          );
          await tester.pumpAndSettle();
        });
        expect(problems, isEmpty);
        expect(find.byType(SuggestionChips), findsOneWidget);
      });

      testWidgets('$code: conversation with a failed message, voice and the 429 notice', (
        tester,
      ) async {
        store.messages['user-1'] = [
          ChatMessage(
            id: 'q1',
            role: ChatRole.user,
            text: questions[code]!,
            createdAt: DateTime(2026, 3, 1, 9),
          ),
          ChatMessage(
            id: 'a1',
            role: ChatRole.bot,
            text: answers[code]!,
            createdAt: DateTime(2026, 3, 1, 9, 1),
          ),
          ChatMessage(
            id: 'q2',
            role: ChatRole.user,
            text: questions[code]!,
            createdAt: DateTime(2026, 3, 1, 9, 2),
            status: ChatStatus.failed,
          ),
        ];
        // Retrying is refused with 429, then the reply is held back so the
        // typing indicator stays on screen.
        final held = Completer<String>();
        repository.script.addAll([const AppException.conflict('chat_rate_limited'), held]);
        final input = FakeSpeechInput(availability: MicAvailability.available);

        final problems = await collectLayoutErrors(() async {
          await pumpChat(
            tester,
            speechInput: input,
            speechOutput: FakeSpeechOutput(available: true),
            locale: Locale(code),
            textScale: 1.3,
            surfaceSize: small,
          );
          await tester.pumpAndSettle();

          // Failed bubble → retry → rate-limit notice.
          await tester.tap(find.byIcon(Icons.error_outline_rounded));
          await tester.pumpAndSettle();
          expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

          // Hold the mic: the "listening" strip appears above the input.
          final gesture = await tester.startGesture(
            tester.getCenter(find.byIcon(Icons.mic_none_rounded)),
          );
          await tester.pump();
          input.onWords?.call(questions[code]!);
          await tester.pump();
          await gesture.up();
          await tester.pump();

          // Keyboard open with a long question typed: the pinned parts must
          // still fit above it.
          tester.view.viewInsets = const FakeViewPadding(bottom: 300);
          addTearDown(tester.view.resetViewInsets);
          await tester.enterText(find.byType(TextField), '${questions[code]!} ' * 4);
          await tester.pumpAndSettle();
          final holding = await tester.startGesture(
            tester.getCenter(find.byIcon(Icons.mic_none_rounded)),
          );
          await tester.pump();
          await holding.up();
          await tester.pump();
          tester.view.resetViewInsets();
          await tester.enterText(find.byType(TextField), '');
          await tester.pumpAndSettle();

          // Retry again: typing indicator while the reply is pending.
          await tester.tap(find.byIcon(Icons.error_outline_rounded));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
          expect(find.byType(TypingIndicator), findsOneWidget);

          // Scroll back to the oldest message and open the language menu.
          await tester.drag(find.byType(ListView), const Offset(0, 600));
          await tester.pump(const Duration(milliseconds: 300));
          await tester.tap(find.byIcon(Icons.language_rounded));
          await tester.pump(const Duration(milliseconds: 400));
        });
        held.complete('ok');
        await tester.pump();
        expect(problems, isEmpty);
      });
    }
  });
}
