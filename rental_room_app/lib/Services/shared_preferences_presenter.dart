import 'package:rental_room_app/Models/Rental/rental_repo.dart';
import 'package:rental_room_app/Services/shared_preferences_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPresenter {
  // ignore: unused_field
  final SharedPreferencesContract? _view;
  SharedPreferencesPresenter(this._view);

  final _rentalRepository = RentalRepositoryIml();

  Future<void> getUserInfoFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('name');
    bool? isOwner = prefs.getBool('isOwner');
    String userAvatarUrl = prefs.getString('avatar') ?? '';
    String email = prefs.getString('email') ?? 'nguyenvana@gmail.com';
    String rentalID = await _rentalRepository.getRentalId();


    _view?.updateView(userName, isOwner, userAvatarUrl, email, rentalID);
  }
}
