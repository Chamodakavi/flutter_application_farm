import 'package:flutter/material.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/widgets/widgets.dart';
import 'controllers/feed_controller.dart';
import 'widgets/post_feed_list.dart';

/// Posts the signed-in user bookmarked (spec §11.22).
class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.communitySavedPosts,
      body: PostFeedList(
        kind: FeedKind.saved,
        emptyIcon: Icons.bookmark_border_rounded,
        emptyTitle: l10n.communitySavedEmptyTitle,
        emptyMessage: l10n.communitySavedEmptyMessage,
      ),
    );
  }
}
