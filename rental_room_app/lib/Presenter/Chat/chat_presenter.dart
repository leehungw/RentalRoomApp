import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_room_app/Contract/Chat/chat_screen_contract.dart';
import 'package:rental_room_app/Models/Chat/chat_model.dart';
import 'package:rental_room_app/Models/Chat/chat_repo.dart';

class ChatPresenter implements ChatPresenterContract {
  final ChatScreenContract view;
  final ChatRepository repository;
  final String currentUserId =
      FirebaseAuth.instance.currentUser?.uid ?? "N/A_uid";
  final String receiverId;

  ChatPresenter({
    required this.view,
    required this.repository,
    required this.receiverId,
  });

  @override
  void sendMessage(String content, {String messageType = 'text'}) async {
    if (content.trim().isEmpty) {
      return;
    }

    try {
      ChatMessage chatMessage = ChatMessage(
        senderId: currentUserId,
        receiverId: receiverId,
        message: content,
        timestamp: DateTime.now(),
        messageType: messageType,
      );
      await repository.sendMessage(chatMessage);
    } catch (e) {
      view.showError("Failed to send message: $e");
    }
  }

  @override
  void sendMediaMessage(String filePath, String mediaType) async {
    try {
      final uploadedUrl = await repository.uploadMedia(filePath, mediaType);
      sendMessage(uploadedUrl, messageType: mediaType);
    } catch (e) {
      view.showError("Failed to send $mediaType: $e");
    }
  }

  @override
  void loadMessages() {
    repository.getMessages(currentUserId, receiverId).listen(
      (messages) {
        view.showMessages(messages);
      },
      onError: (error) {
        view.showError("Failed to load messages: $error");
      },
    );
  }
}

class ChatContract {}
