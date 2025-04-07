import 'dart:async';
import 'package:flutter/material.dart';

class StoryViewer extends StatefulWidget {
  final List<Map<String, dynamic>> stories;
  final int currentIndex;

  StoryViewer({required this.stories, required this.currentIndex});

  @override
  _StoryViewerState createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentIndex < widget.stories.length - 1) {
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        timer.cancel();
        Navigator.pop(context);
      }
    });
  }

  void _onTapRight() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      Navigator.pop(context);
    }
  }

  void _onTapLeft() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _onLongPress() {
    _timer?.cancel();
  }

  void _onLongPressEnd() {
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.stories.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                widget.stories[index]["image"],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          GestureDetector(
            onTapUp: (details) {
              final width = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx > width / 2) {
                _onTapRight();
              } else {
                _onTapLeft();
              }
            },
            onLongPress: _onLongPress,
            onLongPressUp: _onLongPressEnd,
          ),
        ],
      ),
    );
  }
}
