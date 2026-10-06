import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Recognition locale for an app language (spec §14.4).
String sttLocaleFor(String languageCode) => switch (languageCode) {
  'si' => 'si_LK',
  'ta' => 'ta_LK',
  _ => 'en_US',
};

/// Voice locale for an app language. Tamil uses the Indian voice: devices
/// rarely ship a Sri Lankan Tamil one.
String ttsLocaleFor(String languageCode) => switch (languageCode) {
  'si' => 'si-LK',
  'ta' => 'ta-IN',
  _ => 'en-US',
};

String _normalize(String localeId) => localeId.replaceAll('-', '_').toLowerCase();

/// Picks the recognition locale to use from those the device reports
/// ([available] ids look like `si_LK` or `si-LK`): the preferred one, else any
/// locale of the same language (`ta_IN` for Tamil). Null = not supported.
String? pickSpeechLocale(String languageCode, Iterable<String> available) {
  final preferred = _normalize(sttLocaleFor(languageCode));
  String? sameLanguage;
  for (final id in available) {
    final normalized = _normalize(id);
    if (normalized == preferred) return id;
    if (normalized == languageCode || normalized.startsWith('${languageCode}_')) {
      sameLanguage ??= id;
    }
  }
  return sameLanguage;
}

/// What is known about the microphone before the user presses it.
enum MicAvailability {
  /// Recognition works for the app language.
  available,

  /// Microphone permission has not been granted yet, so the device cannot be
  /// asked; the check happens on the first press.
  unknown,

  /// No recognizer, or the app language is not supported: hide the mic.
  unavailable,
}

enum SpeechStartResult { started, unsupported, failed }

/// Speech-to-text behind an interface so the chat can be tested without the
/// plugin and never crashes when it is missing.
abstract class SpeechInput {
  /// Checks support for [languageCode] without showing a permission prompt.
  Future<MicAvailability> probe(String languageCode);

  /// Starts listening (asks for the microphone on first use). [onWords] gets
  /// the words recognised so far; [onDone] fires when listening ends.
  Future<SpeechStartResult> start({
    required String languageCode,
    required void Function(String words) onWords,
    required void Function() onDone,
  });

  Future<void> stop();
}

/// [SpeechInput] on top of the `speech_to_text` plugin.
class SpeechToTextInput implements SpeechInput {
  final _stt = SpeechToText();
  bool _initialized = false;
  void Function()? _onDone;

  /// Languages the recognizer rejected ("language not supported/unavailable").
  final _rejected = <String>{};
  String? _activeLanguage;

  Future<bool> _init() async {
    if (_initialized) return true;
    _initialized = await _stt.initialize(
      onStatus: _handleStatus,
      onError: _handleError,
      // Only the microphone permission is requested, not Bluetooth.
      options: [SpeechToText.androidNoBluetooth],
    );
    return _initialized;
  }

  void _handleStatus(String status) {
    if (status == SpeechToText.doneStatus || status == SpeechToText.notListeningStatus) {
      _finish();
    }
  }

  void _handleError(SpeechRecognitionError error) {
    final language = _activeLanguage;
    if (language != null && error.errorMsg.contains('language')) _rejected.add(language);
    _finish();
  }

  void _finish() {
    final done = _onDone;
    _onDone = null;
    done?.call();
  }

  /// The locale id to listen with, or null when the device reports locales
  /// and none of them matches. Some Android versions report no locales at
  /// all; the preferred id is then tried and a language error hides the mic.
  Future<String?> _localeFor(String languageCode) async {
    if (_rejected.contains(languageCode)) return null;
    final locales = await _stt.locales();
    if (locales.isEmpty) return sttLocaleFor(languageCode);
    return pickSpeechLocale(languageCode, locales.map((l) => l.localeId));
  }

  @override
  Future<MicAvailability> probe(String languageCode) async {
    try {
      if (!_initialized && !await _stt.hasPermission) return MicAvailability.unknown;
      if (!await _init()) return MicAvailability.unavailable;
      return await _localeFor(languageCode) == null
          ? MicAvailability.unavailable
          : MicAvailability.available;
    } catch (_) {
      // Plugin missing on this platform.
      return MicAvailability.unavailable;
    }
  }

  @override
  Future<SpeechStartResult> start({
    required String languageCode,
    required void Function(String words) onWords,
    required void Function() onDone,
  }) async {
    try {
      if (!await _init()) return SpeechStartResult.failed;
      final localeId = await _localeFor(languageCode);
      if (localeId == null) return SpeechStartResult.unsupported;
      if (_stt.isListening) await _stt.cancel();
      _onDone = onDone;
      _activeLanguage = languageCode;
      await _stt.listen(
        onResult: (result) => onWords(result.recognizedWords),
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          listenMode: ListenMode.dictation,
          partialResults: true,
          cancelOnError: true,
          listenFor: const Duration(seconds: 60),
        ),
      );
      return SpeechStartResult.started;
    } catch (_) {
      _onDone = null;
      return _rejected.contains(languageCode)
          ? SpeechStartResult.unsupported
          : SpeechStartResult.failed;
    }
  }

  @override
  Future<void> stop() async {
    try {
      if (_initialized) await _stt.stop();
    } catch (_) {}
  }
}

final speechInputProvider = Provider<SpeechInput>((ref) {
  final input = SpeechToTextInput();
  ref.onDispose(input.stop);
  return input;
});

/// Text-to-speech behind an interface, for the same reasons as [SpeechInput].
abstract class SpeechOutput {
  /// Whether a voice for [languageCode] is installed.
  Future<bool> isAvailable(String languageCode);

  /// Reads [text] aloud, replacing anything being read. [onDone] fires when
  /// it finishes, is stopped or fails. Returns false when nothing was spoken.
  Future<bool> speak(String text, {required String languageCode, required void Function() onDone});

  Future<void> stop();
}

/// [SpeechOutput] on top of the `flutter_tts` plugin.
class FlutterTtsOutput implements SpeechOutput {
  /// Slower than the default so advice is easy to follow (spec §14.4).
  static const speechRate = 0.45;

  FlutterTts? _engine;
  void Function()? _onDone;

  FlutterTts get _tts {
    final existing = _engine;
    if (existing != null) return existing;
    final created = FlutterTts()
      ..setCompletionHandler(_finish)
      ..setCancelHandler(_finish)
      ..setErrorHandler((_) => _finish());
    return _engine = created;
  }

  void _finish() {
    final done = _onDone;
    _onDone = null;
    done?.call();
  }

  @override
  Future<bool> isAvailable(String languageCode) async {
    try {
      final result = await _tts.isLanguageAvailable(ttsLocaleFor(languageCode));
      return result == true || result == 1;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> speak(
    String text, {
    required String languageCode,
    required void Function() onDone,
  }) async {
    if (text.trim().isEmpty) return false;
    try {
      _finish();
      await _tts.stop();
      await _tts.setLanguage(ttsLocaleFor(languageCode));
      await _tts.setSpeechRate(speechRate);
      _onDone = onDone;
      await _tts.speak(text);
      return true;
    } catch (_) {
      _onDone = null;
      return false;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _engine?.stop();
    } catch (_) {}
    _finish();
  }
}

final speechOutputProvider = Provider<SpeechOutput>((ref) {
  final output = FlutterTtsOutput();
  ref.onDispose(output.stop);
  return output;
});
