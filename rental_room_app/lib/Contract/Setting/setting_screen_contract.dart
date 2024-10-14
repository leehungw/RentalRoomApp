import 'package:rental_room_app/Models/Room/room_model.dart';

abstract class SettingScreenContract {
  void onLaunchEmailFailed();
  void onUpdateRoom(Room room);
}
