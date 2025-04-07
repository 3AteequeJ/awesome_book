// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Instagram Stories',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var ht = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: InkWell(
//           onTap: () {
//             print("height: $ht");
//           },
//           child: const Text(
//             'Instagram',
//             style: TextStyle(
//               color: Colors.black,
//               fontFamily: 'Billabong',
//               fontSize: 30,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_box_outlined, color: Colors.black),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.favorite_border, color: Colors.black),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.messenger_outline, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Stories section
//           Container(
//             height: 100,
//             decoration: const BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(color: Colors.grey, width: 0.5),
//               ),
//             ),
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: dummyUsers.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       PageRouteBuilder(
//                         pageBuilder: (context, animation, secondaryAnimation) =>
//                             StoryView(
//                           initialUserIndex: index,
//                           users: dummyUsers,
//                         ),
//                         transitionsBuilder:
//                             (context, animation, secondaryAnimation, child) {
//                           return FadeTransition(
//                             opacity: animation,
//                             child: child,
//                           );
//                         },
//                       ),
//                     );
//                   },
//                   child: Container(
//                     width: 80,
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 65,
//                           height: 65,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Colors.purple,
//                                 Colors.orange,
//                                 Colors.red
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             shape: BoxShape.circle,
//                           ),
//                           padding: const EdgeInsets.all(2),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.white, width: 2),
//                             ),
//                             child: CircleAvatar(
//                               backgroundImage:
//                                   NetworkImage(dummyUsers[index].userImage),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           dummyUsers[index].username,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Rest of the feed would go here
//           Expanded(
//             child: ListView.builder(
//               itemCount: 5,
//               itemBuilder: (context, index) {
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 8),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 15,
//                               backgroundImage: NetworkImage(
//                                   dummyUsers[index % dummyUsers.length]
//                                       .userImage),
//                             ),
//                             const SizedBox(width: 10),
//                             Text(
//                                 dummyUsers[index % dummyUsers.length].username),
//                             const Spacer(),
//                             const Icon(Icons.more_vert),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         height: 300,
//                         color: Colors.grey[300],
//                         child: Center(
//                           child: Icon(Icons.image,
//                               size: 50, color: Colors.grey[600]),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           children: const [
//                             Icon(Icons.favorite_border),
//                             SizedBox(width: 15),
//                             Icon(Icons.chat_bubble_outline),
//                             SizedBox(width: 15),
//                             Icon(Icons.send),
//                             Spacer(),
//                             Icon(Icons.bookmark_border),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class StoryView extends StatefulWidget {
//   final int initialUserIndex;
//   final List<User> users;

//   const StoryView({
//     Key? key,
//     required this.initialUserIndex,
//     required this.users,
//   }) : super(key: key);

//   @override
//   State<StoryView> createState() => _StoryViewState();
// }

// class _StoryViewState extends State<StoryView>
//     with SingleTickerProviderStateMixin {
//   late PageController _userPageController;
//   late AnimationController _animationController;
//   int _currentUserIndex = 0;
//   int _currentStoryIndex = 0;
//   bool _isPaused = false;

//   @override
//   void initState() {
//     super.initState();

//     _currentUserIndex = widget.initialUserIndex;
//     _userPageController = PageController(initialPage: _currentUserIndex);
//     _animationController =
//         AnimationController(vsync: this, duration: const Duration(seconds: 5));

//     _animationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _animationController.reset();
//         _nextStory();
//       }
//     });

//     _loadStory();
//   }

//   @override
//   void dispose() {
//     _userPageController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _loadStory() {
//     _animationController.forward();
//   }

//   void _nextStory() {
//     User currentUser = widget.users[_currentUserIndex];

//     if (_currentStoryIndex < currentUser.stories.length - 1) {
//       // Go to next story of current user
//       setState(() {
//         _currentStoryIndex++;
//       });
//       _animationController.forward();
//     } else if (_currentUserIndex < widget.users.length - 1) {
//       // Go to first story of next user
//       setState(() {
//         _currentUserIndex++;
//         _currentStoryIndex = 0;
//       });
//       _userPageController.animateToPage(
//         _currentUserIndex,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//       _animationController.forward();
//     } else {
//       // End of all stories
//       Navigator.pop(context);
//     }
//   }

//   void _previousStory() {
//     if (_currentStoryIndex > 0) {
//       // Go to previous story of current user
//       setState(() {
//         _currentStoryIndex--;
//       });
//       _animationController.forward();
//     } else if (_currentUserIndex > 0) {
//       // Go to last story of previous user
//       setState(() {
//         _currentUserIndex--;
//         _currentStoryIndex = widget.users[_currentUserIndex].stories.length - 1;
//       });
//       _userPageController.animateToPage(
//         _currentUserIndex,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//       _animationController.forward();
//     } else {
//       // Beginning of all stories
//       Navigator.pop(context);
//     }
//   }

//   void _onHoldStart() {
//     // Pause the animation when user holds down
//     if (!_isPaused) {
//       _isPaused = true;
//       _animationController.stop();
//     }
//   }

//   void _onHoldEnd() {
//     // Resume the animation when user releases hold
//     if (_isPaused) {
//       _isPaused = false;
//       _animationController.forward();
//     }
//   }

//   void _onSwipeDown() {
//     // Close the story view when user swipes down
//     Navigator.pop(context);
//   }

//   void _onSwipeLeft() {
//     // Go to next user's stories with animation
//     if (_currentUserIndex < widget.users.length - 1) {
//       setState(() {
//         _currentUserIndex++;
//         _currentStoryIndex = 0;
//       });
//       _userPageController.animateToPage(
//         _currentUserIndex,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//       _animationController.reset();
//       _animationController.forward();
//     }
//   }

//   void _onSwipeRight() {
//     // Go to previous user's stories with animation
//     if (_currentUserIndex > 0) {
//       setState(() {
//         _currentUserIndex--;
//         _currentStoryIndex = 0;
//       });
//       _userPageController.animateToPage(
//         _currentUserIndex,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//       _animationController.reset();
//       _animationController.forward();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTapDown: (details) {
//           final screenWidth = MediaQuery.of(context).size.width;
//           final dx = details.globalPosition.dx;

//           if (dx < screenWidth / 3) {
//             // Left tap
//             _animationController.reset();
//             _previousStory();
//           } else if (dx > 2 * screenWidth / 3) {
//             // Right tap
//             _animationController.reset();
//             _nextStory();
//           }
//           // If tapped in the middle, do nothing
//         },
//         onLongPressStart: (_) => _onHoldStart(),
//         onLongPressEnd: (_) => _onHoldEnd(),
//         child: PageView.builder(
//           controller: _userPageController,
//           physics:
//               const NeverScrollableScrollPhysics(), // Disable default swipe
//           itemCount: widget.users.length,
//           onPageChanged: (index) {
//             setState(() {
//               _currentUserIndex = index;
//               _currentStoryIndex = 0;
//             });
//             _animationController.reset();
//             _animationController.forward();
//           },
//           itemBuilder: (context, userIndex) {
//             final User currentUser = widget.users[userIndex];
//             final Story currentStory = userIndex == _currentUserIndex
//                 ? currentUser.stories[_currentStoryIndex]
//                 : currentUser.stories[0];

//             return GestureDetector(
//               // Add vertical swipe detection
//               onVerticalDragEnd: (details) {
//                 if (details.primaryVelocity! > 300) {
//                   _onSwipeDown();
//                 }
//               },
//               // Add horizontal swipe detection
//               onHorizontalDragEnd: (details) {
//                 if (details.primaryVelocity! < -300) {
//                   _onSwipeLeft();
//                 } else if (details.primaryVelocity! > 300) {
//                   _onSwipeRight();
//                 }
//               },
//               child: Stack(
//                 children: [
//                   // Story content
//                   Container(
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: NetworkImage(currentStory.imageUrl),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),

//                   // Progress indicator for current user's stories only
//                   Positioned(
//                     top: 40,
//                     left: 10,
//                     right: 10,
//                     child: Row(
//                       children: List.generate(
//                         currentUser.stories.length,
//                         (i) => Expanded(
//                           child: Container(
//                             height: 2,
//                             margin: const EdgeInsets.symmetric(horizontal: 2),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.withOpacity(0.5),
//                               borderRadius: BorderRadius.circular(1),
//                             ),
//                             child: userIndex == _currentUserIndex &&
//                                     i == _currentStoryIndex
//                                 ? AnimatedBuilder(
//                                     animation: _animationController,
//                                     builder: (context, child) {
//                                       return FractionallySizedBox(
//                                         widthFactor: _animationController.value,
//                                         alignment: Alignment.centerLeft,
//                                         child: Container(
//                                           color: Colors.white,
//                                         ),
//                                       );
//                                     },
//                                   )
//                                 : userIndex == _currentUserIndex &&
//                                         i < _currentStoryIndex
//                                     ? Container(color: Colors.white)
//                                     : Container(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // User info
//                   Positioned(
//                     top: 50,
//                     left: 10,
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 15,
//                           backgroundImage: NetworkImage(currentUser.userImage),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           currentUser.username,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           '${currentStory.timeAgo} ago',
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Close button
//                   Positioned(
//                     top: 50,
//                     right: 10,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // Custom page transition for 3D cube effect
// class CubePageRoute extends PageRouteBuilder {
//   final Widget enterPage;
//   final Widget exitPage;
//   final bool forward;

//   CubePageRoute({
//     required this.enterPage,
//     required this.exitPage,
//     this.forward = true,
//   }) : super(
//           pageBuilder: (context, animation, secondaryAnimation) => enterPage,
//           transitionDuration: const Duration(milliseconds: 500),
//           reverseTransitionDuration: const Duration(milliseconds: 500),
//         );

//   @override
//   Widget buildTransitions(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     Widget child,
//   ) {
//     return Stack(
//       children: [
//         // Exit page with rotation
//         SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(0.0, 0.0),
//             end: Offset(forward ? -0.5 : 0.5, 0.0),
//           ).animate(
//             CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeInOut,
//             ),
//           ),
//           child: Transform(
//             alignment: forward ? Alignment.centerRight : Alignment.centerLeft,
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, 0.001)
//               ..rotateY(
//                   forward ? -animation.value * 0.5 : animation.value * 0.5),
//             child: exitPage,
//           ),
//         ),

//         // Enter page with rotation
//         SlideTransition(
//           position: Tween<Offset>(
//             begin: Offset(forward ? 0.5 : -0.5, 0.0),
//             end: const Offset(0.0, 0.0),
//           ).animate(
//             CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeInOut,
//             ),
//           ),
//           child: Transform(
//             alignment: forward ? Alignment.centerLeft : Alignment.centerRight,
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, 0.001)
//               ..rotateY(forward
//                   ? (1 - animation.value) * 0.5
//                   : -(1 - animation.value) * 0.5),
//             child: animation.value > 0.5 ? child : Container(),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Custom page transition for user stories
// class StoryPageView extends StatefulWidget {
//   final List<User> users;
//   final int initialIndex;
//   final Function(int) onPageChanged;

//   const StoryPageView({
//     Key? key,
//     required this.users,
//     required this.initialIndex,
//     required this.onPageChanged,
//   }) : super(key: key);

//   @override
//   State<StoryPageView> createState() => _StoryPageViewState();
// }

// class _StoryPageViewState extends State<StoryPageView> {
//   late PageController _pageController;
//   late int _currentIndex;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//     _pageController = PageController(initialPage: _currentIndex);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PageView.builder(
//       controller: _pageController,
//       itemCount: widget.users.length,
//       onPageChanged: (index) {
//         setState(() {
//           _currentIndex = index;
//         });
//         widget.onPageChanged(index);
//       },
//       itemBuilder: (context, index) {
//         return Transform(
//           transform: Matrix4.identity()
//             ..setEntry(3, 2, 0.001)
//             ..rotateY(_pageController.position.haveDimensions
//                 ? (_pageController.page! - index) * 0.5
//                 : 0.0),
//           alignment: index > _currentIndex
//               ? Alignment.centerLeft
//               : Alignment.centerRight,
//           child: Container(
//             color: Colors.black,
//             child: Center(
//               child: Text(
//                 'User ${index + 1}',
//                 style: const TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class User {
//   final String username;
//   final String userImage;
//   final List<Story> stories;

//   User({
//     required this.username,
//     required this.userImage,
//     required this.stories,
//   });
// }

// class Story {
//   final String imageUrl;
//   final String timeAgo;

//   Story({
//     required this.imageUrl,
//     required this.timeAgo,
//   });
// }

// // Dummy data with users and their stories
// final List<User> dummyUsers = [
//   User(
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
//   User(
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
//   User(
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
//   User(
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
//   User(
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
//   User(
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
//   User(
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
