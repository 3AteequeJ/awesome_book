import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_book/utils/mybutton.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

class AddStory_scrn extends StatefulWidget {
  final Uint8List img;
  final bool type; // true for image, false for video
  final File mediaFile;

  const AddStory_scrn({
    super.key,
    required this.img,
    required this.type,
    required this.mediaFile,
  });

  @override
  State<AddStory_scrn> createState() => _AddStory_scrnState();
}

class _AddStory_scrnState extends State<AddStory_scrn> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;
  bool _hasError = false;
  @override
  void initState() {
    // TODO: implement initState
    print("add stry = ${widget.img}");
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController.dispose();
    print("video AR => ${_videoController.value.aspectRatio}");
  }

  void _initializeVideoPlayer() async {
    try {
      // File correctedFile =
      //     await FlutterExifRotation.rotateImage(path: widget.mediaFile.path);
      setState(() {
        _isInitialized = false;
        _hasError = false;
      });
      print("file corrected");
      _videoController = VideoPlayerController.file(
        widget.mediaFile,
        // Uri.parse(
        //     "https://awesomebook.in/awesomebookbackend/public/images/post_videos/1_2025-02-24_11_27_29.mp4"),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: false,
        ),
      );

      _videoController.initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _videoController.value = _videoController.value;
        });
        _videoController.setLooping(true);
        _videoController.play();

        // Add listener for video progress
        // _videoController.addListener(_updateVideoProgress);
      }).catchError((error) {
        setState(() {
          _hasError = true;
          // _errorMessage = 'Failed to load video: ${error.toString()}';
          // print('Video player error: $_errorMessage');
        });
      });

      _videoController.addListener(() {
        if (_videoController.value.hasError) {
          setState(() {
            _hasError = true;
            // _errorMessage =
            //     'Video playback error: ${_controller.value.errorDescription}';
            // print('Video player error: $_errorMessage');
          });
        }
      });
    } catch (e) {
      print("Error correcting file: $e");
    }
  }

  filecorrection() async {
    print("correcting file");
    File correctedFile =
        await FlutterExifRotation.rotateImage(path: widget.mediaFile.path);
    print("corrected file = $correctedFile");
  }

  double scaleFactor = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.xmark),
          onPressed: () {
            // Navigator.pop(context);
            // showDialog(context: context, builder: builder)
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Txt(text: "Discard changes"),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Txt(text: "Cancel"),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Txt(text: "Discard"),
                      ),
                    ],
                  );
                });
          },
        ),
        flexibleSpace: Container(
          child:
              Image.asset(fit: BoxFit.cover, 'assets/images/bg_gradient.jpeg'),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w))),
            onPressed: () async {},
            child: Icon(
              CupertinoIcons.pen,
              // color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: widget.type
                  ? Image.memory(widget.img)
                  : _isInitialized
                      ? InkWell(
                          onTap: () {
                            filecorrection();
                          },
                          child: AspectRatio(
                              aspectRatio: _videoController.value.size.width >
                                      _videoController.value.size.height
                                  ? 16 / 9 // Landscape
                                  : 9 / 16, // Portrait
                              child: VideoPlayer(_videoController)),
                        )
                      : CircularProgressIndicator(),
            ),
          ),
          Container(
            height: 10.h,
            // color: Colors.red,
            child: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade900,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w))),
                    onPressed: () async {
                      final result = widget.type
                          ? await ImageGallerySaverPlus.saveImage(
                              widget.img,
                              quality: 100,
                              name:
                                  "CameraScrn_${DateTime.now().toIso8601String()}",
                            )
                          : await ImageGallerySaverPlus.saveFile(
                              widget.mediaFile.path);

                      if (result['isSuccess']) {
                        print(
                            "Edited image saved successfully at: ${result['filePath']}");
                      } else {
                        print("Failed to save edited image");
                        print('Error: Failed to save edited image to gallery.');
                      }
                    },
                    child: Icon(
                      CupertinoIcons.cloud_download,
                      color: Colors.white,
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Txt(text: "Add story"),
                  //       Icon(CupertinoIcons.chevron_right)
                  //     ],
                  //   ),
                  // )

                  MyButton(
                      wdt: 40.w,
                      foregroundColor: Colors.black,
                      borderRadius: 20,
                      required_widget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Txt(text: "Add story"),
                          Icon(
                            Icons.chevron_right,
                          )
                        ],
                      ),
                      on_tap: () {
                        // print('Image path: ${widget.image.path}');
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
