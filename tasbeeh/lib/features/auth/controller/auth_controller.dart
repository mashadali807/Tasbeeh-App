import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:get/get.dart';
import '../models/auth_state.dart';
import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  // Reactive state
  final Rx<AuthState> _state = AuthState(status: AuthStatus.initial).obs;
  AuthState get state => _state.value;

  // Observables for UI loading/errors
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  AuthController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<void> checkAuthStatus() async {
    _state.value = _state.value.copyWith(status: AuthStatus.loading);
    try {
      print('🔍 Checking auth status...');
      final user = await _authRepository.getCurrentUser();
      print('👤 User from repository: $user');
      if (user != null) {
        _state.value = _state.value.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
        print('✅ User is authenticated: ${user.name}');
      } else {
        _state.value = _state.value.copyWith(
          status: AuthStatus.unauthenticated,
        );
        print('❌ No user found, not authenticated.');
      }
    } catch (e) {
      print('⚠️ Error checking auth: $e');
      _state.value = _state.value.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please fill all fields';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _authRepository.signInWithEmailPassword(
        email,
        password,
      );
      _state.value = _state.value.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
      Get.offAllNamed('/home'); // we'll define home route later
    } catch (e) {
      errorMessage.value = _mapAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      errorMessage.value = 'Please fill all fields';
      return;
    }
    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match';
      return;
    }
    if (password.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _authRepository.signUpWithEmailPassword(
        email,
        password,
        name,
      );
      _state.value = _state.value.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      errorMessage.value = _mapAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _authRepository.signInWithGoogle();
      _state.value = _state.value.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      errorMessage.value = _mapAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      errorMessage.value = 'Please enter your email';
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authRepository.sendPasswordResetEmail(email);
      Get.back(); // go back to login
      Get.snackbar('Success', 'Password reset email sent! Check your inbox.');
    } catch (e) {
      errorMessage.value = _mapAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepository.signOut();
      _state.value = _state.value.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      );
      Get.offAllNamed('/login');
    } catch (e) {
      errorMessage.value = _mapAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  String _mapAuthError(dynamic e) {
    // Firebase auth error codes mapping
    if (e is firebase.FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'Email already in use.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'weak-password':
          return 'Password is too weak.';
        default:
          return 'Authentication error: ${e.message}';
      }
    }
    return e.toString();
  }
}
