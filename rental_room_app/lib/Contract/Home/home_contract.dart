import 'package:rental_room_app/Models/Room/room_model.dart';

abstract class HomeContract {
  void updateView(String? userName, bool? isOwner, String? userAvatarUrl,
      String? email, String? rentalId);
  void onRecommendFailed();
  void onRecommendSuccess();
  void onUpdateYourRoom(Room yourRoom);
}
