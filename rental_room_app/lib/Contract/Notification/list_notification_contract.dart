import 'package:rental_room_app/Models/Room/room_model.dart';

abstract class ListNotificationContract {
  void onUpdateRoom(Room room);
}
