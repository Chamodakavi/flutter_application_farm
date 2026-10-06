import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/chat_message.dart';

const _corner = Radius.circular(18);
const _tail = Radius.circular(4);

/// Bot bubbles point to the avatar on the left, user bubbles to the right.
const botBubbleRadius = BorderRadius.only(
  topLeft: _corner,
  topRight: _corner,
  bottomRight: _corner,
  bottomLeft: _tail,
);
const userBubbleRadius = BorderRadius.only(
  topLeft: _corner,
  topRight: _corner,
  bottomLeft: _corner,
  bottomRight: _tail,
);

/// The leaf mark shown next to everything AgriBot says.
class BotAvatar extends StatelessWidget {
  const BotAvatar({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(color: AppColors.green100, shape: BoxShape.circle),
    child: Icon(Icons.eco_rounded, size: size * 0.6, color: AppColors.green600),
  );
}

/// One message: the user's on the right in green, AgriBot's on the left as a
/// white card with rendered Markdown (spec §14.3).
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.onRetry,
    this.onSpeak,
    this.speaking = false,
  });

  final ChatMessage message;

  /// Re-sends a failed user message.
  final VoidCallback? onRetry;

  /// Reads a bot message aloud; null hides the speaker icon.
  final VoidCallback? onSpeak;

  /// This message is being read aloud — the icon becomes "stop".
  final bool speaking;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.82;
    return message.isUser
        ? _UserBubble(message: message, onRetry: onRetry, maxWidth: maxWidth)
        : _BotBubble(message: message, onSpeak: onSpeak, speaking: speaking, maxWidth: maxWidth);
  }
}

/// Time of a message; empty for bubbles rebuilt from the server history,
/// which has no timestamps.
String _timeOf(BuildContext context, ChatMessage message) =>
    message.createdAt.millisecondsSinceEpoch <= 0
    ? ''
    : Fmt.time(message.createdAt, context.localeTag);

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message, required this.onRetry, required this.maxWidth});

  final ChatMessage message;
  final VoidCallback? onRetry;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final failed = message.isFailed;
    final time = _timeOf(context, message);

    final Widget footer;
    if (failed) {
      footer = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.red600),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              l10n.chatFailedRetry,
              style: text.labelSmall?.copyWith(color: AppColors.red600),
            ),
          ),
        ],
      );
    } else if (message.status == ChatStatus.sending) {
      footer = Text(l10n.chatSending, style: text.bodySmall);
    } else {
      footer = Text(time, style: text.bodySmall);
    }

    final bubble = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: failed ? AppColors.green600.withValues(alpha: 0.6) : AppColors.green600,
            borderRadius: userBubbleRadius,
          ),
          child: Text(message.text, style: text.bodyLarge?.copyWith(color: AppColors.white)),
        ),
        if (failed || time.isNotEmpty || message.status == ChatStatus.sending)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs, right: AppSpacing.xs),
            child: footer,
          ),
      ],
    );

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: failed
            ? Semantics(
                button: true,
                child: InkWell(
                  onTap: onRetry,
                  borderRadius: userBubbleRadius,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: AppSpacing.minTap),
                    child: bubble,
                  ),
                ),
              )
            : bubble,
      ),
    );
  }
}

class _BotBubble extends StatelessWidget {
  const _BotBubble({
    required this.message,
    required this.onSpeak,
    required this.speaking,
    required this.maxWidth,
  });

  final ChatMessage message;
  final VoidCallback? onSpeak;
  final bool speaking;
  final double maxWidth;

  Future<void> _open(String? href) async {
    final uri = Uri.tryParse(href ?? '');
    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // No browser available: the link text stays readable in the bubble.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final l10n = context.l10n;
    final time = _timeOf(context, message);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BotAvatar(),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: botBubbleRadius,
                      border: Border.all(color: AppColors.line200),
                      boxShadow: kCardShadow,
                    ),
                    child: MarkdownBody(
                      data: message.text,
                      selectable: true,
                      softLineBreak: true,
                      onTapLink: (_, href, _) => unawaited(_open(href)),
                      imageBuilder: (uri, _, alt) => uri.scheme.startsWith('http')
                          ? NetworkImageBox(
                              url: uri.toString(),
                              height: 140,
                              borderRadius: BorderRadius.circular(AppSpacing.md),
                            )
                          : Text(alt ?? ''),
                      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                        p: text.bodyLarge,
                        listBullet: text.bodyLarge,
                        h1: text.titleMedium,
                        h2: text.titleMedium,
                        h3: text.titleSmall,
                        h4: text.titleSmall,
                        tableBody: text.bodyMedium,
                        tableHead: text.labelMedium,
                        a: text.bodyLarge?.copyWith(
                          color: AppColors.green600,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.green600,
                        ),
                        blockSpacing: AppSpacing.sm,
                      ),
                    ),
                  ),
                  if (time.isNotEmpty || onSpeak != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (time.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.xs),
                            child: Text(time, style: text.bodySmall),
                          ),
                        if (onSpeak != null)
                          IconButton(
                            onPressed: onSpeak,
                            tooltip: speaking ? l10n.chatStopSpeaking : l10n.chatSpeak,
                            color: speaking ? AppColors.red600 : AppColors.green600,
                            icon: Icon(
                              speaking ? Icons.stop_circle_outlined : Icons.volume_up_outlined,
                              size: 22,
                            ),
                          )
                        else
                          const SizedBox(height: AppSpacing.xl),
                      ],
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
