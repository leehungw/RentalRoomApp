import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_room_app/Models/Chat/chat_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(ChatMessage message) async {
    String chatId = _getChatId(message.senderId, message.receiverId);
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<ChatMessage>> getMessages(String senderId, String receiverId) {
    String chatId = _getChatId(senderId, receiverId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  String _getChatId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2]..sort(); 
    return ids.join('_'); 
  }
}
