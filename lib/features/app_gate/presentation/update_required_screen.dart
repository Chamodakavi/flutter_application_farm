import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/config/app_config_provider.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Store page for this platform, from `app_config`.
String? storeUrlFor(AppConfig config) => defaultTargetPlatform == TargetPlatform.iOS
    ? config.iosStoreUrl
    : config.androidStoreUrl;

Future<void> openStore(BuildContext context, AppConfig config) async {
  final url = storeUrlFor(config);
  final uri = url == null ? null : Uri.tryParse(url);
  final opened =
      uri != null &&
      await launchUrl(uri, mode: LaunchMode.externalApplication).catchError((_) => false);
  if (!opened && context.mounted) context.showSnack(context.l10n.errorUnknown);
}

/// Blocking screen shown while the installed version is older than
/// `app_config.min_supported_version` (spec §11.33).
class UpdateRequiredScreen extends ConsumerWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final config = ref.watch(appConfigOrDefaultProvider);
    final text = Theme.of(context).textTheme;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.cream50,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: AppColors.green100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.system_update_rounded,
                      size: 72,
                      color: AppColors.green600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(l10n.updateRequiredTitle, style: text.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.updateRequiredBody,
                    style: text.bodyLarge?.copyWith(color: AppColors.ink500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  PrimaryButton(
                    label: l10n.updateButton,
                    icon: Icons.download_rounded,
                    onPressed: () => openStore(context, config),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
