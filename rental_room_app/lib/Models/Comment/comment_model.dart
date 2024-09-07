import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  static const String documentId = 'Comment';

  String commentId;
  String roomId;
  String userId;
  String content;
  double rating;
  DateTime time;

  Comment(
      {this.commentId = '',
      required this.roomId,
      required this.userId,
      required this.content,
      required this.rating,
      required this.time});

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'userId': userId,
      'content': content,
      'rating': rating,
      'time': time
    };
  }

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data['time'];

    return Comment(
        commentId: doc.id,
        roomId: data['roomId'],
        userId: data['userId'],
        content: data['content'],
        rating: data['rating'],
        time: timestamp.toDate());
  }
}
