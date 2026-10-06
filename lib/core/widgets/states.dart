import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n_ext.dart';
import '../network/connectivity_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'buttons.dart';

/// Illustration + message + optional CTA for lists with nothing to show.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon = Icons.eco_outlined,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Smaller variant for use inside cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final size = compact ? 56.0 : 88.0;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(color: AppColors.green100, shape: BoxShape.circle),
              child: Icon(icon, size: size * 0.5, color: AppColors.green600),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: text.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                style: text.bodyMedium?.copyWith(color: AppColors.ink500),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: actionLabel!, onPressed: onAction, expand: false),
            ],
          ],
        ),
      ),
    );
  }
}

/// Localized failure message with a Retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.error, this.message, this.onRetry, this.compact = false});

  /// Anything thrown by a repository; mapped to localized text.
  final Object? error;

  /// Overrides the text derived from [error].
  final String? message;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final body = message ?? (error != null ? context.errorMessage(error!) : context.l10n.errorUnknown);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: compact ? 32 : 48,
              color: AppColors.ink500,
            ),
            const SizedBox(height: AppSpacing.md),
            if (!compact) ...[
              Text(context.l10n.errorTitle, style: text.titleMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
            ],
            Text(
              body,
              style: text.bodyMedium?.copyWith(color: AppColors.ink500),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(context.l10n.commonRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Thin amber strip shown while the device is offline.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(isOnlineProvider)) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: AppColors.amber200,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 18, color: AppColors.forest900),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.commonOffline,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.forest900),
            ),
          ),
        ],
      ),
    );
  }
}

/// Wraps a write action: disabled with a tooltip while offline (spec §17.3).
class OnlineOnly extends ConsumerWidget {
  const OnlineOnly({super.key, required this.builder});

  /// [online] is false while the device has no network.
  final Widget Function(BuildContext context, bool online) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(isOnlineProvider);
    final child = builder(context, online);
    return online ? child : Tooltip(message: context.l10n.commonRequiresInternet, child: child);
  }
}
