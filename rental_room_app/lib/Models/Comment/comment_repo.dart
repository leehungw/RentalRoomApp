import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_room_app/Models/Comment/comment_model.dart';

abstract class CommentRepository {
  Future<void> uploadComment(Comment comment);
  Future<List<Comment>> getAllCommentsbyRoomId(String roomId);
}

class CommentRepositoryIml implements CommentRepository {
  @override
  Future<List<Comment>> getAllCommentsbyRoomId(String roomId) async {
    List<Comment> comments = [];
    await FirebaseFirestore.instance
        .collection(Comment.documentId)
        .where("roomId", isEqualTo: roomId)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          comments.add(Comment.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error get all comments by roomId: $e"),
    );
    return comments;
  }

  @override
  Future<void> uploadComment(Comment comment) async {
    await FirebaseFirestore.instance
        .collection(Comment.documentId)
        .add(comment.toJson());
  }
}
