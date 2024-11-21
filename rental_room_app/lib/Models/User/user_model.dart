import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String userID;
  String userName;
  String email;
  String phone;
  String gender;
  DateTime birthday;
  bool isOwner;
  String desiredPrice;
  String desiredLocation_Long;
  String desiredLocaiton_Lat;
  String latestTappedRoomId;
  String bankId;
  String accountNo;
  String accountName;

  Users(
      {required this.userID,
      required this.userName,
      required this.email,
      required this.phone,
      required this.birthday,
      required this.gender,
      required this.isOwner,
      this.desiredPrice = "0",
      this.desiredLocation_Long = "None",
      this.desiredLocaiton_Lat = "None",
      this.latestTappedRoomId = "None",
      this.bankId = "",
      this.accountNo = "",
      this.accountName = ""});

  // Phương thức để chuyển đổi dữ liệu thành một Map để lưu trữ trên Firestore
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'userName': userName,
      'email': email,
      'phone': phone,
      'birthday': birthday,
      'gender': gender,
      'isOwner': isOwner,
      'desiredPrice': desiredPrice,
      'desiredLocation_Long': desiredLocation_Long,
      'desiredLocaiton_Lat': desiredLocaiton_Lat,
      'latestTappedRoomId': latestTappedRoomId,
      'bankId': bankId,
      'accountNo': accountNo,
      'accountName': accountName
    };
  }

  factory Users.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Users(
        userID: data['userID'],
        userName: data['name'],
        email: data['email'],
        phone: data['phone'],
        birthday: data['birthDay'].toDate(),
        gender: data['gender'],
        isOwner: data['isOwner'],
        desiredPrice: data['desiredPrice'],
        desiredLocation_Long: data['desiredLocation_Long'],
        desiredLocaiton_Lat: data['desiredLocation_Lat'],
        latestTappedRoomId: data['latestTappedRoomId'],
        bankId: data['bankId'],
        accountNo: data['accountNo'],
        accountName: data['accountName']);
  }

  String get getUserName => userName;
  String get getEmail => email;
  String get getPhone => phone;
  DateTime get getBirthday => birthday;
  String get getGender => gender;
  bool get getIsOwner => isOwner;
  String get getDesiredPrice => desiredPrice;
  String get getDesiredLocation_Long => desiredLocation_Long;
  String get getDesiredLocation_Lat => desiredLocaiton_Lat;
  String get getLatestRoomId => latestTappedRoomId;
}
