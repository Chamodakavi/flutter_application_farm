import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shimmers.dart';
import 'states.dart';

/// Renders an [AsyncValue] with the shared loading / error / empty states.
///
/// While a provider reloads, the previous data stays on screen (no flicker);
/// the skeleton and error state only show when there is nothing to display.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.onRetry,
    this.isEmpty,
    this.empty,
    this.compact = false,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  /// Defaults to [ShimmerList] (or a spinner when [compact]).
  final Widget? loading;
  final Widget Function(Object error)? error;
  final VoidCallback? onRetry;

  /// When it returns true, [empty] is shown instead of [data].
  final bool Function(T data)? isEmpty;
  final Widget? empty;

  /// For use inside cards: small spinner and compact error.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (value.hasValue) {
      final v = value.requireValue;
      if (empty != null && (isEmpty?.call(v) ?? _defaultEmpty(v))) return empty!;
      return data(v);
    }
    if (value.hasError) {
      final e = value.error!;
      return error?.call(e) ?? ErrorState(error: e, onRetry: onRetry, compact: compact);
    }
    return loading ??
        (compact
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            : const ShimmerList());
  }

  bool _defaultEmpty(T v) => v is Iterable && v.isEmpty;
}
