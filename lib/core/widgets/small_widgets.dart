import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/crop_labels.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../utils/formatters.dart';

enum PriceStyle { rs, rsWhole, lkr, perKg }

/// `Rs. 1,130.00` / `LKR 1,130` / `Rs. 245/kg` depending on context.
class PriceText extends StatelessWidget {
  const PriceText(this.value, {super.key, this.format = PriceStyle.rs, this.style});

  final num? value;
  final PriceStyle format;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Text(
    switch (format) {
      PriceStyle.rs => Fmt.rs(value),
      PriceStyle.rsWhole => Fmt.rsWhole(value),
      PriceStyle.lkr => Fmt.lkr(value),
      PriceStyle.perKg => Fmt.perKg(value),
    },
    style: style ?? Theme.of(context).textTheme.titleMedium,
  );
}

/// − / quantity / + with min and max.
class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 999,
    this.compact = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final side = compact ? 36.0 : AppSpacing.minTap;
    Widget button(IconData icon, bool enabled, VoidCallback onTap) => SizedBox(
      width: side,
      height: side,
      child: IconButton(
        onPressed: enabled ? onTap : null,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(minimumSize: Size(side, side)),
        icon: Icon(icon, size: 20),
        color: AppColors.forest900,
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.pillBorder,
        border: Border.all(color: AppColors.line200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(Icons.remove_rounded, value > min, () => onChanged(value - 1)),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 28),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          button(Icons.add_rounded, value < max, () => onChanged(value + 1)),
        ],
      ),
    );
  }
}

/// Cream box with the leaf mark — shown while images load or when they fail.
class LeafPlaceholder extends StatelessWidget {
  const LeafPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: AppColors.cream50,
    child: Center(child: Icon(Icons.eco_rounded, color: AppColors.green600, size: 32)),
  );
}

/// Cached network image with the leaf placeholder and error fallback.
class NetworkImageBox extends StatelessWidget {
  const NetworkImageBox({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.aspectRatio,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackUrl,
  });

  final String? url;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  /// Tried when [url] fails — e.g. the full image when a thumbnail is missing.
  final String? fallbackUrl;

  @override
  Widget build(BuildContext context) {
    final has = url != null && url!.trim().isNotEmpty;
    Widget image = !has
        ? const LeafPlaceholder()
        : LayoutBuilder(
            builder: (context, constraints) {
              final dpr = MediaQuery.devicePixelRatioOf(context);
              final w = constraints.maxWidth.isFinite ? constraints.maxWidth : (width ?? 400);
              return CachedNetworkImage(
                imageUrl: url!,
                fit: fit,
                width: width,
                height: height,
                memCacheWidth: (w * dpr).round().clamp(64, 1600),
                fadeInDuration: const Duration(milliseconds: 150),
                placeholder: (_, _) => const LeafPlaceholder(),
                errorWidget: (_, _, _) => fallbackUrl != null && fallbackUrl != url
                    ? NetworkImageBox(url: fallbackUrl, width: width, height: height, fit: fit)
                    : const LeafPlaceholder(),
              );
            },
          );
    if (aspectRatio != null) image = AspectRatio(aspectRatio: aspectRatio!, child: image);
    if (width != null || height != null) {
      image = SizedBox(width: width, height: height, child: image);
    }
    return borderRadius == null ? image : ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

/// Profile picture, or the first letter of the name on a green circle.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({super.key, this.url, this.name, this.radius = 20});

  final String? url;
  final String? name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final trimmed = name?.trim() ?? '';
    final initial = trimmed.isEmpty ? '?' : trimmed.substring(0, 1).toUpperCase();
    final letter = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.green100,
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.forest900,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.85,
          height: 1.1,
        ),
      ),
    );
    if (url == null || url!.trim().isEmpty) return letter;
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        memCacheWidth: (radius * 2 * MediaQuery.devicePixelRatioOf(context)).round(),
        placeholder: (_, _) => letter,
        errorWidget: (_, _, _) => letter,
      ),
    );
  }
}

/// Crop emoji on a tinted circle — the per-crop icon in lists and pickers.
class CropAvatar extends StatelessWidget {
  const CropAvatar(this.cropName, {super.key, this.size = 44});

  /// Database crop key (`CARROT`).
  final String cropName;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: const BoxDecoration(color: AppColors.green100, shape: BoxShape.circle),
    child: Text(
      CropLabels.emoji(cropName),
      style: TextStyle(fontSize: size * 0.5, height: 1.1),
    ),
  );
}

/// White leaf mark with an optional "FarmFriend" wordmark.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 28, this.showName = true, this.color = AppColors.white});

  final double size;
  final bool showName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final mark = SvgPicture.asset(
      color == AppColors.white ? 'assets/images/logo.svg' : 'assets/images/leaf_mark.svg',
      width: size,
      height: size,
    );
    if (!showName) return mark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: AppSpacing.sm),
        // The wordmark is part of the logo: it keeps its size regardless of
        // the system text scale and shrinks rather than overflow.
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'FarmFriend',
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: size * 0.68,
                fontWeight: FontWeight.w700,
                color: color == AppColors.white ? AppColors.white : AppColors.forest900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
