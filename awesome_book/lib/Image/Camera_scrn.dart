import 'dart:io';

import 'package:awesome_book/Image/addStory.dart';
import 'package:awesome_book/try/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:awesome_book/Image/EditImg.dart' as editImg;
import 'package:awesome_book/try.dart' as custom;
import 'package:awesome_book/try.dart' hide AspectRatio;
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CameraScrn extends StatefulWidget {
  const CameraScrn({Key? key}) : super(key: key);

  @override
  State<CameraScrn> createState() => _CameraScrnState();
}

class _CameraScrnState extends State<CameraScrn> with WidgetsBindingObserver {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  int selectedCameraIdx = 0;
  File? imageFile;
  File? videoFile;
  bool isRecording = false;
  bool isRearCameraSelected = true;
  FlashMode flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeCamera();
    }
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw CameraException(
            'No cameras', 'No cameras available on this device');
      }
      await onNewCameraSelected(cameras[selectedCameraIdx]);
    } on CameraException catch (e) {
      // _showErrorDialog(e.description);
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    try {
      await cameraController.initialize();
      await cameraController.setFlashMode(flashMode);
    } on CameraException catch (e) {
      // _showErrorDialog(e.description);
      return;
    }

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Inside your captureImage method in main.dart
  Future<void> captureImage() async {
    if (controller == null || !controller!.value.isInitialized) {
      _showErrorDialog('Error: select a camera first.');
      return;
    }

    try {
      final image = await controller!.takePicture();
      final originalImage = File(image.path);

      // Check if the current camera is the front camera
      if (cameras[selectedCameraIdx].lensDirection ==
          CameraLensDirection.front) {
        // Read image bytes and decode it
        final imageBytes = await originalImage.readAsBytes();
        final decodedImage = img.decodeImage(imageBytes);

        if (decodedImage != null) {
          // Flip the image horizontally
          final flippedImage = img.flipHorizontal(decodedImage);

          // Save the flipped image back to the file
          final flippedBytes = img.encodeJpg(flippedImage);
          await originalImage.writeAsBytes(flippedBytes);

          print(
              "Front camera image saved with horizontal flip at: ${image.path}");
        }
      }

      // Navigate to the edit screen with the saved image path
      var a = await originalImage.readAsBytes();
      final res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddStory_scrn(
            img: a,
            type: true,
            mediaFile: originalImage,
          ),
        ),
      );

      if (res != null) {
        final result = await ImageGallerySaverPlus.saveImage(
          res,
          quality: 100,
          name: "CameraScrn_${DateTime.now().toIso8601String()}",
        );

        if (result['isSuccess']) {
          print("Edited image saved successfully at: ${result['filePath']}");
        } else {
          print("Failed to save edited image");
          _showErrorDialog('Error: Failed to save edited image to gallery.');
        }
      }
    } on CameraException catch (e) {
      _showErrorDialog('Camera Error: ${e.description}');
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
  }

  Future<void> startVideoRecording() async {
    if (controller == null || !controller!.value.isInitialized) {
      _showErrorDialog('Error: select a camera first.');
      return;
    }

    if (controller!.value.isRecordingVideo) {
      return;
    }

    try {
      await controller!.startVideoRecording();
      setState(() {
        isRecording = true;
      });
    } on CameraException catch (e) {
      _showErrorDialog('Error: ${e.description}');
      return;
    }
  }

  Future<void> stopVideoRecording() async {
    if (controller == null || !controller!.value.isRecordingVideo) {
      return;
    }

    try {
      final video = await controller!.stopVideoRecording();
      final directory = await getTemporaryDirectory();
      final videoPath =
          '${directory.path}/${DateTime.now().toIso8601String()}.mp4';
      await video.saveTo(videoPath);

      final videoFile1 = File(videoPath);
      var a = await videoFile1.readAsBytes();
      // final res = await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => VideoPreviewScreen(videoPath: videoPath)),
      // );
      final res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddStory_scrn(
            img: a,
            type: false, mediaFile: videoFile1,
            // image: image,
          ),
        ),
      );
      setState(() {
        isRecording = false;
        videoFile = File(videoPath);
      });
      if (res != null) {
        final result = await ImageGallerySaverPlus.saveFile(
            videoPath); // Correct way to save the video file
        if (result['isSuccess']) {
          print("Video saved successfully at: $videoPath");
        } else {
          print("Failed to save video");
          _showErrorDialog('Error: Failed to save video to gallery.');
        }
      }
    } on CameraException catch (e) {
      _showErrorDialog('Error: ${e.description}');
      return;
    }
  }

  void onFlashModeButtonPressed() {
    if (flashMode == FlashMode.off) {
      setFlashMode(FlashMode.auto);
    } else if (flashMode == FlashMode.auto) {
      setFlashMode(FlashMode.always);
    } else if (flashMode == FlashMode.always) {
      setFlashMode(FlashMode.torch);
    } else {
      setFlashMode(FlashMode.off);
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }
    try {
      await controller!.setFlashMode(mode);
      setState(() {
        flashMode = mode;
      });
    } on CameraException catch (e) {
      _showErrorDialog('Error: ${e.description}');
      rethrow;
    }
  }

  Widget _buildCameraPreview() {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    bool isFrontCamera =
        controller!.description.lensDirection == CameraLensDirection.front;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateX(
            isFrontCamera ? math.pi : 0), // Flip the preview for front camera
      child: AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: CameraPreview(controller!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.white.withOpacity(.5),
      //   title: const Text('Camera Screen'),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.amber,
                child: RotatedBox(
                    quarterTurns: isRearCameraSelected ? 1 : 3,
                    child: _buildCameraPreview()),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 15.h,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        flashMode == FlashMode.off
                            ? Icons.flash_off
                            : flashMode == FlashMode.auto
                                ? Icons.flash_auto
                                : flashMode == FlashMode.always
                                    ? Icons.flash_on
                                    : Icons.highlight,
                        color: Colors.white,
                      ),
                      onPressed: onFlashModeButtonPressed,
                    ),
                    GestureDetector(
                      onTap: isRecording ? stopVideoRecording : captureImage,
                      onLongPress: () => startVideoRecording(),
                      onLongPressUp: () => stopVideoRecording(),
                      child: Container(
                        height: 10.h,
                        width: 10.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 5),
                          color: isRecording ? Colors.red : Colors.transparent,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios,
                          color: Colors.white),
                      onPressed: () {
                        setState(() {
                          selectedCameraIdx = selectedCameraIdx == 0 ? 1 : 0;
                          isRearCameraSelected = !isRearCameraSelected;
                        });
                        onNewCameraSelected(cameras[selectedCameraIdx]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
