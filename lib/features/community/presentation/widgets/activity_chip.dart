import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/post_activity.dart';

/// Localized name of an activity tag (the stored text stays English).
String activityLabel(AppLocalizations l10n, PostActivity activity) => switch (activity) {
  PostActivity.planting => l10n.communityActivityPlanting,
  PostActivity.harvesting => l10n.communityActivityHarvesting,
  PostActivity.selling => l10n.communityActivitySelling,
  PostActivity.question => l10n.communityActivityQuestion,
};

/// "🌱 Planting" pill shown above a post's text.
class ActivityChip extends StatelessWidget {
  const ActivityChip(this.activity, {super.key});

  final PostActivity activity;

  @override
  Widget build(BuildContext context) =>
      TagChip('${activity.emoji} ${activityLabel(context.l10n, activity)}');
}
