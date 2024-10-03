abstract class CreateRoomContract {
  void onCreateSucceeded();
  void onCreateFailed();
  void onChangeProfilePicture(String pickedImage);
  void onWaitingProgressBar();
  void onPopContext();
}
