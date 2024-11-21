import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/YourRoom/receipt_detail_contract.dart';
import 'package:rental_room_app/Models/Receipt/receipt_repo.dart';
import 'package:rental_room_app/Models/Rental/rental_repo.dart';
import 'package:rental_room_app/Models/User/user_model.dart';
import 'package:rental_room_app/Models/User/user_repo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReceiptDetailPresenter {
  final ReceiptDetailContract? _view;
  ReceiptDetailPresenter(this._view);

  final UserRepository _userRepository = UserRepositoryIml();
  final RentalRepository _rentalRepository = RentalRepositoryIml();
  final ReceiptRepository _receiptRepository = ReceiptRepositoryIml();

  Future<void> changeIsRead(String receiptId) async {
    _receiptRepository.updateIsRead(receiptId, true);
  }

  Future<void> updateStatus(String receiptId) async {
    _receiptRepository.updateStatus(receiptId, true);
    _view?.onGoToListNoti();
  }

  Future<void> loadTenant(String tenantId, String roomId) async {
    _view?.onGetTenant(await _userRepository.getUserById(tenantId));
    try {
      _rentalRepository.getRentalData(tenantId, roomId).then((value) {
        _view?.onGetRental(value);
      });
    } catch (e) {
      print("=============Error load tenant");
    }
  }

  Future<void> fetchQRImageURL(
      {required String ownerUID,
      required String amount,
      required String roomName}) async {
    try {
      final Uri url = Uri.parse(
        'https://api.vietqr.io/v2/generate',
      );

      Users currentUser = await UserRepositoryIml()
          .getUserById(FirebaseAuth.instance.currentUser!.uid);
      Users owner = await UserRepositoryIml().getUserById(ownerUID);

      if (owner.bankId.isEmpty) {
        _view?.onShowNoQR();
        return;
      }

      String imageURL =
          "https://img.vietqr.io/image/${owner.bankId}-${owner.accountNo}-print.png?amount=${amount}&addInfo=${'${currentUser.userName} dong tien tro phong $roomName'}&accountName=${owner.accountName}";
      _view?.onShowQR(imageURL);
    } catch (e) {
      print("Error fetching QR image URL: $e");
    }
  }
}
