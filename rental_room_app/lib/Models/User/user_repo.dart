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
  Future<Users?> getUserByRentalId(String rentalId, String roomId);
  void updateLatestTappedRoom(String roomId);
  void deleteRental(String rentalId);
}

class UserRepositoryIml implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

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
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Exception("Đăng xuất thất bại: $e");
    }
  }

  @override
  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  //Dăng nhập
  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
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
        .doc(_currentUserId)
        .update({"latestTappedRoomId": roomId});
  }

  @override
  Future<Users?> getUserByRentalId(String tenantId, String roomId) async {
    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(tenantId)
        .collection('rentalroom')
        .doc(roomId)
        .get();
    if (doc.exists) {
      DocumentSnapshot docUser =
          await _firestore.collection('users').doc(tenantId).get();
      if (docUser.exists) {
        return Users.fromFirestore(docUser);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<void> deleteRental(String rentalId) async {
    QuerySnapshot rentalroomSnapshot = await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('rentalroom')
        .get();
    for (var doc in rentalroomSnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
