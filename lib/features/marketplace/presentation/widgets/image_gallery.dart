import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

/// Product image carousel with page dots (spec §11.14). Tapping an image
/// opens it full screen, where it can be pinched to zoom.
class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key, required this.images, this.aspectRatio = 4 / 3});

  final List<String> images;
  final double aspectRatio;

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final _pages = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _openViewer(int index) {
    showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (_) => _ZoomViewer(images: widget.images, initialIndex: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: AppRadii.cardBorder,
        child: AspectRatio(aspectRatio: widget.aspectRatio, child: const LeafPlaceholder()),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: AppRadii.cardBorder,
          child: AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: _pages,
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => _openViewer(i),
                    // Detail screens load the image at full display size (§13.9).
                    child: NetworkImageBox(url: images[i]),
                  ),
                ),
                Positioned(
                  right: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.forest900.withValues(alpha: 0.55),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.zoom_in_rounded, size: 20, color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          _Dots(count: images.length, index: _index),
        ],
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index, this.light = false});

  final int count;
  final int index;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final active = light ? AppColors.white : AppColors.green600;
    final idle = (light ? AppColors.white : AppColors.ink500).withValues(alpha: 0.35);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == index ? 18 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index ? active : idle,
              borderRadius: AppRadii.pillBorder,
            ),
          ),
      ],
    );
  }
}

/// Full-screen viewer: swipe between images, pinch or double-tap to zoom.
class _ZoomViewer extends StatefulWidget {
  const _ZoomViewer({required this.images, required this.initialIndex});

  final List<String> images;
  final int initialIndex;

  @override
  State<_ZoomViewer> createState() => _ZoomViewerState();
}

class _ZoomViewerState extends State<_ZoomViewer> {
  late final _pages = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;
  bool _zoomed = false;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: AppColors.ink900,
      child: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pages,
              // While zoomed in, dragging pans the image instead of paging.
              physics: _zoomed ? const NeverScrollableScrollPhysics() : null,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => _ZoomPage(
                url: widget.images[i],
                onZoomChanged: (zoomed) {
                  if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
                },
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: IconButton(
                tooltip: context.l10n.commonClose,
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.forest900.withValues(alpha: 0.6),
                ),
                icon: const Icon(Icons.close_rounded, color: AppColors.white),
              ),
            ),
            if (widget.images.length > 1)
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: IgnorePointer(
                  child: _Dots(count: widget.images.length, index: _index, light: true),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ZoomPage extends StatefulWidget {
  const _ZoomPage({required this.url, required this.onZoomChanged});

  final String url;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_ZoomPage> createState() => _ZoomPageState();
}

class _ZoomPageState extends State<_ZoomPage> {
  final _transform = TransformationController();

  static const _doubleTapScale = 2.5;

  bool get _zoomed => _transform.value.getMaxScaleOnAxis() > 1.01;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _toggleZoom(TapDownDetails details) {
    if (_zoomed) {
      _transform.value = Matrix4.identity();
    } else {
      // Zoom towards the point that was tapped.
      final p = details.localPosition;
      _transform.value = Matrix4.identity()
        ..translateByDouble(-p.dx * (_doubleTapScale - 1), -p.dy * (_doubleTapScale - 1), 0, 1)
        ..scaleByDouble(_doubleTapScale, _doubleTapScale, 1, 1);
    }
    widget.onZoomChanged(_zoomed);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onDoubleTapDown: _toggleZoom,
    onDoubleTap: () {},
    child: InteractiveViewer(
      transformationController: _transform,
      minScale: 1,
      maxScale: 4,
      onInteractionEnd: (_) => widget.onZoomChanged(_zoomed),
      child: Center(
        // Full-size image: no memory-cache downscaling here (spec §13.9).
        child: CachedNetworkImage(
          imageUrl: widget.url,
          fit: BoxFit.contain,
          placeholder: (_, _) => const Center(
            child: CircularProgressIndicator(color: AppColors.white),
          ),
          errorWidget: (_, _, _) => const SizedBox.square(dimension: 160, child: LeafPlaceholder()),
        ),
      ),
    ),
  );
}
