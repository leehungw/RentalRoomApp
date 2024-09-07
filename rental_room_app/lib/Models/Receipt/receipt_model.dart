import 'package:cloud_firestore/cloud_firestore.dart';

class Receipt {
  String receiptID;
  String tenantID;
  String ownerID;
  String roomID;
  bool status;
  bool isRead;
  DateTime createdDay;
  double waterIndex;
  double electricIndex;

  Receipt(
      {required this.receiptID,
      required this.tenantID,
      required this.ownerID,
      required this.roomID,
      required this.status,
      required this.isRead,
      required this.createdDay,
      required this.waterIndex,
      required this.electricIndex});

  // Phương thức để chuyển đổi dữ liệu thành một Map để lưu trữ trên Firestore
  Map<String, dynamic> toJson() {
    return {
      'receiptID': receiptID,
      'tenantID': tenantID,
      'ownerID': ownerID,
      'roomID': roomID,
      'status': status,
      'isRead': isRead,
      'createdDay': createdDay,
      'waterIndex': waterIndex,
      'electricIndex': electricIndex
    };
  }

  factory Receipt.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Receipt(
        receiptID: data['receiptID'],
        tenantID: data['tenantID'],
        ownerID: data['ownerID'],
        roomID: data['roomID'],
        status: data['status'],
        isRead: data['isRead'],
        createdDay: data['createdDay'].toDate(),
        waterIndex: double.parse(data['waterIndex'].toString()),
        electricIndex: double.parse(data['electricIndex'].toString()));
  }

  String get getreceiptID => receiptID;
  String get getTenantID => tenantID;
  String get getOwnerID => ownerID;
  String get getRoomID => roomID;
  bool get getStatus => status;
  bool get getIsRead => isRead;
  DateTime get getCreatedDay => createdDay;
  double get getWaterIndex => waterIndex;
  double get getElectricIndex => electricIndex;
}
