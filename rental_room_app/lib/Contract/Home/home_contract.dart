abstract class HomeContract {
  void updateView(String? userName, bool? isOwner, String? userAvatarUrl, String? email, String? rentalId);
  void onRecommendFailed();
  void onRecommendSuccess();
}
