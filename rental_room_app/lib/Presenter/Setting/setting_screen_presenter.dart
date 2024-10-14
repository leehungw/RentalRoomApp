import 'package:rental_room_app/Contract/Setting/setting_screen_contract.dart';
import 'package:rental_room_app/Models/Room/room_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreenPresenter {
  final SettingScreenContract? _view;
  SettingScreenPresenter(this._view);

  final RoomRepository _roomRepository = RoomRepositoryIml();

  void loadRoomInfo(String rentalID) async {
    if (rentalID.isNotEmpty) {
      _view?.onUpdateRoom(await _roomRepository.getRoomById(rentalID));
    }
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
