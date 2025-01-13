import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_room_app/Models/Price/price_model.dart';

enum Kind { apartment, flat, loftRoom }

class Room {
  static const String documentId = 'Rooms';

  String roomId;
  String roomName;
  String kind;
  double area;
  String location;
  String description;
  String primaryImgUrl;
  List<String> secondaryImgUrls;
  Price price;
  String ownerId;
  String ownerName;
  String ownerPhone;
  String ownerEmail;
  String ownerFacebook;
  String ownerAddress;
  bool isAvailable;
  List<String> tags;
  List<String> amenities;

  Room({
    required this.roomId,
    required this.roomName,
    required this.kind,
    required this.area,
    required this.location,
    required this.description,
    required this.primaryImgUrl,
    required this.secondaryImgUrls,
    required this.price,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.ownerFacebook,
    required this.ownerAddress,
    required this.isAvailable,
    required this.tags,
    required this.amenities,
  });

  // Method to convert data to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'kind': kind,
      'area': area,
      'location': location,
      'description': description,
      'primaryImgUrl': primaryImgUrl,
      'secondaryImgUrls': secondaryImgUrls,
      'price': price.toJson(),
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'ownerFacebook': ownerFacebook,
      'ownerAddress': ownerAddress,
      'isAvailable': isAvailable,
      'tags': tags,
      'amenities': amenities,
    };
  }

  factory Room.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    double area = 0.0;
    try {
      area = double.parse(data['area'].toString());
    } catch (e) {
      print("Error parsing 'area': $e");
    }

    return Room(
      roomId: data['roomId'],
      roomName: data['roomName'],
      kind: data['kind'],
      area: double.parse(data['area'].toString()),
      location: data['location'],
      description: data['description'],
      primaryImgUrl: data['primaryImgUrl'],
      secondaryImgUrls:
          (data['secondaryImgUrls'] as List<dynamic>).cast<String>(),
      price: Price.fromFirestore(data['price']),
      ownerId: data['ownerId'],
      ownerName: data['ownerName'],
      ownerPhone: data['ownerPhone'],
      ownerEmail: data['ownerEmail'],
      ownerFacebook: data['ownerFacebook'],
      ownerAddress: data['ownerAddress'],
      isAvailable: data['isAvailable'],
      tags: (data['tags'] as List<dynamic>).cast<String>(),
      amenities: (data['amenities'] as List<dynamic>).cast<String>(),
    );
  }
}
