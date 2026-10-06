import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';

// The cart, success and orders screens can be the only page on the stack:
// checkout ends with `context.go` to the success screen, and a tapped
// notification can land on My Orders. From there "back" must lead to Home
// instead of closing the app or leaving the user without a way out.

/// App bar with a back arrow to Home when there is nothing to pop; null when
/// the standard bar (with its own back arrow) does the job.
PreferredSizeWidget? rootAwareAppBar(BuildContext context, String title) {
  if (context.canPop()) return null;
  return AppBar(
    titleSpacing: 0,
    leading: BackButton(onPressed: () => context.go(Routes.home)),
    title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
  );
}

/// Sends the system back gesture to Home when there is nothing to pop.
class HomeOnBack extends StatelessWidget {
  const HomeOnBack({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: context.canPop(),
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) context.go(Routes.home);
    },
    child: child,
  );
}
