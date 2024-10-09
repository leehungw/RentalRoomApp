abstract class HomeContract {
  void updateView(String? userName, bool? isOwner, String? userAvatarUrl, String? email);
  void onRecommendFailed();
  void onRecommendSuccess();
}
