// import 'package:awesome_book/Image/Camera_scrn.dart';
// import 'package:awesome_book/Route/router.dart';
// import 'package:awesome_book/models/MyStories_model.dart';
// import 'package:awesome_book/widgets/mytext.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:awesome_book/utils/global.dart' as glb;

// class AddStoryCircle extends StatefulWidget {
//   const AddStoryCircle({
//     super.key,
//     required this.myStories,
//   });
//   final List<MyStories> myStories;
//   @override
//   State<AddStoryCircle> createState() => _AddStoryCircleState();
// }

// class _AddStoryCircleState extends State<AddStoryCircle> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             PageRouteBuilder(
//               pageBuilder: (context, animation, secondaryAnimation) =>
//                   widget.myStories.isEmpty
//                       ? CameraScrn()
//                       : StoryView(
//                           myStories: widget.myStories,
//                         ),
//               transitionsBuilder:
//                   (context, animation, secondaryAnimation, child) {
//                 return FadeTransition(
//                   opacity: animation,
//                   child: child,
//                 );
//               },
//             ),
//           );
//         },
//         child: Container(
//           width: 25.w,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Stack(
//                   alignment: Alignment.bottomRight,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: true
//                               ? [Colors.blue, Colors.purple, Colors.red]
//                               : [Colors.black, Colors.grey],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(8.sp),
//                         child: Container(
//                           height: 20.w,
//                           width: 20.w,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Theme.of(context).scaffoldBackgroundColor,
//                             image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: NetworkImage(
//                                   glb.userDetails.profile_img,
//                                 )),
//                           ),
//                         ),
//                       ),
//                     ),
//                     CircleAvatar(
//                       radius: 16.sp,
//                       backgroundColor: Colors.blue,
//                       child: Icon(
//                         CupertinoIcons.add,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Txt(text: "Add story"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class StoryView extends StatefulWidget {
//   final List<MyStories> myStories;

//   const StoryView({
//     Key? key,
//     required this.myStories,
//   }) : super(key: key);

//   @override
//   State<StoryView> createState() => _StoryViewState();
// }

// class _StoryViewState extends State<StoryView>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   int _currentStoryIndex = 0;
//   bool _isPaused = false;

//   MyStories get _myStories => widget.myStories[0];

//   @override
//   void initState() {
//     super.initState();

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
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _loadStory() {
//     _animationController.forward();
//   }

//   void _nextStory() {
//     if (_currentStoryIndex < widget.myStories.length - 1) {
//       setState(() {
//         _currentStoryIndex++;
//       });
//       _animationController.forward();
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   void _previousStory() {
//     if (_currentStoryIndex > 0) {
//       setState(() {
//         _currentStoryIndex--;
//       });
//       _animationController.forward();
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   void _onHoldStart() {
//     if (!_isPaused) {
//       _isPaused = true;
//       _animationController.stop();
//     }
//   }

//   void _onHoldEnd() {
//     if (_isPaused) {
//       _isPaused = false;
//       _animationController.forward();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final MyStories currentStory = widget.myStories[_currentStoryIndex];

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTapDown: (details) {
//           final screenWidth = MediaQuery.of(context).size.width;
//           final dx = details.globalPosition.dx;

//           if (dx < screenWidth / 3) {
//             _animationController.reset();
//             _previousStory();
//           } else if (dx > 2 * screenWidth / 3) {
//             _animationController.reset();
//             _nextStory();
//           }
//         },
//         onLongPressStart: (_) => _onHoldStart(),
//         onLongPressEnd: (_) => _onHoldEnd(),
//         onVerticalDragEnd: (details) {
//           if (details.primaryVelocity! > 300) {
//             Navigator.pop(context);
//           }
//         },
//         child: Stack(
//           children: [
//             // Story content
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(currentStory.storyURL),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),

//             // Progress indicator
//             Positioned(
//               top: 40,
//               left: 10,
//               right: 10,
//               child: Row(
//                 children: List.generate(
//                   widget.myStories.length,
//                   (i) => Expanded(
//                     child: Container(
//                       height: 2,
//                       margin: const EdgeInsets.symmetric(horizontal: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(1),
//                       ),
//                       child: i == _currentStoryIndex
//                           ? AnimatedBuilder(
//                               animation: _animationController,
//                               builder: (context, child) {
//                                 return FractionallySizedBox(
//                                   widthFactor: _animationController.value,
//                                   alignment: Alignment.centerLeft,
//                                   child: Container(
//                                     color: Colors.white,
//                                   ),
//                                 );
//                               },
//                             )
//                           : i < _currentStoryIndex
//                               ? Container(color: Colors.white)
//                               : Container(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // User info
//             Positioned(
//               top: 50,
//               left: 10,
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 15,
//                     backgroundImage: NetworkImage(glb.userDetails.profile_img),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     glb.userDetails.user_name,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     '${glb.getDuration(currentStory.timeStamp)}',
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Buttons
//             Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: Padding(
//                   padding: EdgeInsets.all(16.sp),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           showStoryViewers(context,
//                               widget.myStories[_currentStoryIndex].viewersList);
//                         },
//                         child: Txt(
//                           text:
//                               "${widget.myStories[_currentStoryIndex].viewCount} Likes",
//                           colour: Colors.white70,
//                         ),
//                       ),
//                       // Expanded(child: Container()),
//                       ElevatedButton(
//                           onPressed: () {
//                             Navigator.pushNamed(
//                                 context, RouteGenerator.rt_camera);
//                           },
//                           child: Txt(text: "New story")),
//                     ],
//                   ),
//                 )),

//             // Close button
//             Positioned(
//               top: 50,
//               right: 10,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void showStoryViewers(
//       BuildContext context, List<ViewerModel> viewersList) async {
//     // Pause the timer before showing the bottom sheet
//     _animationController.stop();
//     _isPaused = true;

//     await showModalBottomSheet(
//       enableDrag: true,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor: Colors.white,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           height: MediaQuery.of(context).size.height * 0.5,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 5,
//                   margin: const EdgeInsets.only(bottom: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               Text(
//                 "${widget.myStories[_currentStoryIndex].viewCount} Views",
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10.sp),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: viewersList.length,
//                   itemBuilder: (context, index) {
//                     final viewer = viewersList[index];
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(viewer.imageURL),
//                       ),
//                       title: Text(viewer.name),
//                       subtitle: Text(glb.getDuration(viewer.timeStamp)),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );

//     // Resume the timer after the bottom sheet is dismissed
//     if (_isPaused) {
//       _animationController.forward();
//       _isPaused = false;
//     }
//   }
// }
