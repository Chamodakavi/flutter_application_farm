import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'buttons.dart';

/// Localized confirm / cancel dialog. Resolves to true only on confirm.
abstract final class ConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    String? message,
    String? confirmLabel,
    String? cancelLabel,
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(foregroundColor: AppColors.ink500),
            child: Text(cancelLabel ?? ctx.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: destructive ? AppColors.red600 : AppColors.green600,
            ),
            child: Text(confirmLabel ?? ctx.l10n.commonConfirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

/// Rounded bottom sheet with a drag handle and optional title. The content
/// scrolls and stays above the keyboard.
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  String? title,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool expand = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    useSafeArea: true,
    builder: (ctx) => AppBottomSheet(title: title, expand: expand, child: builder(ctx)),
  );
}

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({super.key, this.title, required this.child, this.expand = false});

  final String? title;
  final Widget child;

  /// Takes most of the screen height (for long lists such as pickers).
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.md),
            child: Text(title!, style: Theme.of(context).textTheme.titleMedium),
          ),
        Flexible(child: child),
      ],
    );
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.9),
        child: expand ? SizedBox(height: media.size.height * 0.85, child: body) : body,
      ),
    );
  }
}

/// Success confirmation: animated check, title, message and actions.
abstract final class SuccessSheet {
  static Future<void> show(
    BuildContext context, {
    required String title,
    String? message,
    String? primaryLabel,
    VoidCallback? onPrimary,
    String? secondaryLabel,
    VoidCallback? onSecondary,
  }) {
    return showAppBottomSheet<void>(
      context,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _AnimatedCheck(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: Theme.of(ctx).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: AppColors.ink500),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            if (primaryLabel != null)
              PrimaryButton(
                label: primaryLabel,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onPrimary?.call();
                },
              ),
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              label: secondaryLabel ?? ctx.l10n.commonDone,
              onPressed: () {
                Navigator.of(ctx).pop();
                onSecondary?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCheck extends StatelessWidget {
  const _AnimatedCheck();

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 450),
    curve: Curves.elasticOut,
    builder: (_, t, child) => Transform.scale(scale: t, child: child),
    child: Container(
      width: 84,
      height: 84,
      decoration: const BoxDecoration(color: AppColors.green100, shape: BoxShape.circle),
      child: const Icon(Icons.check_rounded, size: 48, color: AppColors.green600),
    ),
  );
}
