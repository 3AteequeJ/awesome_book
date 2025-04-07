import 'dart:io';

import 'package:awesome_book/widgets/mytext.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:http/http.dart' as http;

class UploadPost_scrn extends StatefulWidget {
  const UploadPost_scrn({super.key});

  @override
  State<UploadPost_scrn> createState() => _UploadPost_scrnState();
}

class _UploadPost_scrnState extends State<UploadPost_scrn> {
  TextEditingController _captionCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(
          text: '',
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 30.h,
            width: double.infinity,
            color: Colors.grey,
            child: Image.file(
              dataFile,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text("No image selected"));
              },
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                getFile();
              },
              child: Txt(text: "Select file")),
          Padding(
            padding: EdgeInsets.all(12.sp),
            child: TextField(
              controller: _captionCont,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.sp),
                ),
                hintText: "Caption",
                labelText: 'Caption',
              ),
            ),
          ),
          Expanded(child: Container()),
          ElevatedButton(
            onPressed: () {
              glb.ConfirmationBox(context, "You want to upload this data", () {
                Navigator.pop(context);
                if (context.mounted) {
                  glb.DonePopUp(context);
                }

                // Fetch data after confirmation

                Future<void> dataFuture = uploadPost_async(dataFile.path);
                glb.showLoadingDialog(context, dataFuture);
              });
            },
            child: Txt(text: "Upload"),
          )
        ],
      ),
    );
  }

  File dataFile = new File("");
  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      PlatformFile pickedFile = result.files.single;
      String? extension = await pickedFile.extension;
      print("extension = $extension");
      if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
        print("Selected file is an IMAGE");
      } else if (['mp4', 'avi', 'mov', 'mkv', 'flv']
          .contains(extension.toString())) {
        print("Selected file is a VIDEO");
      } else {
        print("Unknown file type");
      }
      setState(() {
        dataFile = file;
      });
    } else {
      // User canceled the picker
    }
  }

  uploadPost_async(String path) async {
    print("uploading");
    Uri url = Uri.parse(glb.API.UploadPost);

    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath(
      'img', // The field name on the server
      path.toString(),
    ));
    request.fields['user_id'] = glb.userDetails.id;
    if (_captionCont.text.isNotEmpty) {
      request.fields['caption'] = _captionCont.text.trim();
    }

    // print(request.files.n);
    try {
      final response = await request.send();
      String body = await response.stream.bytesToString();
      print(body);
      if (body == '1') {
        setState(() {
          dataFile = File("");
          _captionCont.clear();
        });
        return 1;
        // glb.DonePopUp(context);
        // Navigator.pop(context);
      }
      // print("bdy = ${response.body}")
    } catch (e) {
      print("Exception ==> $e");
    }
  }
}
