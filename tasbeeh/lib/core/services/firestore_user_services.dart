import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/models/user_model.dart';

class FirestoreUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  Future<void> createUser(UserModel user) async {
    await _firestore
        .collection(_usersCollection)
        .doc(user.id)
        .set(user.toJson());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection(_usersCollection).doc(userId).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection(_usersCollection).doc(user.id).update({
      'name': user.name,
      'photoURL': user.photoURL,
      'updatedAt': DateTime.now().toIso8601String(),
      'settings': user.settings,
    });
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection(_usersCollection).doc(userId).delete();
  }
}
