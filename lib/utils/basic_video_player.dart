import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class BasicVideoPlayer extends StatefulWidget {
  final String assetPath;
  final Function onError;
  
  const BasicVideoPlayer({
    Key? key, 
    required this.assetPath,
    required this.onError,
  }) : super(key: key);

  @override
  State<BasicVideoPlayer> createState() => _BasicVideoPlayerState();
}

class _BasicVideoPlayerState extends State<BasicVideoPlayer> {
  bool _isLoading = true;
  bool _hasError = false;
  late VideoPlayerController _controller;
  bool _useImageFallback = false;
  
  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }
  
  void _initializePlayer() {
    try {
      print('Initializing basic video player for: ${widget.assetPath}');
      if (Platform.isMacOS) {
        print('On macOS: Using image fallback to simulate video');
        setState(() {
          _useImageFallback = true;
          _isLoading = false;
        });
        return;
      }
      
      _controller = VideoPlayerController.asset(widget.assetPath);
      
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _controller.play();
          _controller.setLooping(true);
        }
      }).catchError((error) {
        print('Basic video player error: $error');
        setState(() {
          _useImageFallback = true;
          _isLoading = false;
        });
      });
    } catch (e) {
      print('Video player creation error: $e');
      setState(() {
        _useImageFallback = true;
        _isLoading = false;
      });
    }
  }
  
  @override
  void dispose() {
    if (!_useImageFallback) {
      _controller.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
        ),
      );
    }
    
    if (_useImageFallback) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/ar_simulation.jpg', 
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/map.png',
                fit: BoxFit.cover,
              );
            },
          ),
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'AR المسافة: ١٥م',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      );
    }
    
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
} 