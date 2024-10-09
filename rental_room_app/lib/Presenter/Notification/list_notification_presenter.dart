import 'package:rental_room_app/Contract/Notification/list_notification_contract.dart';

class ListNotificationPresenter {
  final ListNotificationContract? _view;
  ListNotificationPresenter(this._view);

  Future<void> _loadYourRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rentalID = prefs.getString('yourRoomId') ?? '';
    if (rentalID.isNotEmpty) {
      yourRoom = await RoomRepositoryIml().getRoomById(rentalID);
    }
  }

  List<Receipt> loadListReceipt(List<Receipt> list) {
    List<Receipt> newList = List.from(list);

    newList = list.where((element) => element.tenantID == uID).toList();
    newList.sort((a, b) => b.createdDay.compareTo(a.createdDay));
    return newList;
  }
}
