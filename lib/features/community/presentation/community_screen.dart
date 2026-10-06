import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import 'controllers/feed_controller.dart';
import 'widgets/post_composer_bar.dart';
import 'widgets/post_feed_list.dart';

/// Community feed — bottom-navigation tab 4 (spec §11.19).
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      appBar: const FarmAppBar(),
      body: PostFeedList(
        kind: FeedKind.all,
        bottomPadding: kFabClearance,
        header: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            PostComposerBar(),
            SizedBox(height: AppSpacing.md),
            _FeedShortcuts(),
          ],
        ),
        emptyTitle: l10n.communityEmptyTitle,
        emptyMessage: l10n.communityEmptyMessage,
        emptyActionLabel: l10n.communityEmptyAction,
        onEmptyAction: () => context.push(Routes.communityNew),
      ),
    );
  }
}

/// "My Posts (n)" and "Saved Posts (n)" — the web's side cards as chips.
class _FeedShortcuts extends ConsumerWidget {
  const _FeedShortcuts();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mine = ref.watch(myPostsCountProvider).value;
    final saved = ref.watch(savedPostsCountProvider).value;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        ActionChip(
          avatar: const Icon(Icons.person_outline_rounded, size: 18, color: AppColors.green600),
          label: Text(mine == null ? l10n.communityMyPosts : l10n.communityMyPostsCount('$mine')),
          onPressed: () => context.push(Routes.communityMine),
        ),
        ActionChip(
          avatar: const Icon(Icons.bookmark_border_rounded, size: 18, color: AppColors.green600),
          label: Text(
            saved == null ? l10n.communitySavedPosts : l10n.communitySavedPostsCount('$saved'),
          ),
          onPressed: () => context.push(Routes.communitySaved),
        ),
      ],
    );
  }
}
