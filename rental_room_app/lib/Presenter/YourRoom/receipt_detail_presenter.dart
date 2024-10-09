import 'package:rental_room_app/Contract/YourRoom/receipt_detail_contract.dart';

class ReceiptDetailPresenter {
  final ReceiptDetailContract? _view;
  ReceiptDetailPresenter(this._view);

  Future<void> _changeIsRead() async {
    await _firestore
        .collection('Receipts')
        .doc(widget.receipt.receiptID)
        .update({'isRead': true});
  }

  Future<void> _updateStatus() async {
    await _firestore
        .collection('Receipts')
        .doc(widget.receipt.receiptID)
        .update({'status': true});
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ListNotificationScreen(),
      ),
    );
  }

  Future<void> _loadTenant() async {
    DocumentSnapshot docUser =
        await _firestore.collection('users').doc(widget.receipt.tenantID).get();
    if (docUser.exists) {
      setState(() {
        user = Users.fromFirestore(docUser);
      });
    }
    _rentalRepository
        .getRentalData(widget.receipt.tenantID, widget.room.roomId)
        .then((value) {
      setState(() {
        rental = value;
      });
    });
  }
}
