import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/widgets/widgets.dart';
import 'controllers/feed_controller.dart';
import 'widgets/post_feed_list.dart';

/// The signed-in user's own posts (spec §11.22).
class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.communityMyPosts,
      body: PostFeedList(
        kind: FeedKind.mine,
        emptyIcon: Icons.edit_note_rounded,
        emptyTitle: l10n.communityMyPostsEmptyTitle,
        emptyMessage: l10n.communityMyPostsEmptyMessage,
        emptyActionLabel: l10n.communityEmptyAction,
        onEmptyAction: () => context.push(Routes.communityNew),
      ),
    );
  }
}
