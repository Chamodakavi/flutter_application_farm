import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/env.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/news.dart';
import 'controllers/news_controller.dart';
import 'widgets/news_type_chip.dart';

/// News article (spec §11.18): hero image, type, title, author, date,
/// selectable text and Share. Loads by id, so shared links open it directly.
class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key, required this.newsId});

  final int newsId;

  /// Title plus the web link, which also opens the app (spec §9.3).
  static String shareText(News news) =>
      '${news.title.trim()}\n${Env.webAppUrl}/news/${news.id}'.trim();

  Future<void> _share(BuildContext context, News news) async {
    try {
      await SharePlus.instance.share(ShareParams(text: shareText(news)));
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final article = ref.watch(newsByIdProvider(newsId));
    final loaded = article.value;

    return AppScaffold(
      title: l10n.newsDetailTitle,
      // A plain white page reads better than a card for a long article.
      backgroundColor: AppColors.white,
      actions: [
        if (loaded != null)
          IconButton(
            tooltip: l10n.newsShare,
            onPressed: () => _share(context, loaded),
            icon: const Icon(Icons.share_outlined),
          ),
      ],
      body: AsyncValueView<News>(
        value: article,
        onRetry: () => ref.invalidate(newsByIdProvider(newsId)),
        data: (news) => _Article(news: news, onShare: () => _share(context, news)),
      ),
    );
  }
}

class _Article extends StatelessWidget {
  const _Article({required this.news, required this.onShare});

  final News news;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final author = news.author?.trim() ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (news.hasImage) NetworkImageBox(url: news.image, aspectRatio: 16 / 9),
          Padding(
            padding: AppSpacing.page,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewsTypeChip(news.type),
                const SizedBox(height: AppSpacing.md),
                Text(news.title, style: text.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.lg,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (author.isNotEmpty)
                      _Meta(icon: Icons.person_outline_rounded, label: l10n.newsByAuthor(author)),
                    if (news.createdAt != null)
                      _Meta(
                        icon: Icons.calendar_today_outlined,
                        label: Fmt.date(news.createdAt, context.localeTag),
                      ),
                  ],
                ),
                const Divider(height: AppSpacing.xxxl),
                SelectableText(news.description.trim(), style: text.bodyLarge),
                const SizedBox(height: AppSpacing.xxl),
                SecondaryButton(
                  label: l10n.newsShare,
                  icon: Icons.share_outlined,
                  onPressed: onShare,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small icon + text pair under the title.
class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: AppColors.ink500),
      const SizedBox(width: AppSpacing.xs),
      Flexible(child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
    ],
  );
}
