import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:daleel/utils/basic_video_player.dart';

class ARNavigationScreen extends StatefulWidget {
  final String? walkTime;
  final String? distance;

  const ARNavigationScreen({super.key, this.walkTime, this.distance});

  @override
  State<ARNavigationScreen> createState() => _ARNavigationScreenState();
}

class _ARNavigationScreenState extends State<ARNavigationScreen> {
  late VideoPlayerController _controller;
  bool _hasError = false;
  bool _isInitializing = true;
  bool _useStaticFallback = false;
  bool _tryingBasicPlayer = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }
  
  void _initializeVideoPlayer() {
    try {
      print('Platform: ${Platform.operatingSystem}');
      print('Platform version: ${Platform.operatingSystemVersion}');
      print('Initializing AR video player');
      
      if (Platform.isMacOS) {
        setState(() {
          _tryingBasicPlayer = true;
          _isInitializing = false;
        });
        return;
      }
      
      _controller = VideoPlayerController.asset('assets/videos/AR.MP4');
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
          _controller.play();
          _controller.setLooping(true);
        }
      }).catchError((error) {
        print('Video player initialization error: $error');
        if (mounted) {
          setState(() {
            _hasError = true;
            _isInitializing = false;
            _errorMessage = 'Failed to initialize video player: $error';
          });
        }
      });
    } catch (e) {
      print('Video player creation error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitializing = false;
          _errorMessage = 'Could not create video player: $e';
        });
      }
    }
  }

  void _switchToStaticFallback() {
    setState(() {
      _useStaticFallback = true;
      _hasError = false;
    });
  }

  @override
  void dispose() {
    if (!_tryingBasicPlayer) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: _tryingBasicPlayer
                ? BasicVideoPlayer(
                    assetPath: 'assets/videos/AR.MP4',
                    onError: (String message) {
                      setState(() {
                        _hasError = true;
                        _errorMessage = message;
                        _tryingBasicPlayer = false;
                      });
                    },
                  )
                : _hasError
                    ? _buildErrorDisplay()
                    : _useStaticFallback
                        ? _buildStaticFallback()
                        : _isInitializing
                            ? const Center(child: CircularProgressIndicator())
                            : _controller.value.isInitialized
                                ? FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _controller.value.aspectRatio * MediaQuery.of(context).size.height,
                                      height: MediaQuery.of(context).size.height,
                                      child: VideoPlayer(_controller),
                                    ),
                                  )
                                : const Center(child: CircularProgressIndicator()),
          ),

          if (!_hasError && (_controller.value.isInitialized || _useStaticFallback || _tryingBasicPlayer)) ...[
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  () {
                    final parts = <String>[];
                    if (widget.distance != null) parts.add(widget.distance!);
                    if (widget.walkTime != null) parts.add(widget.walkTime!);
                    if (parts.isEmpty) {
                      return 'المسافة: ١٨م - ١ دقيقة';
                    }
                    return parts.join(' - ');
                  }(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),

            Positioned(
              bottom: 100,
              left: 20,
              child: Container(
                width: 140,
                height: 160,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/map.png',
                        fit: BoxFit.cover,
                      ),
                  
                      Positioned(
                        left: 100,
                        top: 60,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      
                      Positioned(
                        left: 70,
                        top: 30,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                      
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'الخريطة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map_outlined),
                label: const Text('العودة للخريطة'),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStaticFallback() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/map.png',
          fit: BoxFit.cover,
        ),
        
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'تجربة الواقع المعزز محاكاة، غير متاحة بالكامل على هذا الجهاز.',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildErrorDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              _errorMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('العودة للخريطة'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _switchToStaticFallback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('استخدام البديل'),
              ),
            ],
          )
        ],
      ),
    );
  }
} 