import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';

/// Full-screen photo with pinch-to-zoom (spec §11.19 "tap to view full").
class PostImageViewer extends StatelessWidget {
  const PostImageViewer({super.key, required this.url});

  /// Full-size image URL.
  final String url;

  static Future<void> open(BuildContext context, String url) =>
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => PostImageViewer(url: url)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.ink900,
    appBar: AppBar(
      backgroundColor: AppColors.ink900,
      leading: IconButton(
        tooltip: context.l10n.commonClose,
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.close_rounded),
      ),
    ),
    body: SafeArea(
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: SizedBox.expand(
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
            placeholder: (_, _) =>
                const Center(child: CircularProgressIndicator(color: AppColors.white)),
            errorWidget: (_, _, _) =>
                const Center(child: SizedBox(width: 160, height: 160, child: LeafPlaceholder())),
          ),
        ),
      ),
    ),
  );
}
