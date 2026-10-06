import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/app_config_provider.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Full-screen maintenance notice, shown while `app_config.maintenance_message`
/// is set (spec §11.33). Retry re-reads the config from the server.
class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  bool _checking = false;

  Future<void> _retry() async {
    setState(() => _checking = true);
    // Drop the cached row so the retry really asks the server.
    await ref.read(cacheStoreProvider).remove(HiveBoxes.cacheConfig, 'app_config');
    ref.invalidate(appConfigProvider);
    try {
      await ref.read(appConfigProvider.future);
    } catch (_) {}
    // If maintenance is over, the router guard has already left this screen.
    if (mounted) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final message = ref.watch(appConfigOrDefaultProvider).maintenanceMessage;
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
                      color: AppColors.amber200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.build_circle_outlined,
                      size: 72,
                      color: AppColors.forest900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(l10n.maintenanceTitle, style: text.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    (message == null || message.trim().isEmpty) ? l10n.maintenanceBody : message,
                    style: text.bodyLarge?.copyWith(color: AppColors.ink500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  PrimaryButton(
                    label: l10n.commonRetry,
                    icon: Icons.refresh_rounded,
                    onPressed: _retry,
                    loading: _checking,
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
