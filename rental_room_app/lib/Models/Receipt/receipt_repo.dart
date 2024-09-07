import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_room_app/Models/Receipt/receipt_model.dart';

abstract class ReceiptRepository {
  Future<void> uploadReceipt(Receipt receipt);
  Stream<List<Receipt>> getReceipts();
  Future<Receipt> getReceiptById(String receiptID);
}

class ReceiptRepositoryIml implements ReceiptRepository {
  @override
  Future<void> uploadReceipt(Receipt receipt) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Receipts').doc();

    // Cập nhật roomId với documentID
    receipt.receiptID = docRef.id;
    await docRef
        .set(receipt.toJson())
        .onError((e, _) => throw Exception('Upload Room Failed'));
  }

  @override
  Stream<List<Receipt>> getReceipts() {
    return FirebaseFirestore.instance.collection('Receipts').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Receipt.fromFirestore(doc)).toList());
  }

  @override
  Future<Receipt> getReceiptById(String receiptID) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Receipts')
        .doc(receiptID)
        .get();
    if (doc.exists) {
      return Receipt.fromFirestore(doc);
    } else {
      throw Exception('This Receipt data not found');
    }
  }
}
