import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

/// Shared body for the three full-width buttons: label that may wrap to two
/// lines (Sinhala/Tamil are longer), optional leading icon, loading spinner.
class _ButtonContent extends StatelessWidget {
  const _ButtonContent({required this.label, this.icon, required this.loading, this.color});

  final String label;
  final IconData? icon;
  final bool loading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: color ?? AppColors.white),
      );
    }
    final text = Text(label, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis);
    if (icon == null) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: text),
      ],
    );
  }
}

/// Green, full-width call to action ("Check & Register", "Send Message").
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: loading ? null : onPressed,
      style: loading
          ? FilledButton.styleFrom(disabledBackgroundColor: AppColors.green600)
          : null,
      child: _ButtonContent(label: label, icon: icon, loading: loading),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Outlined alternative for the less important action of a pair.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: loading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonBorder),
      ),
      child: _ButtonContent(
        label: label,
        icon: icon,
        loading: loading,
        color: AppColors.forest900,
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Red button for destructive actions ("Cancel Order", "Delete account").
class DangerButton extends StatelessWidget {
  const DangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final Widget button = outlined
        ? OutlinedButton(
            onPressed: loading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.red600,
              side: const BorderSide(color: AppColors.red600),
              minimumSize: const Size(64, AppSpacing.buttonHeight),
              shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonBorder),
            ),
            child: _ButtonContent(
              label: label,
              icon: icon,
              loading: loading,
              color: AppColors.red600,
            ),
          )
        : FilledButton(
            onPressed: loading ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.red600,
              disabledBackgroundColor: loading ? AppColors.red600 : null,
            ),
            child: _ButtonContent(label: label, icon: icon, loading: loading),
          );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

enum PillStyle { amber, outlinedLight, outlinedDark, green }

/// Compact pill-shaped CTA ("Register Crop" on the hero, "Read More").
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.style = PillStyle.amber,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PillStyle style;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, BorderSide side) = switch (style) {
      PillStyle.amber => (AppColors.amber200, AppColors.forest900, BorderSide.none),
      PillStyle.green => (AppColors.green600, AppColors.white, BorderSide.none),
      PillStyle.outlinedLight => (
        Colors.transparent,
        AppColors.white,
        const BorderSide(color: Colors.white70),
      ),
      PillStyle.outlinedDark => (
        Colors.transparent,
        AppColors.forest900,
        const BorderSide(color: AppColors.forest900),
      ),
    };
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        minimumSize: const Size(AppSpacing.minTap, AppSpacing.minTap),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        shape: StadiumBorder(side: side),
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 6)],
          Flexible(
            child: Text(label, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
