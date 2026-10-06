import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/speech_services.dart';
import '../controllers/chat_voice_controller.dart';

/// The question field with a hold-to-talk mic and the send button
/// (spec §14.3, §14.4). Sending needs a connection.
class ChatInputBar extends ConsumerStatefulWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.busy,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSend;

  /// A reply is pending — a second question cannot be sent yet.
  final bool busy;

  static const maxQuestionLength = 1000;

  @override
  ConsumerState<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends ConsumerState<ChatInputBar> {
  /// The finger is down on the mic (listening may still be starting).
  bool _holding = false;
  bool _listening = false;

  /// Set once the recognizer turns out not to support the app language.
  bool _micUnsupported = false;

  /// Resolved up front: `ref` cannot be used in [dispose].
  late final SpeechInput _speech;

  @override
  void initState() {
    super.initState();
    _speech = ref.read(speechInputProvider);
  }

  @override
  void dispose() {
    if (_listening) unawaited(_speech.stop());
    super.dispose();
  }

  void _submit() {
    final text = widget.controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
  }

  Future<void> _startListening() async {
    if (_holding) return;
    _holding = true;
    final l10n = context.l10n;
    final language = ref.read(localeControllerProvider).languageCode;
    // Dictated words are added after whatever is already typed.
    final typed = widget.controller.text.trim();
    final result = await _speech.start(
      languageCode: language,
      onWords: (words) {
        if (!mounted) return;
        final text = [typed, words.trim()].where((part) => part.isNotEmpty).join(' ');
        widget.controller.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      },
      onDone: () {
        if (!mounted) return;
        if (_listening) setState(() => _listening = false);
        unawaited(_recheck(language));
      },
    );
    if (!mounted) return;
    switch (result) {
      case SpeechStartResult.started:
        if (!_holding) {
          // Released while the permission prompt or the recognizer was
          // still starting.
          await _speech.stop();
          return;
        }
        setState(() => _listening = true);
        trackVoiceUsed(ref.read(analyticsProvider), mode: 'stt', language: language);
      case SpeechStartResult.unsupported:
        _holding = false;
        setState(() => _micUnsupported = true);
        context.showSnack(l10n.chatMicUnavailable);
      case SpeechStartResult.failed:
        _holding = false;
        context.showSnack(l10n.chatMicFailed);
    }
  }

  /// Listening can end because the recognizer rejected the language (some
  /// phones only report that after starting): hide the mic then.
  Future<void> _recheck(String language) async {
    final availability = await _speech.probe(language);
    if (!mounted || _micUnsupported || availability != MicAvailability.unavailable) return;
    setState(() => _micUnsupported = true);
    context.showSnack(context.l10n.chatMicUnavailable);
  }

  Future<void> _stopListening() async {
    _holding = false;
    if (!_listening) return;
    setState(() => _listening = false);
    await _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    // A new language gets a fresh check.
    ref.listen(localeControllerProvider, (_, _) {
      if (_micUnsupported) setState(() => _micUnsupported = false);
    });
    final mic = ref.watch(micAvailabilityProvider).value;
    final showMic =
        !_micUnsupported && (mic == MicAvailability.available || mic == MicAvailability.unknown);

    return Material(
      color: AppColors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_listening)
              Container(
                width: double.infinity,
                color: AppColors.red100,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.graphic_eq_rounded, size: 18, color: AppColors.red600),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.chatMicListening,
                        style: text.bodySmall?.copyWith(color: AppColors.red600),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showMic) ...[
                    _MicButton(
                      listening: _listening,
                      tooltip: l10n.chatMicHold,
                      onDown: () => unawaited(_startListening()),
                      onUp: () => unawaited(_stopListening()),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.newline,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(ChatInputBar.maxQuestionLength),
                      ],
                      style: text.bodyLarge,
                      decoration: InputDecoration(
                        hintText: l10n.chatInputHint,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: AppRadii.heroBorder,
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppRadii.heroBorder,
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppRadii.heroBorder,
                          borderSide: const BorderSide(color: AppColors.green600),
                        ),
                        filled: true,
                        fillColor: AppColors.fieldFill,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  OnlineOnly(
                    builder: (context, online) => ValueListenableBuilder<TextEditingValue>(
                      valueListenable: widget.controller,
                      builder: (context, value, _) {
                        final canSend = online && !widget.busy && value.text.trim().isNotEmpty;
                        return IconButton.filled(
                          onPressed: canSend ? _submit : null,
                          tooltip: l10n.chatSend,
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.green600,
                            foregroundColor: AppColors.white,
                            disabledBackgroundColor: AppColors.line200,
                            disabledForegroundColor: AppColors.ink500,
                            minimumSize: const Size(AppSpacing.minTap, AppSpacing.minTap),
                          ),
                          icon: const Icon(Icons.send_rounded),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Round mic that listens while it is held down.
class _MicButton extends StatelessWidget {
  const _MicButton({
    required this.listening,
    required this.tooltip,
    required this.onDown,
    required this.onUp,
  });

  final bool listening;
  final String tooltip;
  final VoidCallback onDown;
  final VoidCallback onUp;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Semantics(
      button: true,
      label: tooltip,
      // Screen-reader users cannot hold: a tap toggles listening instead.
      onTap: listening ? onUp : onDown,
      child: Listener(
        onPointerDown: (_) => onDown(),
        onPointerUp: (_) => onUp(),
        onPointerCancel: (_) => onUp(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: AppSpacing.minTap,
          height: AppSpacing.minTap,
          decoration: BoxDecoration(
            color: listening ? AppColors.red600 : AppColors.green100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            listening ? Icons.mic_rounded : Icons.mic_none_rounded,
            color: listening ? AppColors.white : AppColors.forest900,
          ),
        ),
      ),
    ),
  );
}
