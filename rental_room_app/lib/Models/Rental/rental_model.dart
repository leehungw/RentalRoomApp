import 'package:cloud_firestore/cloud_firestore.dart';

class Rental {
  final String identity;
  final int numberPeople;
  final DateTime startDate;
  final int duration;
  final double deposit;
  final String facebook;
  final String rentalID;

  Rental({
    required this.identity,
    required this.numberPeople,
    required this.startDate,
    required this.duration,
    required this.deposit,
    required this.facebook,
    required this.rentalID,
  });

  // Phương thức để chuyển đổi dữ liệu thành một Map để lưu trữ trên Firestore
  Map<String, dynamic> toJson() {
    return {
      'identity': identity,
      'numberPeople': numberPeople,
      'startDate': startDate,
      'duration': duration,
      'deposit': deposit,
      'facebook': facebook,
      'rentalID': rentalID,
    };
  }

  factory Rental.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Rental(
      identity: data['identity'],
      numberPeople: int.parse(data['numberPeople'].toString()),
      startDate: data['startDate'].toDate(),
      duration: int.parse(data['duration'].toString()),
      deposit: double.parse(data['deposit'].toString()),
      facebook: data['facebook'],
      rentalID: data['rentalID'],
    );
  }
}
 