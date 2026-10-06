import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

/// Sticky comment box at the bottom of Post Detail (spec §11.21).
class CommentInput extends StatefulWidget {
  const CommentInput({
    super.key,
    required this.onSend,
    this.autofocus = false,
    this.enabled = true,
  });

  /// Sends the comment; resolves to false when it failed, and the text is
  /// put back so nothing the user typed is lost.
  final Future<bool> Function(String text) onSend;

  /// Opens the keyboard at once (the "Comment" action of a post).
  final bool autofocus;

  /// False until the comments have loaded.
  final bool enabled;

  static const maxLength = 1000;

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    final sent = await widget.onSend(text);
    if (!sent && mounted && _controller.text.isEmpty) _controller.text = text;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasText = _controller.text.trim().isNotEmpty;
    return Material(
      color: AppColors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: widget.autofocus,
                  enabled: widget.enabled,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: CommentInput.maxLength,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: l10n.postCommentHint,
                    counterText: '',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              OnlineOnly(
                builder: (context, online) => IconButton.filled(
                  tooltip: l10n.postCommentSend,
                  onPressed: online && widget.enabled && hasText ? _send : null,
                  icon: const Icon(Icons.send_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
