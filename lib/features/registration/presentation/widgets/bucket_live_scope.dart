import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/bucket_controller.dart';

/// Keeps the national bucket live while its child is on screen (spec §17.1):
/// subscribes to `farmer_registrations` inserts and, because RLS may hide
/// other farmers' rows from realtime, also re-reads `get_bucket_status()`
/// every [interval]. Polling pauses while the tab is hidden, another page
/// covers this one or the app is in the background; the channel and the timer
/// go away on dispose.
class BucketLiveScope extends ConsumerStatefulWidget {
  const BucketLiveScope({
    super.key,
    required this.child,
    this.interval = const Duration(seconds: 60),
  });

  final Widget child;
  final Duration interval;

  @override
  ConsumerState<BucketLiveScope> createState() => _BucketLiveScopeState();
}

class _BucketLiveScopeState extends ConsumerState<BucketLiveScope> with WidgetsBindingObserver {
  Timer? _timer;
  bool _visible = true;
  bool _resumed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(widget.interval, (_) => _poll());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final resumed = state == AppLifecycleState.resumed;
    // Coming back to the app: catch up straight away.
    if (resumed && !_resumed) {
      _resumed = true;
      _poll();
    }
    _resumed = resumed;
  }

  void _poll() {
    if (!mounted || !_visible || !_resumed) return;
    // Skip a tick while the previous request is still running.
    if (ref.read(bucketStatusProvider).isLoading) return;
    ref.invalidate(bucketStatusProvider);
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A hidden bottom-navigation branch has its tickers disabled; a covered
    // page is no longer the current route.
    _visible =
        TickerMode.valuesOf(context).enabled && (ModalRoute.of(context)?.isCurrent ?? true);
    ref.watch(bucketRealtimeProvider);
    return widget.child;
  }
}
