import 'package:rental_room_app/Contract/new_receipt_contract.dart';
import 'package:rental_room_app/Models/Receipt/receipt_model.dart';
import 'package:rental_room_app/Models/Receipt/receipt_repo.dart';

class NewReceiptPresenter {
  // ignore: unused_field
  final NewReceiptContract? _view;
  NewReceiptPresenter(this._view);
  final ReceiptRepository _receiptRepository = ReceiptRepositoryIml();

  String? validateRoomPrice(String? value) {
    return null;
  }

  String? validateOtherPrice(String? value) {
    return null;
  }

  String? validateElectricPrice(String? value) {
    value = value?.trim();

    if (value == null || value == "") {
      return "Please enter Electric Index";
    }
    if (value.contains(',')) {
      return "Please use '.' instead of ','!";
    }
    double area;
    try {
      area = double.parse(value);
    } catch (e) {
      return "Invalid Electric Index";
    }
    if (area <= 0) {
      return "Electric Index must be greater than 0!";
    }
    return null;
  }

  String? validateWaterPrice(String? value) {
    value = value?.trim();

    if (value == null || value == "") {
      return "Please enter water index";
    }
    if (value.contains(',')) {
      return "Please use '.' instead of ','!";
    }
    double area;
    try {
      area = double.parse(value);
    } catch (e) {
      return "Invalid water index";
    }
    if (area <= 0) {
      return "Water index must be greater than 0!";
    }
    return null;
  }

  Future<void> sendButtonPressed(
      String tenantID,
      String ownerId,
      String roomId,
      bool status,
      bool isRead,
      DateTime createDay,
      String water,
      String electric) async {
    _view?.onWaitingProgressBar();
    Receipt rcp = Receipt(
        receiptID: "",
        tenantID: tenantID,
        ownerID: ownerId,
        roomID: roomId,
        status: status,
        isRead: isRead,
        createdDay: createDay,
        waterIndex: double.parse(water),
        electricIndex: double.parse(electric));
    try {
      await _receiptRepository.uploadReceipt(rcp);
    } catch (e) {
      _view?.onCreateFailed();
      _view?.onPopContext();
      return;
    }
    _view?.onCreateSucceeded();
    _view?.onPopContext();
  }
}
