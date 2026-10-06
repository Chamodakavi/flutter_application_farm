import 'package:flutter/foundation.dart';

/// Runs [body] and returns a one-line summary of every Flutter error raised
/// meanwhile, naming the widget (file:line) that caused it. Use it inside a
/// `testWidgets` body to assert that a screen lays out without overflow:
///
/// ```dart
/// final problems = await collectLayoutErrors(() async {
///   await pumpApp(tester, const MyScreen(), locale: const Locale('ta'), textScale: 1.3);
///   await tester.pumpAndSettle();
/// });
/// expect(problems, isEmpty);
/// ```
Future<List<String>> collectLayoutErrors(Future<void> Function() body) async {
  final found = <String>{};
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final lines = details
        .toString()
        .split('\n')
        .where((l) => l.contains('.dart:') || l.contains('overflowed'))
        .take(3)
        .map((l) => l.trim());
    found.add(lines.isEmpty ? details.exceptionAsString() : lines.join(' | '));
  };
  try {
    await body();
  } finally {
    FlutterError.onError = previous;
  }
  return found.toList();
}
