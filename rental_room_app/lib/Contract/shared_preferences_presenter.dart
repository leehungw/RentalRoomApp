import 'package:rental_room_app/Models/User/user_model.dart';

abstract class SharedPreferencesContract {
  void updateView(
      String? userName, bool? isOwner, String? userAvatarUrl, String? email);
}
