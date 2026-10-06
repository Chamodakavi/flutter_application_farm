import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/network/connectivity_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/chat_message.dart';
import 'controllers/chat_controller.dart';
import 'controllers/chat_voice_controller.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/suggestion_chips.dart';
import 'widgets/typing_indicator.dart';

/// Full-screen AgriBot conversation (spec §11.25, §14). Opened from the chat
/// bubble or with `/chat?prompt=…`, which only fills the input.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, this.initialPrompt});

  final String? initialPrompt;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  /// The feedback sheet is offered once the fifth question is answered.
  static const _feedbackAfter = 5;

  late final TextEditingController _input = TextEditingController(
    text: widget.initialPrompt?.trim() ?? '',
  );
  final _scroll = ScrollController();

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final prompt = widget.initialPrompt?.trim() ?? '';
    if (prompt.isNotEmpty && prompt != oldWidget.initialPrompt?.trim()) _input.text = prompt;
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _ask(String text) => unawaited(ref.read(chatControllerProvider.notifier).send(text));

  void _sendTyped(String text) {
    _input.clear();
    _ask(text);
  }

  /// The list is reversed, so offset 0 is the newest message.
  void _scrollToNewest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients || _scroll.offset <= 0) return;
      unawaited(
        _scroll.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
      );
    });
  }

  Future<void> _confirmClear() async {
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.chatClearTitle,
      message: l10n.chatClearMessage,
      confirmLabel: l10n.chatClearConfirm,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    await ref.read(chatSpeechProvider.notifier).stop();
    await ref.read(chatControllerProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(chatControllerProvider);
    final online = ref.watch(isOnlineProvider);
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    ref
      ..listen(
        chatControllerProvider.select((s) => s.messages.length + (s.waiting ? 1 : 0)),
        (_, _) => _scrollToNewest(),
      )
      ..listen(chatControllerProvider.select((s) => s.sentCount), (previous, next) {
        if (previous != null && next == previous + 1 && next >= _feedbackAfter) {
          unawaited(
            FeedbackSheet.maybeShowOnce(context, ref, contextKey: FeedbackContexts.fifthChat),
          );
        }
      });

    final Widget conversation;
    if (state.restoring) {
      conversation = const Center(child: CircularProgressIndicator());
    } else if (state.isEmpty && !state.waiting) {
      conversation = _EmptyChat(onSelected: online ? _ask : null);
    } else {
      conversation = _MessageList(state: state, online: online, controller: _scroll);
    }

    return AppScaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _Header(online: online),
        actions: [
          const _LanguageIndicator(),
          if (!state.isEmpty)
            IconButton(
              tooltip: l10n.chatClear,
              onPressed: _confirmClear,
              icon: const Icon(Icons.delete_sweep_outlined),
            )
          else
            const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Column(
        children: [
          // Only the conversation flexes, so everything pinned around it has
          // to fit a small phone with large text: the disclaimer steps aside
          // while the keyboard is open, and notices scroll with the messages.
          if (!keyboardOpen) const _Disclaimer(),
          Expanded(child: conversation),
          ChatInputBar(controller: _input, onSend: _sendTyped, busy: state.waiting),
        ],
      ),
    );
  }
}

/// "AgriBot · FarmFriend Assistant" with the online dot.
class _Header extends StatelessWidget {
  const _Header({required this.online});

  final bool online;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Semantics(
          label: online ? l10n.chatOnline : l10n.chatOffline,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const BotAvatar(size: 36),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: online ? AppColors.green500 : AppColors.ink500,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.forest900, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.chatTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                l10n.chatSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.bodySmall?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Pill showing the language AgriBot answers in; opens the language menu.
class _LanguageIndicator extends ConsumerWidget {
  const _LanguageIndicator();

  /// Short tags in each script, so the pill fits beside the title.
  static const _short = {'en': 'EN', 'si': 'සිං', 'ta': 'தமி'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(localeControllerProvider).languageCode;
    return PopupMenuButton<String>(
      tooltip: context.l10n.chatLanguageTooltip(AppLocales.nativeName(code)),
      onSelected: (selected) => unawaited(applyLocale(ref, selected)),
      itemBuilder: (_) => [
        for (final locale in AppLocales.all)
          PopupMenuItem(
            value: locale.languageCode,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocales.nativeName(locale.languageCode),
                    style: TextStyle(fontFamily: AppTypography.familyFor(locale)),
                  ),
                ),
                if (locale.languageCode == code)
                  const Icon(Icons.check_rounded, color: AppColors.green600, size: 18),
              ],
            ),
          ),
      ],
      child: SizedBox(
        height: AppSpacing.minTap,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              borderRadius: AppRadii.pillBorder,
              border: Border.all(color: Colors.white70),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language_rounded, size: 16, color: AppColors.white),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _short[code] ?? code.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.white, height: 1.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: AppColors.cream50,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.ink500),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(context.l10n.chatDisclaimer, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    ),
  );
}

/// Greeting and the four starter questions.
class _EmptyChat extends StatelessWidget {
  const _EmptyChat({required this.onSelected});

  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Centred when there is room, scrollable when the keyboard is open.
        final free = constraints.maxHeight - 2 * AppSpacing.lg;
        return SingleChildScrollView(
          padding: AppSpacing.page,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: free > 0 ? free : 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BotAvatar(size: 72),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.chatEmptyTitle, style: text.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.chatEmptyMessage,
                  style: text.bodyMedium?.copyWith(color: AppColors.ink500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                SuggestionChips(onSelected: onSelected),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MessageList extends ConsumerWidget {
  const _MessageList({required this.state, required this.online, required this.controller});

  final ChatState state;
  final bool online;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = state.all;
    final canSpeak = ref.watch(ttsAvailableProvider).value ?? false;
    final speakingId = ref.watch(chatSpeechProvider);
    // Under the newest message: the typing dots, or the 429 notice.
    final Widget? status = state.waiting
        ? const TypingIndicator()
        : state.rateLimited
        ? InfoNote(text: context.l10n.chatRateLimited, tone: InfoNoteTone.warning)
        : null;
    final leading = status == null ? 0 : 1;
    final footer = state.canLoadEarlier ? 1 : 0;

    // Reversed so the view stays pinned to the newest message; shrink-wrapped
    // and top-aligned so a short conversation still starts under the header.
    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        controller: controller,
        reverse: true,
        shrinkWrap: true,
        padding: AppSpacing.page,
        itemCount: messages.length + leading + footer,
        itemBuilder: (context, i) {
          if (i < leading) return status;
          final index = i - leading;
          if (index >= messages.length) return _LoadEarlier(loading: state.loadingEarlier);
          final message = messages[messages.length - 1 - index];
          return Padding(
            key: ValueKey(message.id),
            padding: EdgeInsets.only(bottom: i == 0 ? 0 : AppSpacing.md),
            child: ChatBubble(
              message: message,
              speaking: speakingId == message.id,
              onRetry: message.isFailed && online && !state.waiting
                  ? () => unawaited(ref.read(chatControllerProvider.notifier).retry(message.id))
                  : null,
              onSpeak: canSpeak && message.role == ChatRole.bot
                  ? () => unawaited(ref.read(chatSpeechProvider.notifier).toggle(message))
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _LoadEarlier extends ConsumerWidget {
  const _LoadEarlier({required this.loading});

  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Center(
      child: TextButton.icon(
        onPressed: loading
            ? null
            : () => unawaited(ref.read(chatControllerProvider.notifier).loadEarlier()),
        icon: loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.history_rounded, size: 18),
        label: Text(context.l10n.chatLoadEarlier),
      ),
    ),
  );
}
