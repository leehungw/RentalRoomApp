import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Models/User/user_model.dart';

abstract class UserRepository {
  Future<Map<String, dynamic>> getUserData(String userId);
  Future<void> signOut();
  Stream<User?> get authStateChanges;
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password);
  String? get userId;
  Future<Users> getUserById(String userId);
  void updateLatestTappedRoom(String roomId);
}

class UserRepositoryIml implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Map<String, dynamic>> getUserData(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      throw Exception('User data not found');
    }
  }

  // Đăng xuất
  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Đăng xuất thất bại: $e");
    }
  }

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //Dăng nhập
  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  @override
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  Future<Users> getUserById(String userId) async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return Users.fromFirestore(doc);
    } else {
      throw Exception('User data not found');
    }
  }

  @override
  void updateLatestTappedRoom(String roomId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({"latestTappedRoomId": roomId});
  }
}
