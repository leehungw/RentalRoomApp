import 'package:rental_room_app/Services/shared_preferences_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPresenter {
  // ignore: unused_field
  final SharedPreferencesContract? _view;
  SharedPreferencesPresenter(this._view);

  Future<void> getUserInfoFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('name');
    bool? isOwner = prefs.getBool('isOwner');
    String userAvatarUrl = prefs.getString('avatar') ?? '';
    String email = prefs.getString('email') ?? 'nguyenvana@gmail.com';
    String rentalID = prefs.getString('yourRoomId') ?? '';

    _view?.updateView(userName, isOwner, userAvatarUrl, email, rentalID);
  }
}
