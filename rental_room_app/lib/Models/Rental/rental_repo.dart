import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Models/Rental/rental_model.dart';

abstract class RentalRepository {
  Future<Rental> getRentalData(String userId, roomID);
}

class RentalRepositoryIml implements RentalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Rental> getRentalData(String userId, roomID) async {
    DocumentSnapshot doc = await _firestore
        .collection('Rooms')
        .doc(roomID)
        .collection('tenant')
        .doc(userId)
        .get();
    if (doc.exists) {
      return Rental.fromFirestore(doc);
    } else {
      throw Exception('Rental data not found');
    }
  }
}
