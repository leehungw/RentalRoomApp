abstract class ChangePasswordContract {
  void onChangePasswordSuccess(String message);
  void onChangePasswordError(String error);
  void showProgress();
  void hideProgress();
}

abstract class ChangePasswordPresenterContract {
  void validateAndChangePassword(String oldPassword, String newPassword, String confirmPassword, String email);
  void dispose();
}
