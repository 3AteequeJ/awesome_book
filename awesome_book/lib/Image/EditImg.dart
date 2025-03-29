import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditScreen extends StatefulWidget {
  final String imagePath;
  final Uint8List img;
  const EditScreen({Key? key, required this.imagePath, required this.img})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> with TickerProviderStateMixin {
  bool cropping = false;
  double aspectRatio = 1.0;

  ImageEditorOption editorOption = ImageEditorOption();
  List<TextOverlay> textOverlays = [];
  Uint8List? _editedImage;

  Future<void> applyEdits() async {
    final editedImage = await ImageEditor.editImage(
      image: _editedImage ?? widget.img,
      imageEditorOption: editorOption,
    );
    setState(() {
      _editedImage = editedImage;
    });
  }

  @override
  void initState() {
    super.initState();
    _editedImage = widget.img;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showTextInputDialog() {
    TextEditingController textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Text'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: "Enter text"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                _addTextOverlay(textController.text);
                await applyEdits();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _addTextOverlay(String text) {
    setState(() {
      textOverlays.add(TextOverlay(
        text: text,
        position: Offset(50, 50),
        scale: 1.0,
      ));
    });
  }

  late AnimationController _controller;
  Offset _dragOffset = Offset.zero;
  double _previousScale = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Photo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, _editedImage);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _editedImage != null
                ? Stack(
                    children: [
                      // Display the image without scaling
                      Image.memory(_editedImage!),
                      // Display text overlays with scaling and draggable positioning
                      ...textOverlays.map((textOverlay) {
                        double fontSize = 20 * textOverlay.scale;

                        return Positioned(
                          left: textOverlay.position.dx,
                          top: textOverlay.position.dy,
                          child: GestureDetector(
                            onScaleStart: (details) {
                              _dragOffset = textOverlay
                                  .position; // Track the starting position
                            },
                            onScaleUpdate: (details) {
                              setState(() {
                                if ((details.scale - 1.0).abs() > 0.01) {
                                  // Smooth scale animation
                                  textOverlay.scale =
                                      (textOverlay.scale * details.scale)
                                          .clamp(0.5, 5.0);
                                } else {
                                  // Smooth position animation
                                  _dragOffset += details.focalPointDelta;
                                  textOverlay.position = Offset(
                                    _dragOffset.dx.clamp(
                                        0.0,
                                        MediaQuery.of(context).size.width -
                                            100),
                                    _dragOffset.dy.clamp(
                                        0.0,
                                        MediaQuery.of(context).size.height -
                                            50),
                                  );
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              transform: Matrix4.identity()
                                ..scale(textOverlay.scale),
                              child: Text(
                                textOverlay.text,
                                style: TextStyle(
                                  backgroundColor: Colors.black,
                                  color: Colors.white,
                                  fontSize: fontSize,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                      offset: Offset(1.0, 1.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          // Toolbar for editing actions
          Visibility(
            visible: !cropping,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.crop),
                  onPressed: () {
                    setState(() {
                      cropping = true;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.rotate_left),
                  onPressed: () {
                    editorOption.addOption(RotateOption(90));
                    applyEdits();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.flip),
                  onPressed: () {
                    editorOption.addOption(FlipOption(horizontal: true));
                    applyEdits();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.text_fields),
                  onPressed: _showTextInputDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextOverlay {
  String text;
  Offset position;
  double scale;

  TextOverlay({
    required this.text,
    required this.position,
    required this.scale,
  });
}
