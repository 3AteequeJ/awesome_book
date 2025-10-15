import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'package:awesome_book/Route/router.dart';
import 'package:awesome_book/utils/mybutton.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:http/http.dart' as http;

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
  bool isUploading = false;

  void handleUploadStory() async {
    setState(() => isUploading = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Txt(
                  text: "Uploading Story...",
                ),
              ],
            ),
          ),
        );
      },
    );

    bool success = await uploadStory_async(widget.mediaFile.path);

    if (context.mounted) {
      Navigator.pop(context); // Remove loader

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Story uploaded successfully!"),
            backgroundColor: Colors.green.shade900,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteGenerator
              .rt_home, // <-- Replace with your actual HomeScreen route name
          (route) => false,
        );
      }
    }

    setState(() => isUploading = false);
  }

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
                        handleUploadStory();
                        // uploadStory_async(widget.mediaFile.path);
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

  String? fileType;
  Future<bool> uploadStory_async(String path) async {
    try {
      // Check if file exists
      if (!await File(path).exists()) {
        if (context.mounted) {
          glb.errorToast(
              context, "File not found. Please select a file again.");
        }
        return false;
      }

      Uri url = Uri.parse(glb.API.UploadStory);

      // Get file info
      File file = File(path);
      int fileLength = await file.length();
      String fileName = path.split('/').last;
      String mimeType = fileType == "video" ? "video/mp4" : "image/jpeg";

      // Create a custom HTTP client to track upload progress
      var client = http.Client();
      var request = http.MultipartRequest('POST', url);

      // Add file to request
      var multipartFile = await http.MultipartFile.fromPath(
        'img',
        path,
      );

      request.files.add(multipartFile);
      request.fields['user_id'] = glb.userDetails.id;

      // Set up progress tracking
      var totalBytes = request.contentLength;
      var bytesSent = 0;

      // Create a custom ByteStream that reports progress
      var progressStream = http.ByteStream(
        file.openRead().transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              bytesSent += data.length;

              if (totalBytes != null && context.mounted) {
                setState(() {
                  // uploadProgress = bytesSent / totalBytes;
                });
              }

              sink.add(data);
            },
          ),
        ),
      );

      // Replace the file's stream with our progress-tracking stream
      request.files.clear();
      request.files.add(
        http.MultipartFile(
          'img',
          progressStream,
          fileLength,
          filename: fileName,
        ),
      );

      // Send the request
      final response = await request.send();

      // Get response body
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (responseBody == '1') {
          return true;
        } else {
          if (context.mounted) {
            glb.errorToast(context, "Server error: $responseBody");
          }
          return false;
        }
      } else {
        if (context.mounted) {
          glb.errorToast(
            context,
            "Server error: Status code ${response.statusCode}",
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        glb.errorToast(
          context,
          "Upload failed: ${e.toString().substring(0, Math.min(100, e.toString().length))}",
        );
      }
      print("Exception during upload: $e");
      return false;
    } finally {
      // Ensure we reset the uploading state if there's an exception
      if (context.mounted) {
        setState(() {
          // isUploading = false;
        });
      }
    }
  }
}
