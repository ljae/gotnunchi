import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Current user provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current user ID provider
final currentUserIdProvider = Provider<String?>((ref) {
  final authAsync = ref.watch(currentUserProvider);
  return authAsync.when(
    data: (user) => user?.uid,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Current user display name provider
final currentUserDisplayNameProvider = Provider<String>((ref) {
  final authAsync = ref.watch(currentUserProvider);
  return authAsync.when(
    data: (user) => user?.displayName ?? user?.email?.split('@').first ?? 'Anonymous',
    loading: () => 'Loading...',
    error: (_, __) => 'Anonymous',
  );
});
