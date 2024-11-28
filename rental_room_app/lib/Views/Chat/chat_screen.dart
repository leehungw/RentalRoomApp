import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_room_app/Contract/Chat/chat_screen_contract.dart';
import 'package:rental_room_app/Models/Chat/chat_model.dart';
import 'package:rental_room_app/Models/Chat/chat_repo.dart';
import 'package:rental_room_app/Presenter/Chat/chat_presenter.dart';
import 'package:rental_room_app/Views/Chat/Subviews/chat_video_player.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;

  const ChatScreen({super.key, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> implements ChatScreenContract {
  late ChatPresenter presenter;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  String currentUid = FirebaseAuth.instance.currentUser!.uid;

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    presenter = ChatPresenter(
      view: this,
      repository: ChatRepository(),
      receiverId: widget.receiverId,
    );
    presenter.loadMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<String?> _pickEmoji() async {
    String? selectedEmoji;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return EmojiPicker(
          onEmojiSelected: (category, emoji) {
            selectedEmoji = emoji.emoji;
            Navigator.pop(context);
          },
        );
      },
    );
    return selectedEmoji;
  }

  final ImagePicker _picker = ImagePicker();

  Future<String?> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // Use ImageSource.camera for camera
        maxWidth: 1024, // Resize the image to reduce size
        maxHeight: 1024,
        imageQuality: 80, // Compression quality
      );
      return pickedFile?.path; // Return the file path
    } catch (e) {
      showError("Failed to pick image: $e");
      return null;
    }
  }

  Future<String?> _pickVideo() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery, // Use ImageSource.camera for camera
        maxDuration: const Duration(minutes: 5), // Set max duration
      );
      return pickedFile?.path; // Return the file path
    } catch (e) {
      showError("Failed to pick video: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF38A3A5);
    const Color secondaryColor = Color(0xFF57CC99);
    const Color backgroundColor = Color(0xFFF6F6F6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Chat',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == currentUid;

                Widget messageContent;

                switch (message.messageType) {
                  case 'image':
                    messageContent =
                        Image.network(message.message, fit: BoxFit.cover);
                    break;
                  case 'video':
                    messageContent = ChatVideoPlayer(videoUrl: message.message, isMe: isMe);
                    break;
                  case 'emoji':
                    messageContent = Text(
                      message.message,
                      style: const TextStyle(fontSize: 32),
                    );
                    break;
                  default:
                    messageContent = Text(
                      message.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    );
                }

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? primaryColor : secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: messageContent,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.grey),
                  onPressed: () async {
                    final pickedImage = await _pickImage();
                    if (pickedImage != null) {
                      presenter.sendMediaMessage(pickedImage, 'image');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.video_call, color: Colors.grey),
                  onPressed: () async {
                    final pickedVideo = await _pickVideo();
                    if (pickedVideo != null) {
                      presenter.sendMediaMessage(pickedVideo, 'video');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_emotions, color: Colors.grey),
                  onPressed: () async {
                    final emoji =
                        await _pickEmoji(); // Implement your emoji picker
                    if (emoji != null) {
                      presenter.sendMessage(emoji, messageType: 'emoji');
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      presenter.sendMessage(
                        _messageController.text,
                        messageType: 'text',
                      );
                      _messageController.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void showMessages(List<ChatMessage> messages) {
    if (mounted) {
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
      });
    }

    _scrollToBottom();
  }

  @override
  void showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}
