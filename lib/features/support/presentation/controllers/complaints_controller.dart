import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../../../core/notifications/local_notifications.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../../../core/utils/app_status.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../profile/domain/app_user.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../data/complaint_repository.dart';
import '../../domain/complaint.dart';

extension ComplaintChip on Complaint {
  /// Value for `StatusChip`: a message that is still `Pending` in the
  /// database but already has a reply reads "Replied"; statuses the app does
  /// not know are passed through as stored.
  String? get chipStatus => statusEnum == AppStatus.unknown ? status : statusEnum.name;
}

/// Whether a realtime update of a complaint brings a reply the farmer has not
/// been told about. [previous] is the copy on screen, when there is one;
/// [oldRecord] is the old row from realtime (only the id unless the table
/// uses `REPLICA IDENTITY FULL`).
bool isNewAdminReply({
  required Complaint? previous,
  required Complaint updated,
  Map<String, dynamic> oldRecord = const {},
}) {
  if (!updated.hasReply) return false;
  final reply = updated.adminReply!.trim();
  if (previous != null) return (previous.adminReply ?? '').trim() != reply;
  if (oldRecord.containsKey('admin_reply')) {
    return (oldRecord['admin_reply']?.toString() ?? '').trim() != reply;
  }
  // Nothing to compare with: only an unread reply counts, so the farmer's own
  // "mark as read" update stays silent.
  return updated.readAt == null;
}

/// "My Sent Messages" — the signed-in user's complaints, newest first.
class ComplaintsController extends AsyncNotifier<List<Complaint>> {
  @override
  Future<List<Complaint>> build() async {
    final uid = ref.watch(currentUserIdProvider);
    if (uid == null) return const [];
    return ref.watch(complaintRepositoryProvider).fetchMine();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  void _set(List<Complaint> complaints) {
    state = AsyncData(complaints);
    unawaited(_cache(complaints));
  }

  Future<void> _cache(List<Complaint> complaints) async {
    try {
      await ref.read(complaintRepositoryProvider).saveToCache(complaints);
    } catch (_) {
      // The offline copy is refreshed on the next successful load.
    }
  }

  /// Sends a new message, signed with the profile's name and email.
  Future<Complaint> send({required String subject, required String body}) async {
    AppUser? profile;
    try {
      profile = await ref.read(profileProvider.future);
    } catch (_) {
      // The message is still linked to the account by `user_id`.
    }
    final name = profile?.displayName ?? '';
    final created = await ref
        .read(complaintRepositoryProvider)
        .send(
          subject: subject.trim(),
          body: body.trim(),
          userName: name.isEmpty ? null : name,
          userEmail: profile?.email,
        );
    if (ref.mounted) _set([created, ...?state.value]);
    return created;
  }

  /// Applies a row received over realtime (admin reply, status change).
  void applyUpdate(Complaint updated) {
    final current = state.value;
    if (current == null) {
      ref.invalidateSelf();
      return;
    }
    final known = current.any((c) => c.id == updated.id);
    _set([if (!known) updated, for (final c in current) c.id == updated.id ? updated : c]);
  }

  /// Opening a reply marks it as read. Best effort: the web may not let the
  /// farmer update `read_at`, and that must not disturb the screen.
  Future<void> markRead(Complaint complaint) async {
    if (!complaint.hasUnreadReply) return;
    try {
      await ref.read(complaintRepositoryProvider).markRead(complaint.id);
    } catch (_) {
      return;
    }
    if (!ref.mounted) return;
    final current = state.value;
    if (current == null) return;
    final now = DateTime.now();
    _set([for (final c in current) c.id == complaint.id ? c.copyWith(readAt: now) : c]);
  }
}

final complaintsProvider = AsyncNotifierProvider<ComplaintsController, List<Complaint>>(
  ComplaintsController.new,
);

/// One complaint by id — the detail screen, also reached from a push
/// notification before the list was ever loaded.
final complaintProvider = FutureProvider.autoDispose.family<Complaint, int>(
  (ref, id) => ref.watch(complaintRepositoryProvider).fetchById(id),
);

/// Watched by the app shell while signed in: realtime `complaints` updates for
/// the user refresh the list and announce a new admin reply (spec §17.1).
final complaintsRealtimeProvider = Provider<void>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return;
  final db = ref.watch(supabaseClientProvider);

  // Reply text already announced per complaint, so a later status change on
  // the same row is not announced again.
  final announced = <int, String>{};

  void onUpdate(PostgresChangePayload payload) {
    if (!ref.mounted) return;
    final Complaint updated;
    try {
      updated = Complaint.fromJson(payload.newRecord);
    } catch (_) {
      ref.invalidate(complaintsProvider);
      return;
    }
    final loaded = ref.exists(complaintsProvider);
    final previous = loaded
        ? ref.read(complaintsProvider).value?.where((c) => c.id == updated.id).firstOrNull
        : null;
    final isNew =
        isNewAdminReply(previous: previous, updated: updated, oldRecord: payload.oldRecord) &&
        announced[updated.id] != updated.adminReply;

    if (loaded) ref.read(complaintsProvider.notifier).applyUpdate(updated);
    ref.invalidate(complaintProvider(updated.id));

    if (!isNew) return;
    announced[updated.id] = updated.adminReply ?? '';
    final l10n = lookupAppLocalizations(ref.read(localeControllerProvider));
    unawaited(
      ref
          .read(localNotificationsProvider)
          .show(
            channel: NotifyChannel.alerts,
            title: l10n.supportReplyNotifTitle,
            body: updated.subject,
            route: Routes.complaint(updated.id),
          ),
    );
  }

  final channel = db
      .channel('complaints-$uid')
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: Tables.complaints,
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: uid,
        ),
        callback: onUpdate,
      )
      .subscribe();
  ref.onDispose(() => unawaited(db.removeChannel(channel)));
});
