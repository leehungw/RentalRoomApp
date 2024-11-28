import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChatVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isMe;

  const ChatVideoPlayer({Key? key, required this.videoUrl, required this.isMe})
      : super(key: key);

  @override
  State<ChatVideoPlayer> createState() => _ChatVideoPlayerState();
}

class _ChatVideoPlayerState extends State<ChatVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = _controller.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
        bottomLeft: widget.isMe ? const Radius.circular(12) : Radius.zero,
        bottomRight: widget.isMe ? Radius.zero : const Radius.circular(12),
      ),
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: Container(
          color: Colors.black, // Background for videos before initialization
          child: _controller.value.isInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    if (!_isPlaying)
                      const Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 50,
                      ),
                  ],
                )
              : Container(
                  height: 200, // Set height for loading placeholder
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }
}
