import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config_provider.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
import 'controllers/auth_controller.dart';

/// First screen (spec §11.1). Supabase, Hive and the locale are ready before
/// the first frame (see bootstrap), so this only waits for `app_config` (max
/// ~2.5 s) and then lets the router guard pick the destination.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    // Version gate / maintenance: the guard reacts as soon as the config and
    // installed version are known.
    unawaited(ref.read(appVersionProvider.future));
    await Future.any<void>([
      ref.read(appConfigProvider.future).then((_) {}, onError: (_) {}),
      Future<void>.delayed(const Duration(milliseconds: 2500)),
    ]);
    if (!mounted) return;

    final signedIn = ref.read(currentUserIdProvider) != null;
    if (signedIn) return; // The guard moves on once the profile has loaded.
    context.go(ref.read(onboardingDoneProvider) ? Routes.login : Routes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = ref.watch(profileProvider);
    final failed = profile.hasError && !profile.isLoading;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.forest900,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(size: 72, showName: false),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.appName,
                  style: text.displaySmall?.copyWith(color: AppColors.white, fontFamily: 'NotoSans'),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                if (!failed) ...[
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.white),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.splashGettingReady,
                    style: text.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ] else ...[
                  Text(
                    l10n.splashProfileError,
                    textAlign: TextAlign.center,
                    style: text.titleMedium?.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.errorMessage(profile.error!),
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: l10n.commonRetry,
                    icon: Icons.refresh_rounded,
                    onPressed: () => ref.invalidate(profileProvider),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () => ref.read(authControllerProvider).signOut(),
                    style: TextButton.styleFrom(foregroundColor: Colors.white70),
                    child: Text(l10n.authSignOut),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
