import 'package:rental_room_app/Models/Rental/rental_model.dart';
import 'package:rental_room_app/Models/User/user_model.dart';

abstract class DetailRoomContract {
  void onCommentPosted();
  void onGetRental(Rental? rental);
  void onSetReceiptStatus(String status);
  void onGetTenant(Users? user);
  void onLoading();
  void onPop();
  void onRoutingToHome();
  void onDeleteRoomSuccess();
  void onDeleteRoomFailed();
}
