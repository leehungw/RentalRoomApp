import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/User/user_model.dart';
import 'package:rental_room_app/Models/User/user_repo.dart';

abstract class RoomRepository {
  Future<void> uploadRoom(Room room);
  Future<List<String>> uploadImages(
      List<Uint8List> images, String userId, String roomId);
  Stream<List<Room>> getRooms({
    String? keyword,
    Kind? kind,
    double? minArea,
    double? maxArea,
    double? minPrice,
    double? maxPrice,
  });
  Stream<List<Room>> getOwnedRoom();
  Future<QuerySnapshot> getOwnedRoomSnapshot();
  Future<Room> getRoomById(String roomID);
  Future<List<Room>> getRecommendedRooms(String userId);
  Future<void> deleteTenant(String roomId);
  Future<void> updateRoomAvailability(String roomId, bool isAvail);
  Future<void> deleteRoom(String roomId);
}

class RoomRepositoryIml implements RoomRepository {
  static final RoomRepositoryIml _instance = RoomRepositoryIml._internal();

  RoomRepositoryIml._internal();

  factory RoomRepositoryIml() {
    return _instance;
  }

  String apiUrl = 'https://3d99-2405-4802-917a-7d30-9811-b705-a4a9-260a.ngrok-free.app/';

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Future<void> uploadRoom(Room room) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection(Room.documentId).doc();

    // Cập nhật roomId với documentID
    room.roomId = docRef.id;
    await docRef
        .set(room.toJson())
        .onError((e, _) => throw Exception('Upload Room Failed'));
  }

  @override
  Future<List<String>> uploadImages(
      List<Uint8List> images, String userId, String roomId) async {
    int fileName = 0;
    List<String> imageUrls = [];

    for (Uint8List image in images) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('Rooms')
          .child(userId)
          .child(roomId)
          .child('pic$fileName.jpg');
      fileName++;
      await ref.putData(image, SettableMetadata(contentType: 'image/jpeg'));

      String url = await ref.getDownloadURL();
      imageUrls.add(url);
    }
    return imageUrls;
  }

  @override
  Stream<List<Room>> getRooms({
    String? keyword,
    Kind? kind,
    double? minArea,
    double? maxArea,
    double? minPrice,
    double? maxPrice,
  }) {
    Query query = FirebaseFirestore.instance
        .collection(Room.documentId)
        .where('isAvailable', isEqualTo: true);

    // Apply filters dynamically
    if (keyword != null && keyword.isNotEmpty) {
      query = query.where('roomName', isGreaterThanOrEqualTo: keyword).where(
          'roomName',
          isLessThanOrEqualTo: keyword + '\uf8ff'); // Firestore text search
    }

    if (kind != null) {
      query = query.where('kind', isEqualTo: kind.name);
    }

    if (minArea != null) {
      query = query.where('area', isGreaterThanOrEqualTo: minArea);
    }

    if (maxArea != null) {
      query = query.where('area', isLessThanOrEqualTo: maxArea);
    }

    if (minPrice != null) {
      query = query.where('price.value', isGreaterThanOrEqualTo: minPrice);
    }

    if (maxPrice != null) {
      query = query.where('price.value', isLessThanOrEqualTo: maxPrice);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList());
  }

  @override
  Future<Room> getRoomById(String roomID) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('Rooms').doc(roomID).get();
    if (doc.exists) {
      return Room.fromFirestore(doc);
    } else {
      throw Exception('This Room data not found');
    }
  }

  @override
  Future<List<Room>> getRecommendedRooms(String userId) async {
    UserRepository userRepo = UserRepositoryIml();
    Users user = await userRepo.getUserById(userId);

    if (user.latestTappedRoomId == "None") {
      return recommendForNewUsers(user);
    } else {
      return recommendForOldUsers(user);
    }
  }

  Future<List<Room>> recommendForNewUsers(Users user) async {
    http.Response response = await http.post(
      Uri.parse('${apiUrl}recommend/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "gender": user.gender,
        "desiredPrice": user.desiredPrice,
        "desiredLocation_Long": user.desiredLocation_Long,
        "desiredLocation_Lat": user.desiredLocaiton_Lat
      }),
    );
    List<String> recommendedRoomIds = [];
    try {
      recommendedRoomIds =
          json.decode(response.body)['recommend'].cast<String>();
    } catch (e) {
      print("unavailable server! $e");
    }
    List<Room> recommendedRooms = [];
    for (String id in recommendedRoomIds) {
      Room r = await getRoomById(id);
      recommendedRooms.add(r);
    }
    return recommendedRooms;
  }

  Future<List<Room>> recommendForOldUsers(Users user) async {
    final roomRepository = RoomRepositoryIml();
    Room tappedRoom = await roomRepository.getRoomById(user.latestTappedRoomId);

    List<Location> locations = await locationFromAddress(tappedRoom.location);
    if (locations.isEmpty) {
      return recommendForNewUsers(user);
    }
    Location location = locations.first;

    http.Response response = await http.post(
      Uri.parse('${apiUrl}recommend/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "gender": user.gender,
        "desiredPrice": tappedRoom.price.roomPrice,
        "desiredLocation_Long": location.longitude,
        "desiredLocation_Lat": location.latitude,
        "tags": tappedRoom.tags,
        "amenities": tappedRoom.amenities,
        "kind": tappedRoom.kind
      }),
    );
    List<String> recommendedRoomIds = [];
    try {
      recommendedRoomIds =
          json.decode(response.body)['recommend'].cast<String>();
    } catch (e) {
      print("unavailable server!");
    }
    List<Room> recommendedRooms = [];
    for (String id in recommendedRoomIds) {
      Room r = await getRoomById(id);
      recommendedRooms.add(r);
    }
    return recommendedRooms;
  }

  @override
  Stream<List<Room>> getOwnedRoom() {
    return FirebaseFirestore.instance
        .collection(Room.documentId)
        .where('ownerId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList());
  }

  @override
  Future<void> deleteTenant(String roomId) async {
    QuerySnapshot tenantSnapshot = await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(roomId)
        .collection('tenant')
        .get();
    for (var doc in tenantSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> updateRoomAvailability(String roomId, bool isAvail) async {
    await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(roomId)
        .update({'isAvailable': isAvail});
  }

  @override
  Future<void> deleteRoom(String roomId) async {
    await FirebaseFirestore.instance.collection('Rooms').doc(roomId).delete();
  }

  @override
  Future<QuerySnapshot<Object?>> getOwnedRoomSnapshot() async {
    return await FirebaseFirestore.instance
        .collection('Rooms')
        .where('ownerId', isEqualTo: currentUserId)
        .get();
  }
}
