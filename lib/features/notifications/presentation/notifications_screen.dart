import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/app_notification.dart';
import '../domain/notification_kind.dart';
import 'controllers/notifications_controller.dart';

/// The broadcast inbox (spec §11.24). Opening it does not mark anything as
/// read; tapping an item does, and shows its full message.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final _expanded = <String>{};

  Future<void> _refresh() async {
    try {
      await ref.read(notificationsProvider.notifier).refresh();
    } catch (_) {
      // The error state offers Retry.
    }
  }

  void _open(AppNotification notification) {
    setState(() {
      if (!_expanded.remove(notification.id)) _expanded.add(notification.id);
    });
    unawaited(ref.read(readNotificationIdsProvider.notifier).markRead(notification.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final notifications = ref.watch(notificationsProvider);
    final readIds = ref.watch(readNotificationIdsProvider).value ?? const <String>{};
    final unread = ref.watch(unreadNotificationCountProvider);

    return AppScaffold(
      title: l10n.appBarNotifications,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: AsyncValueView<List<AppNotification>>(
          value: notifications,
          error: (e) => _Scrollable(
            child: ErrorState(error: e, onRetry: () => ref.invalidate(notificationsProvider)),
          ),
          empty: _Scrollable(
            child: EmptyState(
              icon: Icons.notifications_none_rounded,
              title: l10n.notifEmptyTitle,
              message: l10n.notifEmptyMessage,
            ),
          ),
          data: (items) => ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.page,
            itemCount: items.length + 1,
            separatorBuilder: (_, i) => SizedBox(height: i == 0 ? 0 : AppSpacing.md),
            itemBuilder: (context, i) {
              if (i == 0) {
                return _UnreadHeader(
                  unread: unread,
                  onMarkAll: () => unawaited(
                    ref
                        .read(readNotificationIdsProvider.notifier)
                        .markAllRead(items.map((n) => n.id)),
                  ),
                );
              }
              final notification = items[i - 1];
              return _NotificationTile(
                notification: notification,
                unread: !readIds.contains(notification.id),
                expanded: _expanded.contains(notification.id),
                onTap: () => _open(notification),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Lets pull-to-refresh work on the empty and error states.
class _Scrollable extends StatelessWidget {
  const _Scrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: child,
      ),
    ),
  );
}

/// "3 unread" with the "Mark all read" action; hidden once all are read.
class _UnreadHeader extends StatelessWidget {
  const _UnreadHeader({required this.unread, required this.onMarkAll});

  final int unread;
  final VoidCallback onMarkAll;

  @override
  Widget build(BuildContext context) {
    if (unread == 0) return const SizedBox.shrink();
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.notifUnreadCount(unread),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: TextButton.icon(
              onPressed: onMarkAll,
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: Text(l10n.notifMarkAllRead, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.unread,
    required this.expanded,
    required this.onTap,
  });

  final AppNotification notification;
  final bool unread;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final kind = NotificationKind.of(notification.title, notification.message);
    final title = notification.title.trim();
    final message = notification.message.trim();

    return SectionCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kind.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(kind.icon, size: 22, color: kind.color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.isEmpty ? l10n.notifNewTitle : title,
                  style: text.titleSmall?.copyWith(
                    fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
                  ),
                  maxLines: expanded ? null : 2,
                  overflow: expanded ? null : TextOverflow.ellipsis,
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: text.bodyMedium?.copyWith(
                      color: unread ? AppColors.ink900 : AppColors.ink500,
                    ),
                    maxLines: expanded ? null : 2,
                    overflow: expanded ? null : TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),
                Text(context.relativeTime(notification.createdAt), style: text.bodySmall),
              ],
            ),
          ),
          if (unread) ...[
            const SizedBox(width: AppSpacing.sm),
            Semantics(
              label: l10n.notifUnread,
              child: Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(color: AppColors.orange500, shape: BoxShape.circle),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
