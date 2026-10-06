import 'package:farmfriend/core/notifications/local_notifications.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabase extends Mock implements SupabaseClient {}

class MockChannel extends Mock implements RealtimeChannel {}

typedef ChangeCallback = void Function(PostgresChangePayload payload);

void _ignoreChange(PostgresChangePayload payload) {}

typedef ShownNotification = ({NotifyChannel channel, String title, String? body, String? route});

/// Records what would have been shown as a system notification.
class RecordingNotifications extends LocalNotifications {
  RecordingNotifications(super.ref, this.shown);

  final List<ShownNotification> shown;

  @override
  Future<void> show({
    required NotifyChannel channel,
    required String title,
    String? body,
    String? route,
  }) async => shown.add((channel: channel, title: title, body: body, route: route));
}

/// A Supabase client whose realtime channel records the subscription instead
/// of opening a socket.
class RealtimeHarness {
  RealtimeHarness() {
    registerFallbackValue(PostgresChangeEvent.all);
    registerFallbackValue(_ignoreChange);
    when(() => db.channel(any())).thenReturn(channel);
    when(
      () => channel.onPostgresChanges(
        event: any(named: 'event'),
        schema: any(named: 'schema'),
        table: any(named: 'table'),
        filter: any(named: 'filter'),
        callback: any(named: 'callback'),
      ),
    ).thenReturn(channel);
    when(() => channel.subscribe()).thenReturn(channel);
    when(() => db.removeChannel(channel)).thenAnswer((_) async => 'ok');
  }

  final db = MockSupabase();
  final channel = MockChannel();

  /// Name of the channel that was opened.
  late final String channelName = verify(() => db.channel(captureAny())).captured.single as String;

  /// The single `onPostgresChanges` registration: its arguments and callback.
  /// Read once and kept — mocktail verifies a call only one time.
  late final ({
    PostgresChangeEvent event,
    String? table,
    PostgresChangeFilter? filter,
    ChangeCallback emit,
  })
  subscription = _captureSubscription();

  ({PostgresChangeEvent event, String? table, PostgresChangeFilter? filter, ChangeCallback emit})
  _captureSubscription() {
    final captured = verify(
      () => channel.onPostgresChanges(
        event: captureAny(named: 'event'),
        schema: 'public',
        table: captureAny(named: 'table'),
        filter: captureAny(named: 'filter'),
        callback: captureAny(named: 'callback'),
      ),
    ).captured;
    // Named arguments are captured in no particular order: pick by type.
    return (
      event: captured.whereType<PostgresChangeEvent>().single,
      table: captured.whereType<String>().singleOrNull,
      filter: captured.whereType<PostgresChangeFilter>().singleOrNull,
      emit: captured.whereType<ChangeCallback>().single,
    );
  }

  static PostgresChangePayload payload({
    required String table,
    required PostgresChangeEvent event,
    required Map<String, dynamic> newRecord,
    Map<String, dynamic> oldRecord = const {},
  }) => PostgresChangePayload(
    schema: 'public',
    table: table,
    commitTimestamp: DateTime(2026, 10, 5),
    eventType: event,
    newRecord: newRecord,
    oldRecord: oldRecord,
    errors: null,
  );
}
