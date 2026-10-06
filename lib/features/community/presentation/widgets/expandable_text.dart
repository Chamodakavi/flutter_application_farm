import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Text cut to [collapsedLines] with a "See more" / "See less" toggle when it
/// is longer than that.
class ExpandableText extends StatefulWidget {
  const ExpandableText(this.text, {super.key, this.style, this.collapsedLines = 5});

  final String text;
  final TextStyle? style;
  final int collapsedLines;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style.merge(widget.style);
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: widget.collapsedLines,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          locale: Localizations.maybeLocaleOf(context),
        )..layout(maxWidth: constraints.maxWidth);
        final tooLong = painter.didExceedMaxLines;
        painter.dispose();

        final body = Text(
          widget.text,
          style: style,
          maxLines: _expanded ? null : widget.collapsedLines,
          overflow: _expanded ? TextOverflow.clip : TextOverflow.ellipsis,
        );
        if (!tooLong) return body;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            body,
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.green600,
                padding: EdgeInsets.zero,
                minimumSize: const Size(AppSpacing.minTap, AppSpacing.minTap),
                alignment: AlignmentDirectional.centerStart,
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
              child: Text(
                _expanded ? context.l10n.communitySeeLess : context.l10n.communitySeeMore,
              ),
            ),
          ],
        );
      },
    );
  }
}
