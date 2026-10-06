import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/config/env.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/supabase/storage_service.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/post.dart';
import '../../domain/post_activity.dart';
import '../controllers/feed_controller.dart';
import '../controllers/post_controller.dart';
import 'activity_chip.dart';
import 'expandable_text.dart';
import 'post_image_viewer.dart';

enum _PostMenu { edit, delete, report }

/// One post (spec §11.19): author, time, bookmark, text, photo, counters and
/// the Like / Comment / Share row. Renders the post with [postId] from
/// [PostStore], so every card showing the same post stays in step.
class PostCard extends ConsumerWidget {
  const PostCard({
    super.key,
    required this.postId,
    this.detail = false,
    this.margin = EdgeInsets.zero,
    this.onDeleted,
  });

  final int postId;

  /// On the Post Detail screen: full text and full-size photo, and the card
  /// no longer links to the detail screen.
  final bool detail;

  /// Space around the card; not applied when the post is gone.
  final EdgeInsetsGeometry margin;

  /// Called after the user deleted this post.
  final VoidCallback? onDeleted;

  /// Text passed to the share sheet: the start of the post plus the web
  /// link, which also opens the app (spec §9.3).
  static String shareText(Post post) {
    final content = post.content.trim();
    final snippet = content.length > 200 ? '${content.substring(0, 200).trimRight()}…' : content;
    return '$snippet\n${Env.webAppUrl}/community/post/${post.id}'.trim();
  }

  /// Runs an optimistic toggle; the store has already reverted on failure.
  Future<void> _guarded(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final actions = ref.read(postActionsProvider);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.communityDeleteTitle,
      message: l10n.communityDeleteMessage,
      confirmLabel: l10n.commonDelete,
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await actions.delete(postId);
    } catch (e) {
      if (context.mounted) context.showError(e);
      return;
    }
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.communityPostDeleted)));
    onDeleted?.call();
  }

  void _onMenu(BuildContext context, WidgetRef ref, _PostMenu choice) {
    switch (choice) {
      case _PostMenu.edit:
        context.push(Routes.editPost(postId));
      case _PostMenu.delete:
        _delete(context, ref);
      case _PostMenu.report:
        context.push(Routes.supportWith(context.l10n.communityReportSubject('$postId')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postByIdProvider(postId));
    if (post == null) return const SizedBox.shrink();

    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final me = ref.watch(currentUserIdProvider);
    final mine = me != null && post.userId == me;
    final store = ref.read(postStoreProvider.notifier);
    final tagged = ActivityTag.parse(post.content);
    final authorName = post.authorName?.trim() ?? '';
    final author = authorName.isEmpty ? l10n.communityFarmer : authorName;
    void openDetail({bool focusComment = false}) =>
        context.push(Routes.post(post.id, focusComment: focusComment));
    const inset = EdgeInsets.symmetric(horizontal: AppSpacing.lg);

    return Padding(
      padding: margin,
      child: SectionCard(
        padding: const EdgeInsets.only(top: AppSpacing.sm),
        onTap: detail ? null : openDetail,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.xs),
              child: Row(
                children: [
                  AvatarCircle(url: post.authorAvatar, name: author),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          author,
                          style: text.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          context.relativeTime(post.createdAt),
                          style: text.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: post.savedByMe ? l10n.communityUnsave : l10n.communitySave,
                    onPressed: () => _guarded(context, () => store.toggleSave(post.id)),
                    color: post.savedByMe ? AppColors.green600 : AppColors.ink500,
                    icon: Icon(
                      post.savedByMe ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    ),
                  ),
                  PopupMenuButton<_PostMenu>(
                    tooltip: l10n.communityMoreOptions,
                    iconColor: AppColors.ink500,
                    onSelected: (choice) => _onMenu(context, ref, choice),
                    itemBuilder: (_) => [
                      if (mine) ...[
                        _menuItem(_PostMenu.edit, Icons.edit_outlined, l10n.commonEdit),
                        _menuItem(
                          _PostMenu.delete,
                          Icons.delete_outline_rounded,
                          l10n.commonDelete,
                        ),
                      ] else
                        _menuItem(_PostMenu.report, Icons.flag_outlined, l10n.communityReport),
                    ],
                  ),
                ],
              ),
            ),
            if (tagged.activity != null)
              Padding(
                padding: inset.copyWith(top: AppSpacing.sm),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ActivityChip(tagged.activity!),
                ),
              ),
            if (tagged.text.isNotEmpty)
              Padding(
                padding: inset.copyWith(top: AppSpacing.sm),
                child: detail
                    ? SelectableText(tagged.text, style: text.bodyLarge)
                    : ExpandableText(tagged.text, style: text.bodyLarge),
              ),
            if (post.hasImage)
              Padding(
                padding: inset.copyWith(top: AppSpacing.md),
                child: Semantics(
                  button: true,
                  label: l10n.communityViewPhoto,
                  child: GestureDetector(
                    onTap: () => PostImageViewer.open(context, post.image!),
                    child: NetworkImageBox(
                      // Lists load the 400 px thumbnail (spec §13.9); posts
                      // from the web have none, so fall back to the original.
                      url: detail ? post.image : StorageService.thumbUrl(post.image!),
                      fallbackUrl: post.image,
                      aspectRatio: 4 / 3,
                      borderRadius: AppRadii.inputBorder,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: inset.copyWith(top: AppSpacing.md, bottom: AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(Icons.eco_rounded, size: 16, color: AppColors.green600),
                  const SizedBox(width: AppSpacing.xs),
                  Semantics(
                    label: l10n.communityLikesCount(post.likeCount),
                    excludeSemantics: true,
                    child: Text('${post.likeCount}', style: text.bodySmall),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      l10n.communityCommentsCount(post.commentCount),
                      style: text.bodySmall,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: post.likedByMe ? Icons.eco_rounded : Icons.eco_outlined,
                      label: l10n.communityLike,
                      active: post.likedByMe,
                      onTap: () => _guarded(context, () => store.toggleLike(post.id)),
                    ),
                  ),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.mode_comment_outlined,
                      label: l10n.communityComment,
                      onTap: () => openDetail(focusComment: true),
                    ),
                  ),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.share_outlined,
                      label: l10n.communityShare,
                      onTap: () => _guarded(
                        context,
                        () => SharePlus.instance.share(ShareParams(text: shareText(post))),
                      ),
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

  PopupMenuItem<_PostMenu> _menuItem(_PostMenu value, IconData icon, String label) => PopupMenuItem(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: 20, color: AppColors.forest900),
        const SizedBox(width: AppSpacing.md),
        Flexible(child: Text(label)),
      ],
    ),
  );
}

/// Icon + label third of the action row; shrinks rather than overflows with
/// long Sinhala / Tamil labels.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.green600 : AppColors.ink500;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputBorder,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTap),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
