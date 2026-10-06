import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/comment.dart';

/// One comment: avatar, author, text and time. The author's own comments can
/// be deleted with a long press (spec §11.21).
class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    this.pending = false,
    this.fallbackName,
    this.fallbackAvatar,
    this.onLongPress,
  });

  final Comment comment;

  /// Still being sent: shown dimmed with "Sending…".
  final bool pending;

  /// Used when the row carries no author — the signed-in user's own name for
  /// their comments; other authors show as a generic "Farmer".
  final String? fallbackName;
  final String? fallbackAvatar;

  /// Set for the user's own comments only.
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final given = comment.authorName?.trim() ?? '';
    final fallback = fallbackName?.trim() ?? '';
    final name = given.isNotEmpty
        ? given
        : fallback.isNotEmpty
        ? fallback
        : l10n.communityFarmer;

    final bubble = Material(
      color: AppColors.white,
      borderRadius: AppRadii.inputBorder,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name, style: text.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(comment.content, style: text.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                pending ? l10n.postCommentSending : context.relativeTime(comment.createdAt),
                style: text.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );

    return Opacity(
      opacity: pending ? 0.6 : 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: AvatarCircle(
              url: comment.authorAvatar ?? fallbackAvatar,
              name: name,
              radius: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: onLongPress == null
                ? bubble
                : Semantics(onLongPressHint: l10n.postCommentHoldToDelete, child: bubble),
          ),
        ],
      ),
    );
  }
}
