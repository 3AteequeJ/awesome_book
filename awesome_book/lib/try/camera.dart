import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoRecorderScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const VideoRecorderScreen({super.key, required this.cameras});

  @override
  _VideoRecorderScreenState createState() => _VideoRecorderScreenState();
}

class _VideoRecorderScreenState extends State<VideoRecorderScreen> {
  late CameraController _controller;
  bool _isRecording = false;
  String? _videoPath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (!_controller.value.isRecordingVideo) {
      final directory = await getTemporaryDirectory();
      final videoFile = File('${directory.path}/video.mp4');

      await _controller.startVideoRecording();
      setState(() {
        _isRecording = true;
        _videoPath = videoFile.path;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_controller.value.isRecordingVideo) {
      await _controller.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Video Recorder")),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  backgroundColor: _isRecording ? Colors.red : Colors.blue,
                  child: Icon(_isRecording ? Icons.stop : Icons.videocam),
                ),
                if (_videoPath != null)
                  FloatingActionButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPreviewScreen(videoPath: _videoPath!),
                      ),
                    ),
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.play_arrow),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;
  const VideoPreviewScreen({super.key, required this.videoPath});

  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  VideoPlayerController? _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // Check if file exists
    if (!File(widget.videoPath).existsSync()) {
      print("❌ Error: Video file not found at ${widget.videoPath}");
      return;
    }

    try {
      _videoController = VideoPlayerController.file(File(widget.videoPath))
        ..initialize().then((_) {
          setState(() {}); // Refresh UI when video is ready
        }).catchError((error) {
          print("❌ Error initializing video: $error");
        });
    } catch (e) {
      print("❌ Exception: $e");
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Video")),
      body: Center(
        child: _videoController != null && _videoController!.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: _videoController!.value.size.width,
                        height: _videoController!.value.size.height,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isPlaying
                            ? _videoController!.pause()
                            : _videoController!.play();
                        _isPlaying = !_isPlaying;
                      });
                    },
                    backgroundColor: Colors.blue,
                    child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
