import 'package:rental_room_app/Contract/YourRoom/receipt_detail_contract.dart';
import 'package:rental_room_app/Models/Receipt/receipt_repo.dart';
import 'package:rental_room_app/Models/Rental/rental_repo.dart';
import 'package:rental_room_app/Models/User/user_repo.dart';

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
    _rentalRepository.getRentalData(tenantId, roomId).then((value) {
      _view?.onGetRental(value);
    });
  }
}
