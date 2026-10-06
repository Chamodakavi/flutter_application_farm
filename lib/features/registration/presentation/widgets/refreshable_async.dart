import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

/// A pull-to-refresh list driven by an [AsyncValue]: shimmer while loading,
/// [ErrorState] with Retry, an empty state, else the widgets from [builder].
/// Every state stays scrollable so the refresh gesture always works. While a
/// refresh runs, the previous data stays on screen.
class RefreshableAsync<T> extends StatelessWidget {
  const RefreshableAsync({
    super.key,
    required this.value,
    required this.onRefresh,
    required this.builder,
    this.header = const [],
    this.isEmpty,
    this.empty,
    this.padding = AppSpacing.page,
    this.controller,
  });

  final AsyncValue<T> value;
  final Future<void> Function() onRefresh;
  final List<Widget> Function(T data) builder;

  /// Shown above every state (search field, filter chips).
  final List<Widget> header;
  final bool Function(T data)? isEmpty;
  final Widget? empty;
  final EdgeInsetsGeometry padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final List<Widget> body;
    if (value.hasValue) {
      final data = value.requireValue;
      body = (empty != null && (isEmpty?.call(data) ?? false)) ? [empty!] : builder(data);
    } else if (value.hasError) {
      body = [ErrorState(error: value.error, onRetry: onRefresh)];
    } else {
      body = const [ShimmerList(shrinkWrap: true, padding: EdgeInsets.zero)];
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: padding,
        children: [...header, ...body],
      ),
    );
  }
}
