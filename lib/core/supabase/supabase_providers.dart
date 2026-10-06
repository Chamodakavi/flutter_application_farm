import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The single Supabase client. Overridden with a mock in tests.
final supabaseClientProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

/// Auth events (sign in, sign out, token refresh, password recovery).
final authStateProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange,
);

/// The signed-in user, or null.
final currentUserProvider = Provider<User?>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(supabaseClientProvider).auth.currentUser;
});

/// Stable across token refreshes — watch this (not [currentUserProvider]) to
/// rebuild only when the account changes.
final currentUserIdProvider = Provider<String?>(
  (ref) => ref.watch(currentUserProvider.select((u) => u?.id)),
);
