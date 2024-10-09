import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/Login/change_password_contract.dart';

class ChangePasswordPresenter implements ChangePasswordPresenterContract {
  final ChangePasswordContract _view;

  ChangePasswordPresenter(this._view);

  String? validatePassword(String? value) {
    return null;
  }

  @override
  void validateAndChangePassword(String oldPassword, String newPassword,
      String confirmPassword, String email) async {
    // Clear previous errors
    _view.showProgress();

    if (newPassword.length < 6) {
      _view.hideProgress();
      _view.onChangePasswordError(
          "New password must be at least 6 characters long.");
      return;
    }

    if (newPassword != confirmPassword) {
      _view.hideProgress();
      _view.onChangePasswordError("Confirm password does not match.");
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: oldPassword);
        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);
        _view.hideProgress();
        _view.onChangePasswordSuccess("Password changed successfully.");
      } catch (error) {
        _view.hideProgress();
        _view.onChangePasswordError(
            "Old password is incorrect or update failed.");
      }
    }
  }

  @override
  void dispose() {}
}
