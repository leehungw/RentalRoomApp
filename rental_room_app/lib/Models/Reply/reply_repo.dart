import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_room_app/Models/Reply/reply_model.dart';

abstract class ReplyRepository {
  Future<void> uploadReply(Reply reply);
  Future<List<Reply>> getAllRepliesByCommentId(String commentId);
}

class ReplyRepositoryIml implements ReplyRepository {
  @override
  Future<List<Reply>> getAllRepliesByCommentId(String commentId) async {
    List<Reply> replies = [];
    await FirebaseFirestore.instance
        .collection(Reply.documentId)
        .where("commentId", isEqualTo: commentId)
        .get()
        .then(
      (querySnapshot) {
        for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
          replies.add(Reply.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error get all replies by commentId: $e"),
    );
    return replies;
  }

  @override
  Future<void> uploadReply(Reply reply) async {
    await FirebaseFirestore.instance
        .collection(Reply.documentId)
        .add(reply.toJson());
  }
}
