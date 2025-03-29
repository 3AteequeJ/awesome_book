import 'package:awesome_book/utils/colours.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StoriesCircle extends StatefulWidget {
  const StoriesCircle({
    super.key,
    required this.name,
  });
  final String name;
  @override
  State<StoriesCircle> createState() => _StoriesCircleState();
}

class _StoriesCircleState extends State<StoriesCircle> {
  void _openFullScreenImage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullScreenImage(imagePath: 'assets/images/post2.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openFullScreenImage,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 25.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple, Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
              Txt(text: widget.name == "Story 0" ? "Your story" : widget.name),
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatefulWidget {
  final String imagePath;

  const FullScreenImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late double _dragStart;
  late double _dragPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 1.0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStart = details.globalPosition.dy;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragPosition = details.globalPosition.dy;
    final dragDistance = _dragPosition - _dragStart;
    final screenHeight = MediaQuery.of(context).size.height;

    _controller.value = (dragDistance / screenHeight).clamp(0.0, 1.0);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.value > 0.25) {
      _controller.forward().then((_) {
        Navigator.of(context).pop();
      });
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // This container represents the underlying screen
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              GestureDetector(
                onVerticalDragStart: _handleDragStart,
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                child: Transform.translate(
                  offset: Offset(0,
                      MediaQuery.of(context).size.height * _animation.value.dy),
                  child: Opacity(
                    opacity: 1 - _controller.value,
                    child: Container(
                      color: Colors.black.withOpacity(1 - _controller.value),
                      child: Center(
                        child: Image.asset(widget.imagePath),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
