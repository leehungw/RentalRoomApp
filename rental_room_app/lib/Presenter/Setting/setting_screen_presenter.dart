import 'package:rental_room_app/Contract/Setting/setting_screen_contract.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Models/Room/room_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreenPresenter {
  SettingScreenContract? _view;
  SettingScreenPresenter(this._view);

  final RoomRepository _roomRepository = RoomRepositoryIml();

  Future<Room?> loadRoomInfo(String rentalID) async {
    if (rentalID.isNotEmpty) {
      return await _roomRepository.getRoomById(rentalID);
    }
    return null;
  }

  Future<void> launchEmailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'personalschedulemanager@gmail.com',
      queryParameters: {
        'subject': 'Góp_Ý_Của_Người_Dùng',
      },
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      _view?.onLaunchEmailFailed();
    }
  }
}
