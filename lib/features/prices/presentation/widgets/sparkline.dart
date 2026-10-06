import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Tiny line chart without axes — the six-month forecast on a price row.
/// Green when the line ends higher than it starts, red when lower.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    this.width = 64,
    this.height = 28,
    this.color,
  });

  final List<double> values;
  final double width;
  final double height;

  /// Defaults to the trend colour.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) return SizedBox(width: width, height: height);
    final trend = values.last - values.first;
    final resolved =
        color ??
        (trend > 0 ? AppColors.green600 : (trend < 0 ? AppColors.red600 : AppColors.ink500));
    return ExcludeSemantics(
      child: CustomPaint(size: Size(width, height), painter: _SparklinePainter(values, resolved)),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.values, this.color);

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 3.0;
    var min = values.first, max = values.first;
    for (final v in values) {
      if (v < min) min = v;
      if (v > max) max = v;
    }
    final range = max - min;
    final stepX = (size.width - inset * 2) / (values.length - 1);
    Offset point(int i) {
      final t = range == 0 ? 0.5 : (values[i] - min) / range;
      return Offset(inset + stepX * i, size.height - inset - t * (size.height - inset * 2));
    }

    final path = Path()..moveTo(point(0).dx, point(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(point(i).dx, point(i).dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
    canvas.drawCircle(point(values.length - 1), 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => old.color != color || old.values != values;
}
