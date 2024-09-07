import 'package:cloud_firestore/cloud_firestore.dart';

class Price {
  int room;
  int water;
  int electric;
  int others;

  Price(
      {required this.room,
      required this.water,
      required this.electric,
      required this.others});

  // Phương thức để chuyển đổi dữ liệu thành một Map để lưu trữ trên Firestore
  Map<String, dynamic> toJson() {
    return {
      'room': room,
      'water': water,
      'electric': electric,
      'others': others
    };
  }

  factory Price.fromFirestore(Map<String, dynamic> data) {
    return Price(
      room: int.parse(data['room'].toString()),
      water: int.parse(data['water'].toString()),
      electric: int.parse(data['electric'].toString()),
      others: int.parse(data['others'].toString()),
    );
  }
  int get roomPrice => room;
  int get waterPrice => water;
  int get electricPrice => electric;
  int get othersPrice => others;
}
