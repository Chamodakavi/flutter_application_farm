import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../analytics/analytics_service.dart';
import '../cache/hive_boxes.dart';
import '../l10n/l10n_ext.dart';
import '../supabase/supabase_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'buttons.dart';
import 'dialogs.dart';

/// Where the feedback sheet was triggered from (stored in `app_feedback.context`).
abstract final class FeedbackContexts {
  static const firstRegistration = 'first_registration';
  static const firstOrder = 'first_order';
  static const fifthChat = 'fifth_chat';
  static const settings = 'settings';
}

/// Three rating rows (overall, ease of use, usefulness) and an optional
/// comment, saved to `app_feedback` (spec §18.4).
class FeedbackSheet extends ConsumerStatefulWidget {
  const FeedbackSheet({super.key, required this.contextKey});

  final String contextKey;

  /// Always shows the sheet (Settings → "Give feedback").
  static Future<void> show(BuildContext context, {String contextKey = FeedbackContexts.settings}) =>
      showAppBottomSheet<void>(
        context,
        title: context.l10n.feedbackTitle,
        builder: (_) => FeedbackSheet(contextKey: contextKey),
      );

  /// Shows the sheet at most once per [contextKey] per user — after the first
  /// successful registration, the first order and the fifth chat message.
  static Future<void> maybeShowOnce(
    BuildContext context,
    WidgetRef ref, {
    required String contextKey,
  }) async {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null || !Hive.isBoxOpen(HiveBoxes.prefs)) return;
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    final key = PrefKeys.feedbackShown(uid, contextKey);
    if (prefs.get(key) == true) return;
    await prefs.put(key, true);
    if (context.mounted) await show(context, contextKey: contextKey);
  }

  @override
  ConsumerState<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends ConsumerState<FeedbackSheet> {
  int _overall = 0;
  int _ease = 0;
  int _useful = 0;
  final _comment = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  bool get _valid => _overall > 0 && _ease > 0 && _useful > 0;

  Future<void> _submit() async {
    setState(() => _sending = true);
    final l10n = context.l10n;
    try {
      await ref.read(feedbackRepositoryProvider).submit(
        context: widget.contextKey,
        rating: _overall,
        easeRating: _ease,
        usefulnessRating: _useful,
        comment: _comment.text,
        locale: context.localeTag,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      context.showSnack(l10n.feedbackThanks);
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.feedbackSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink500),
          ),
          const SizedBox(height: AppSpacing.lg),
          _RatingRow(
            label: l10n.feedbackOverall,
            value: _overall,
            onChanged: (v) => setState(() => _overall = v),
          ),
          _RatingRow(
            label: l10n.feedbackEase,
            value: _ease,
            onChanged: (v) => setState(() => _ease = v),
          ),
          _RatingRow(
            label: l10n.feedbackUsefulness,
            value: _useful,
            onChanged: (v) => setState(() => _useful = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _comment,
            maxLines: 3,
            maxLength: 500,
            decoration: InputDecoration(hintText: l10n.feedbackComment),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: l10n.feedbackSubmit,
            onPressed: _valid ? _submit : null,
            loading: _sending,
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.label, required this.value, required this.onChanged});

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        Row(
          children: [
            for (var i = 1; i <= 5; i++)
              IconButton(
                onPressed: () => onChanged(i),
                tooltip: '$i',
                icon: Icon(
                  i <= value ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i <= value ? AppColors.orange500 : AppColors.ink500,
                  size: 32,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
