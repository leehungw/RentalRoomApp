abstract class EditRoomContract {
  void onEditSucceeded();
  void onEditFailed();
  void onChangeProfilePicture(String pickedImage);
  void onWaitingProgressBar();
  void onPopContext();
}
