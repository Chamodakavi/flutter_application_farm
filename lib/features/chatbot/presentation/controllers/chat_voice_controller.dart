import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../data/speech_services.dart';
import '../../domain/chat_message.dart';
import '../../domain/markdown_text.dart';

/// Whether a voice for the app language is installed; the speaker icon on bot
/// bubbles is hidden otherwise (spec §14.4).
final ttsAvailableProvider = FutureProvider.autoDispose<bool>((ref) {
  final language = ref.watch(localeControllerProvider).languageCode;
  return ref.watch(speechOutputProvider).isAvailable(language);
});

/// What is known about speech recognition for the app language before the
/// mic is pressed.
final micAvailabilityProvider = FutureProvider.autoDispose<MicAvailability>((ref) {
  final language = ref.watch(localeControllerProvider).languageCode;
  return ref.watch(speechInputProvider).probe(language);
});

/// Records one use of voice input (`stt`) or output (`tts`) — the mode and
/// language only.
void trackVoiceUsed(AnalyticsService analytics, {required String mode, required String language}) {
  try {
    analytics.track(AnalyticsEvents.voiceUsed, {'mode': mode, 'language': language});
  } catch (_) {
    // Analytics must never affect the chat.
  }
}

/// Id of the bot message being read aloud, or null. Leaving the chat stops
/// the voice.
class ChatSpeechController extends Notifier<String?> {
  @override
  String? build() {
    final output = ref.watch(speechOutputProvider);
    ref.onDispose(() => unawaited(output.stop()));
    return null;
  }

  /// Reads [message] aloud; tapping the message being read stops it.
  Future<void> toggle(ChatMessage message) async {
    final output = ref.read(speechOutputProvider);
    if (state == message.id) {
      state = null;
      await output.stop();
      return;
    }
    state = message.id;
    final language = ref.read(localeControllerProvider).languageCode;
    final started = await output.speak(
      stripMarkdown(message.text),
      languageCode: language,
      onDone: () {
        if (ref.mounted && state == message.id) state = null;
      },
    );
    if (!ref.mounted) return;
    if (started) {
      trackVoiceUsed(ref.read(analyticsProvider), mode: 'tts', language: language);
    } else if (state == message.id) {
      state = null;
    }
  }

  Future<void> stop() async {
    state = null;
    await ref.read(speechOutputProvider).stop();
  }
}

final chatSpeechProvider = NotifierProvider.autoDispose<ChatSpeechController, String?>(
  ChatSpeechController.new,
);
