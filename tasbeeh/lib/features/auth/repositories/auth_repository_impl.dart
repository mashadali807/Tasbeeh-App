import 'package:tasbeeh/core/services/firebase_auth_services.dart';
import 'package:tasbeeh/core/services/firestore_user_services.dart';

import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;
  final FirestoreUserService _firestoreService;

  AuthRepositoryImpl({
    required FirebaseAuthService authService,
    required FirestoreUserService firestoreService,
  }) : _authService = authService,
       _firestoreService = firestoreService;

  @override
Future<UserModel?> getCurrentUser() async {
  try {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null) return null;
    final userModel = await _firestoreService.getUser(firebaseUser.uid);
    return userModel;
  } catch (e) {
    print('⚠️ Error getting current user: $e');
    return null;
  }
}

  @override
  Future<UserModel> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final credential = await _authService.signInWithEmailPassword(
      email,
      password,
    );
    final firebaseUser = credential.user!;
    final userModel = await _firestoreService.getUser(firebaseUser.uid);
    if (userModel == null) {
      // Should not happen if we create user on registration, but fallback:
      throw Exception('User data not found. Please register.');
    }
    return userModel;
  }

  @override
  Future<UserModel> signUpWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    final credential = await _authService.createUserWithEmailPassword(
      email,
      password,
    );
    final firebaseUser = credential.user!;
    // Update display name
    await firebaseUser.updateDisplayName(name);
    await firebaseUser.reload();
    final updatedUser = _authService.currentUser;

    final newUser = UserModel(
      id: firebaseUser.uid,
      name: name,
      email: email,
      photoURL: updatedUser?.photoURL,
      createdAt: DateTime.now(),
    );
    await _firestoreService.createUser(newUser);
    return newUser;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final credential = await _authService.signInWithGoogle();
    final firebaseUser = credential.user!;
    // Check if user exists in Firestore; if not, create one.
    UserModel? userModel = await _firestoreService.getUser(firebaseUser.uid);
    if (userModel == null) {
      // Create new user
      userModel = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'User',
        email: firebaseUser.email!,
        photoURL: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );
      await _firestoreService.createUser(userModel);
    }
    return userModel;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }
}
