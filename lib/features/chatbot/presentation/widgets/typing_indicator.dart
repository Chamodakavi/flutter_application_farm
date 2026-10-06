import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import 'chat_bubble.dart';

/// Three bouncing dots in a bot bubble while AgriBot is answering.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.chatTyping,
    liveRegion: true,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const BotAvatar(),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: botBubbleRadius,
            border: Border.all(color: AppColors.line200),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 3; i++)
                  Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 5),
                    child: Transform.translate(
                      offset: Offset(0, -4 * _lift(i)),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.green600.withValues(alpha: 0.4 + 0.6 * _lift(i)),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  /// 0…1 wave for dot [i], each a third of a cycle behind the previous one.
  double _lift(int i) {
    final phase = (_controller.value - i * 0.18) % 1.0;
    return phase < 0.5 ? math.sin(phase * 2 * math.pi) : 0;
  }
}
