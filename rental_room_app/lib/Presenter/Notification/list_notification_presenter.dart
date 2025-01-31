import 'package:rental_room_app/Contract/Notification/list_notification_contract.dart';
import 'package:rental_room_app/Models/Room/room_repo.dart';

class ListNotificationPresenter {
  final ListNotificationContract? _view;
  ListNotificationPresenter(this._view);

  final RoomRepository _roomRepository = RoomRepositoryIml();

  void loadRoomInfo(String rentalID) async {
    if (rentalID.isNotEmpty) {
      _view?.onUpdateRoom(await _roomRepository.getRoomById(rentalID));
    }
  }
}
