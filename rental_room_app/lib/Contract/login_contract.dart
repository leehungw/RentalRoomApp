abstract class LoginViewContract {
  void onLoginFailed();
  void onLoginSucceeded();
  void onWaitingProgressBar();
  void onPopContext();
  void onForgotPasswordSent();
  void onForgotPasswordError(String errorMessage);
}
