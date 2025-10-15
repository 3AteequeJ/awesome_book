import 'package:awesome_book/models/stories_model.dart';
import 'package:awesome_book/utils/colours.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:http/http.dart' as http;

class StoriesCircle extends StatefulWidget {
  const StoriesCircle({
    super.key,
    required this.name,
    required this.idx,
    required this.storyUsers,
  });
  final String name;
  final int idx;
  final List<StoryUser> storyUsers;
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
      // onTap: _openFullScreenImage,
      onTap: () {
        // print("wwwwwwwwwww");
        // print(
        //     widget.storyUsers[widget.idx].stories.any((s) => s.viewed == '0'));
        // print("\n\n\n");
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => StoryView(
              initialUserIndex: widget.idx,
              users: widget.storyUsers,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
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
                      colors: widget.storyUsers[widget.idx].stories
                              .any((s) => s.viewed == '0')
                          ? [Colors.blue, Colors.purple, Colors.red]
                          : [Colors.black, Colors.grey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Container(
                      height: 20.w,
                      width: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              widget.storyUsers[widget.idx].userImage,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              Txt(text: widget.storyUsers[widget.idx].username.trim()),
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

class StoryView extends StatefulWidget {
  final int initialUserIndex;
  final List<StoryUser> users;

  const StoryView({
    Key? key,
    required this.initialUserIndex,
    required this.users,
  }) : super(key: key);

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView>
    with SingleTickerProviderStateMixin {
  late PageController _userPageController;
  late AnimationController _animationController;
  int _currentUserIndex = 0;
  int _currentStoryIndex = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    _currentUserIndex = widget.initialUserIndex;
    _userPageController = PageController(initialPage: _currentUserIndex);
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    ViewStory_async();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _nextStory();
      }
    });

    _loadStory();
  }

  ViewStory_async() async {
    Uri url = Uri.parse(glb.API.ViewStory);

    var res = await http.post(url, body: {
      'story_id':
          widget.users[_currentUserIndex].stories[_currentStoryIndex].storyId,
      'user_id': glb.userDetails.id,
    });
    setState(() {
      widget.users[_currentUserIndex].stories[_currentStoryIndex].viewed = '1';
    });
  }

  @override
  void dispose() {
    _userPageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadStory() {
    _animationController.forward();
  }

  void _nextStory() {
    ViewStory_async();
    StoryUser currentUser = widget.users[_currentUserIndex];

    if (_currentStoryIndex < currentUser.stories.length - 1) {
      // Go to next story of current user
      setState(() {
        _currentStoryIndex++;
      });
      _animationController.forward();
    } else if (_currentUserIndex < widget.users.length - 1) {
      // Go to first story of next user
      setState(() {
        _currentUserIndex++;
        _currentStoryIndex = 0;
      });
      _userPageController.animateToPage(
        _currentUserIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _animationController.forward();
    } else {
      // End of all stories
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      // Go to previous story of current user
      setState(() {
        _currentStoryIndex--;
      });
      _animationController.forward();
    } else if (_currentUserIndex > 0) {
      // Go to last story of previous user
      setState(() {
        _currentUserIndex--;
        _currentStoryIndex = widget.users[_currentUserIndex].stories.length - 1;
      });
      _userPageController.animateToPage(
        _currentUserIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _animationController.forward();
    } else {
      // Beginning of all stories
      Navigator.pop(context);
    }
  }

  void _onHoldStart() {
    // Pause the animation when user holds down
    if (!_isPaused) {
      _isPaused = true;
      _animationController.stop();
    }
  }

  void _onHoldEnd() {
    // Resume the animation when user releases hold
    if (_isPaused) {
      _isPaused = false;
      _animationController.forward();
    }
  }

  void _onSwipeDown() {
    // Close the story view when user swipes down
    Navigator.pop(context);
  }

  void _onSwipeLeft() {
    // Go to next user's stories with animation
    if (_currentUserIndex < widget.users.length - 1) {
      setState(() {
        _currentUserIndex++;
        _currentStoryIndex = 0;
      });
      _userPageController.animateToPage(
        _currentUserIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _onSwipeRight() {
    // Go to previous user's stories with animation
    if (_currentUserIndex > 0) {
      setState(() {
        _currentUserIndex--;
        _currentStoryIndex = 0;
      });
      _userPageController.animateToPage(
        _currentUserIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          final dx = details.globalPosition.dx;

          if (dx < screenWidth / 3) {
            // Left tap
            _animationController.reset();
            _previousStory();
          } else if (dx > 2 * screenWidth / 3) {
            // Right tap
            _animationController.reset();
            _nextStory();
          }
          // If tapped in the middle, do nothing
        },
        onLongPressStart: (_) => _onHoldStart(),
        onLongPressEnd: (_) => _onHoldEnd(),
        child: PageView.builder(
          controller: _userPageController,
          physics:
              const NeverScrollableScrollPhysics(), // Disable default swipe
          itemCount: widget.users.length,
          onPageChanged: (index) {
            setState(() {
              _currentUserIndex = index;
              _currentStoryIndex = 0;
            });
            _animationController.reset();
            _animationController.forward();
          },
          itemBuilder: (context, userIndex) {
            final StoryUser currentUser = widget.users[userIndex];
            final Story currentStory = userIndex == _currentUserIndex
                ? currentUser.stories[_currentStoryIndex]
                : currentUser.stories[0];

            return GestureDetector(
              // Add vertical swipe detection
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! > 300) {
                  _onSwipeDown();
                }
              },
              // Add horizontal swipe detection
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < -300) {
                  _onSwipeLeft();
                } else if (details.primaryVelocity! > 300) {
                  _onSwipeRight();
                }
              },
              child: Stack(
                children: [
                  // Story content
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          currentStory.imageUrl,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Progress indicator for current user's stories only
                  Positioned(
                    top: 40,
                    left: 10,
                    right: 10,
                    child: Row(
                      children: List.generate(
                        currentUser.stories.length,
                        (i) => Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(1),
                            ),
                            child: userIndex == _currentUserIndex &&
                                    i == _currentStoryIndex
                                ? AnimatedBuilder(
                                    animation: _animationController,
                                    builder: (context, child) {
                                      return FractionallySizedBox(
                                        widthFactor: _animationController.value,
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  )
                                : userIndex == _currentUserIndex &&
                                        i < _currentStoryIndex
                                    ? Container(color: Colors.white)
                                    : Container(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // User info
                  Positioned(
                    top: 50,
                    left: 10,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(currentUser.userImage),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          currentUser.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${glb.getDuration(currentStory.timeAgo)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  Positioned(
                    top: 50,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Dummy data with users and their stories
// final List<StoryUser> dummyUsers = [
//   StoryUser(
//     username: 'your_story',
//     userImage: 'https://randomuser.me/api/portraits/men/1.jpg',
//     stories: [
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6',
//         timeAgo: '1h',
//       ),
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1516483638261-f4dbaf036963',
//         timeAgo: '2h',
//       ),
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1533105079780-92b9be482077',
//         timeAgo: '3h',
//       ),
//     ],
//   ),
//   StoryUser(
//     username: 'john_doe',
//     userImage: 'https://randomuser.me/api/portraits/men/2.jpg',
//     stories: [
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
//         timeAgo: '3h',
//       ),
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1514890547357-a9ee288728e0',
//         timeAgo: '4h',
//       ),
//     ],
//   ),
//   StoryUser(
//     username: 'jane_smith',
//     userImage: 'https://randomuser.me/api/portraits/women/1.jpg',
//     stories: [
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1514315384763-ba401779410f',
//         timeAgo: '5h',
//       ),
//     ],
//   ),
//   StoryUser(
//     username: 'mike_johnson',
//     userImage: 'https://randomuser.me/api/portraits/men/3.jpg',
//     stories: [
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1496440737103-cd596325d314',
//         timeAgo: '8h',
//       ),
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1527203561188-dae1bc1a417f',
//         timeAgo: '9h',
//       ),
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4',
//         timeAgo: '10h',
//       ),
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1531747118685-ca8fa6e08806',
//         timeAgo: '11h',
//       ),
//     ],
//   ),
//   StoryUser(
//     username: 'emily_wilson',
//     userImage: 'https://randomuser.me/api/portraits/women/2.jpg',
//     stories: [
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1527203561188-dae1bc1a417f',
//         timeAgo: '10h',
//       ),
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4',
//         timeAgo: '11h',
//       ),
//     ],
//   ),
//   StoryUser(
//     username: 'alex_brown',
//     userImage: 'https://randomuser.me/api/portraits/men/4.jpg',
//     stories: [
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4',
//         timeAgo: '16h',
//       ),
//     ],
//   ),
//   StoryUser(
//     username: 'sarah_davis',
//     userImage: 'https://randomuser.me/api/portraits/women/3.jpg',
//     stories: [
//       Story(
//         imageUrl:
//             'https://images.unsplash.com/photo-1531747118685-ca8fa6e08806',
//         timeAgo: '22h',
//       ),
//     ],
//   ),
// ];
