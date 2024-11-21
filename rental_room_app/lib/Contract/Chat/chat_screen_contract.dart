import 'package:rental_room_app/Models/Chat/chat_model.dart';

abstract class ChatScreenContract {
  void showMessages(List<ChatMessage> messages);
  void showError(String error);
}

abstract class ChatPresenterContract {
  void sendMessage(String message);
  void loadMessages();
}
