import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/YourRoom/detail_room_contract.dart';
import 'package:rental_room_app/Models/Comment/comment_model.dart';
import 'package:rental_room_app/Models/Comment/comment_repo.dart';
import 'package:rental_room_app/Models/User/user_repo.dart';

class DetailRoomPresenter {
  // ignore: unused_field
  final DetailRoomContract? _view;
  DetailRoomPresenter(this._view);

  final CommentRepository _commentRepository = CommentRepositoryIml();
  final UserRepository _userRepository = UserRepositoryIml();

  String? validateComment(String? content) {
    content = content?.trim();
    if (content != null) {
      if (content.isNotEmpty) {
        return null;
      }
      return "Please write something!";
    }
    return "Please write somthing!";
  }

  void postCommentButtonPressed(String roomId, String content, double rating) {
    content = content.trim();
    Comment comment = Comment(
        content: content,
        rating: rating,
        roomId: roomId,
        userId: FirebaseAuth.instance.currentUser!.uid,
        time: DateTime.now());
    _commentRepository.uploadComment(comment);
    FirebaseAnalytics.instance.logEvent(
        name: "user_rated_room",
        parameters: {"roomId": roomId, "rating": rating});
    if (rating >= 4) {
      _userRepository.updateLatestTappedRoom(roomId);
    }
    _view?.onCommentPosted();
  }

  void logTappedRoomEvent(String roomId) {
    FirebaseAnalytics.instance
        .logEvent(name: "user_tapped_room", parameters: {"roomId": roomId});
  }

  void updateLatestTappedRoom(String roomId) {
    _userRepository.updateLatestTappedRoom(roomId);
  }
}
