import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/news.dart';
import 'news_type_chip.dart';

/// News list item (spec §11.18): image on the left — or full width on top on
/// phones narrower than 380 dp — type pill, date, title, two lines of text
/// and "Read more". Alerts get an amber left border.
class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.news, this.onTap});

  final News news;
  final VoidCallback? onTap;

  /// Below this screen width the image moves above the text.
  static const narrowBreakpoint = 380.0;

  /// On the amber accent of alert items (for tests).
  static const alertAccentKey = Key('news-card-alert-accent');

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final narrow = MediaQuery.sizeOf(context).width < narrowBreakpoint;
    final imageRadius = AppRadii.inputBorder;

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            NewsTypeChip(news.type),
            if (news.createdAt != null)
              Text(Fmt.date(news.createdAt, context.localeTag), style: text.bodySmall),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(news.title, style: text.titleSmall, maxLines: 3, overflow: TextOverflow.ellipsis),
        if (news.description.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            news.description.trim(),
            style: text.bodyMedium?.copyWith(color: AppColors.ink500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                l10n.newsReadMore,
                style: text.labelMedium?.copyWith(color: AppColors.green600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.green600),
          ],
        ),
      ],
    );

    final Widget layout = narrow
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (news.hasImage) ...[
                NetworkImageBox(url: news.image, aspectRatio: 16 / 9, borderRadius: imageRadius),
                const SizedBox(height: AppSpacing.md),
              ],
              details,
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkImageBox(url: news.image, width: 104, height: 104, borderRadius: imageRadius),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: details),
            ],
          );

    Widget content = Padding(padding: const EdgeInsets.all(AppSpacing.md), child: layout);
    if (news.isAlert) {
      // Clipped to the card's rounded corners by the Material below.
      content = DecoratedBox(
        key: alertAccentKey,
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: AppColors.orange500, width: 4)),
        ),
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardBorder,
        border: Border.all(color: AppColors.line200),
        boxShadow: kCardShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: AppRadii.cardBorder,
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: content),
      ),
    );
  }
}
