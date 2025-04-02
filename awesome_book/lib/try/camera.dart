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
