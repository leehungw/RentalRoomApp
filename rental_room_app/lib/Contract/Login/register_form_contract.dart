abstract class RegisterFormContract {
  void onRegisterSucceeded();
  void onRegisterFailed();
  void onChangeProfilePicture(String pickedImage);
  void onWaitingProgressBar();
  void onPopContext();
  void onFetchBankList(List<dynamic> bankList);
}
