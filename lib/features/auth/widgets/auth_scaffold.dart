import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Shared layout of the auth screens: a curved forest header with the logo
/// and a title, the language switcher top-right, and a white form card that
/// scrolls above the keyboard (spec §11.4).
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.showBack = false,
    this.footer,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool showBack;

  /// Shown under the card ("New here? Create account").
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.cream50,
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.forest900,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.sm,
                          AppSpacing.xs,
                          AppSpacing.sm,
                          AppSpacing.xxxl + AppSpacing.xxl,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (showBack)
                                  const BackButton(color: AppColors.white)
                                else
                                  const SizedBox(width: AppSpacing.minTap),
                                const Spacer(),
                                const LanguageSwitcherButton(),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            const AppLogo(size: 40),
                            const SizedBox(height: AppSpacing.lg),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: text.titleLarge?.copyWith(color: AppColors.white),
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                                child: Text(
                                  subtitle!,
                                  textAlign: TextAlign.center,
                                  style: text.bodyMedium?.copyWith(color: Colors.white70),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  // The card overlaps the header's curve.
                  Transform.translate(
                    offset: const Offset(0, -AppSpacing.xxxl),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: AppRadii.heroBorder,
                              border: Border.all(color: AppColors.line200),
                              boxShadow: kCardShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: children,
                            ),
                          ),
                          if (footer != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            footer!,
                          ],
                          SizedBox(height: MediaQuery.paddingOf(context).bottom + AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "or" with a line on each side.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    child: Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        const Expanded(child: Divider()),
      ],
    ),
  );
}

/// "Question? Action" line under the form card.
class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(question, style: Theme.of(context).textTheme.bodyMedium),
      TextButton(onPressed: onTap, child: Text(action)),
    ],
  );
}
