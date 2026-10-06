import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';

/// Composer card at the top of the feed (spec §11.19): avatar, "What's on
/// your mind?" and Photo · Activity · Post. On mobile every part opens the
/// Create Post screen, where the text, photo and activity are chosen.
class PostComposerBar extends ConsumerWidget {
  const PostComposerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final profile = ref.watch(profileProvider).value;
    final name = profile?.displayName.isNotEmpty == true ? profile!.displayName : profile?.email;
    void compose() => context.push(Routes.communityNew);

    return SectionCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AvatarCircle(url: profile?.avatarUrl, name: name),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Material(
                  color: AppColors.fieldFill,
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: compose,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: AppSpacing.minTap),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            l10n.communityWhatsOnMind,
                            style: text.bodyMedium?.copyWith(color: AppColors.ink500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.xs),
          // Wraps onto a second line with long Sinhala / Tamil labels.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm,
            children: [
              _ComposerAction(
                icon: Icons.photo_camera_outlined,
                label: l10n.communityPhoto,
                onTap: compose,
              ),
              _ComposerAction(
                icon: Icons.emoji_nature_outlined,
                label: l10n.communityActivity,
                onTap: compose,
              ),
              PillButton(
                label: l10n.communityPost,
                icon: Icons.send_rounded,
                style: PillStyle.green,
                onPressed: compose,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComposerAction extends StatelessWidget {
  const _ComposerAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: onTap,
    style: TextButton.styleFrom(
      foregroundColor: AppColors.forest900,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      textStyle: Theme.of(context).textTheme.labelMedium,
    ),
    icon: Icon(icon, size: 20, color: AppColors.green600),
    label: Text(label),
  );
}
