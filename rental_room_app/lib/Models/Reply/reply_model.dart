import 'package:cloud_firestore/cloud_firestore.dart';

class Reply {
  static const String documentId = 'Reply';

  String commentId;
  String userId;
  String content;
  DateTime time;

  Reply(
      {required this.commentId,
      required this.userId,
      required this.content,
      required this.time});

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'content': content,
      'time': time
    };
  }

  factory Reply.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data['time'];

    return Reply(
        commentId: data['commentId'],
        userId: data['userId'],
        content: data['content'],
        time: timestamp.toDate());
  }
}
