import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final User? currentUser;
  final bool isLoading;
  final String? error;

  AuthState({
    this.currentUser,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? currentUser,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthNotifier() : super(AuthState()) {
    // Mevcut kullanıcıyı başlat
    _init();
  }

  void _init() {
    final currentUser = _auth.currentUser;
    state = state.copyWith(currentUser: currentUser);
  }

  // Kullanıcı oturumu açma
  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(
        currentUser: userCredential.user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Kullanıcı çıkış yapma
  Future<void> signOut() async {
    await _auth.signOut();
    state = AuthState(); // Oturumu sıfırla
  }
}

// Auth Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
