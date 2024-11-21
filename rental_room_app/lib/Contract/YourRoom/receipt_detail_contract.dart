import 'package:rental_room_app/Models/Rental/rental_model.dart';
import 'package:rental_room_app/Models/User/user_model.dart';

abstract class ReceiptDetailContract {
  void onGoToListNoti();
  void onGetRental(Rental? rental);
  void onGetTenant(Users? user);
  void onShowQR(String qrImageURL);
  void onShowNoQR();
}
