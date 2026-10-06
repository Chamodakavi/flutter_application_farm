import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../utils/app_status.dart';
import '../utils/formatters.dart';

/// Filled vs. limit bar in the surplus level colour, with optional labels.
class QuotaProgressBar extends StatelessWidget {
  const QuotaProgressBar({
    super.key,
    required this.filledMt,
    required this.limitMt,
    this.level,
    this.showLabels = true,
    this.height = 10,
  });

  final double filledMt;
  final double limitMt;

  /// Defaults to the level implied by filled ÷ limit.
  final SurplusLevel? level;
  final bool showLabels;
  final double height;

  double get _ratio => limitMt <= 0 ? 1 : (filledMt / limitMt).clamp(0, 1).toDouble();

  @override
  Widget build(BuildContext context) {
    final lvl = level ?? SurplusLevel.fromRatio(_ratio);
    final text = Theme.of(context).textTheme;
    final remaining = math.max(0.0, limitMt - filledMt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: AppRadii.pillBorder,
          child: LinearProgressIndicator(
            value: _ratio,
            minHeight: height,
            color: lvl.color,
            backgroundColor: AppColors.line200,
          ),
        ),
        if (showLabels) ...[
          const SizedBox(height: AppSpacing.xs),
          // A Wrap, not a Row: long translations and large text move the
          // "remaining" label to its own line instead of overflowing.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSpacing.sm,
            children: [
              Text(
                context.l10n.quotaFilledOfLimit(Fmt.amount(filledMt), Fmt.amount(limitMt)),
                style: text.bodySmall,
              ),
              Text(
                context.l10n.quotaRemaining(Fmt.amount(remaining)),
                style: text.bodySmall?.copyWith(color: lvl.color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Semi-circle gauge for the crop detail screen and the surplus warning.
class QuotaGauge extends StatelessWidget {
  const QuotaGauge({
    super.key,
    required this.ratio,
    this.level,
    this.size = 200,
    this.centerLabel,
    this.caption,
  });

  /// 0–1 fill ratio.
  final double ratio;
  final SurplusLevel? level;
  final double size;

  /// Defaults to the fill percentage.
  final String? centerLabel;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final r = ratio.clamp(0, 1).toDouble();
    final lvl = level ?? SurplusLevel.fromRatio(r);
    final text = Theme.of(context).textTheme;
    return SizedBox(
      width: size,
      height: size / 2 + 12,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: r),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) => CustomPaint(
          painter: _GaugePainter(value, lvl.color),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  centerLabel ?? '${(r * 100).round()}%',
                  style: text.displaySmall?.copyWith(color: lvl.color),
                ),
                if (caption != null) Text(caption!, style: text.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter(this.ratio, this.color);

  final double ratio;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 16.0;
    final radius = size.width / 2 - stroke / 2;
    final rect = Rect.fromCircle(center: Offset(size.width / 2, size.width / 2), radius: radius);
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = AppColors.line200;
    canvas.drawArc(rect, math.pi, math.pi, false, track);
    if (ratio > 0) {
      canvas.drawArc(rect, math.pi, math.pi * ratio, false, track..color = color);
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.ratio != ratio || old.color != color;
}
