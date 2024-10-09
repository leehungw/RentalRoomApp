import 'package:rental_room_app/Contract/YourRoom/your_room_contract.dart';

class YourRoomPresenter {
  final YourRoomContract? _view;
  YourRoomPresenter(this._view);

  Future<void> _loadInfor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOwner = prefs.getBool('isOwner') ?? false;
    });
  }
}
