import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase/supabase_client.dart';
import '../services/auth_service.dart';
import '../../profile/utils/level_system.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

final authServiceProvider = Provider((ref) => AuthService());

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(AuthState());

  // Login method
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await authService.signIn(
        email: email,
        password: password,
      );

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  // Register method
  Future<bool> register({
    required String email,
    required String password,
    required String username,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await authService.signUp(
        email: email,
        password: password,
        username: username,
      );

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await authService.signOut();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void reset() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

final currentUserProvider = StreamProvider<User?>((ref) {
  return supabase.auth.onAuthStateChange.map((event) => event.session?.user);
});

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.value;
  
  if (user == null) {
    return null;
  }

  try {
    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    
    return data;
  } catch (e) {
    print('Error fetching profile: $e');
    return null;
  }
});

class XpService {
  final Ref _ref;
  XpService(this._ref);

  Future<void> addXp(int amount) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final profile = await _ref.read(userProfileProvider.future);
      final currentXp = profile?['xp'] as int? ?? 0;
      final newXp = currentXp + amount;
      
      // Calculate level using LevelSystem
      final newLevel = LevelSystem.getLevel(newXp);

      await supabase
          .from('profiles')
          .update({
            'xp': newXp,
            'level': newLevel,
          })
          .eq('id', user.id);

      _ref.invalidate(userProfileProvider);
    } catch (e) {
      print('Error updating XP: $e');
    }
  }
}

final xpServiceProvider = Provider((ref) => XpService(ref));
