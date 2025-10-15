// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:awesome_book/Cards/posts_card.dart';
// import 'package:awesome_book/Image/Camera_scrn.dart';
// import 'package:awesome_book/Image/addStory.dart';
// import 'package:awesome_book/Image/addStoryCircle.dart';
// import 'package:awesome_book/Image/mystories.dart';
// import 'package:awesome_book/Route/router.dart';
// import 'package:awesome_book/ads/ad_post.dart';
// import 'package:awesome_book/ads/add_mob_native_add.dart';
// import 'package:awesome_book/ads/native_ad.dart';
// import 'package:awesome_book/models/posts_model.dart';
// import 'package:awesome_book/models/stories_model.dart';
// import 'package:awesome_book/utils/sharedPrefs.dart';
// import 'package:awesome_book/widgets/mytext.dart';
// import 'package:awesome_book/widgets/storiesCircle.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:http/http.dart' as http;
// import 'package:awesome_book/utils/global.dart' as glb;

// class Home_scrn extends StatefulWidget {
//   const Home_scrn({super.key});

//   @override
//   State<Home_scrn> createState() => _Home_scrnState();
// }

// class _Home_scrnState extends State<Home_scrn> {
//   List<Post_model> PM = [];
//   List<StoryUser> SU = [];
//   // List<StoryUser> SU2 = [];

//   // List<MyStories> _myStories = [];
//   ScrollController _scrollController = ScrollController();
//   bool isLoadingPosts = false;
//   bool isLoadingStories = false;
//   int page = 1;
//   final int limit = 10;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     _setupScrollListener();
//   }

//   @override
//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();

//   //   final args = ModalRoute.of(context)?.settings.arguments;
//   //   if (args is Map && args["refreshMyStories"] == true) {
//   //     fetchStories_async(); // 👈 your function that loads stories from API
//   //   }
//   // }

//   void _initializeData() {
//     fetchPosts_async();
//     fetchStories_async();
//   }

//   void _setupScrollListener() {
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//               _scrollController.position.maxScrollExtent - 200 &&
//           !isLoadingPosts) {
//         fetchPosts_async();
//       }
//     });
//   }

//   Future<void> _refresh() async {
//     setState(() {
//       PM.clear();
//       SU.clear();
//       page = 1;
//     });

//     await Future.wait([
//       fetchPosts_async(),
//       fetchStories_async(),
//     ]);
//   }

//   /// ✅ Fetch Posts with guest handling (-1)
//   Future<void> fetchPosts_async() async {
//     if (isLoadingPosts) return;
//     setState(() => isLoadingPosts = true);

//     final currentUserId = glb.userDetails.id.isNotEmpty
//         ? glb.userDetails.id
//         : "-1"; // send -1 for guests
//     Uri url = Uri.parse("${glb.API.GetPosts}?page=$page&limit=$limit");

//     try {
//       var res = await http.post(url, body: {'follower_id': currentUserId});
//       print("Posts response = ${res.body}");

//       if (res.statusCode == 200) {
//         List<dynamic> body = jsonDecode(res.body);
//         List<Post_model> newPosts = body
//             .map((p) => Post_model(
//                   id: p['id'].toString(),
//                   name: "public/" + p['p_name'].toString(),
//                   user_name: p['user_name'].toString(),
//                   type: p['p_type'].toString(),
//                   caption: p['caption'].toString(),
//                   dateTime: p['timestamp'].toString(),
//                   no_likes: p['like_count'].toString(),
//                   no_comments: p['comment_count'].toString(),
//                   isFollowing: p['is_following'].toString(),
//                   profileImage: p['profile_image'].toString(),
//                   verified: p['verified'].toString(),
//                   is_liked: p['is_liked'].toString(),
//                 ))
//             .toList();

//         setState(() {
//           PM.addAll(newPosts);
//           page++;
//         });
//       }
//     } catch (e) {
//       print("Error fetching posts: $e");
//     }

//     setState(() => isLoadingPosts = false);
//   }

//   Future<void> fetchStories_async() async {
//     if (isLoadingStories) return;
//     setState(() => isLoadingStories = true);

//     Uri url = Uri.parse("${glb.API.GetStories}");

//     try {
//       var res = await http.post(url, body: {'user_id': glb.userDetails.id});
//       print("Stories response = ${res.body}");

//       if (res.statusCode == 200) {
//         List<dynamic> responseData = jsonDecode(res.body);
//         List<StoryUser> newStories = [];

//         for (var storyUserData in responseData) {
//           String user_id = storyUserData['user_id'].toString();
//           String username = storyUserData['username'].toString();
//           String userImage = storyUserData['userImage'].toString();

//           List<Story> stories = [];
//           List storiesData = storyUserData['stories'] ?? [];

//           for (var storyData in storiesData) {
//             stories.add(Story(
//               imageUrl:
//                   glb.API.baseURL + "public" + storyData['imageUrl'].toString(),
//               timeAgo: storyData['timeAgo'].toString(),
//               storyId: storyData['story_id'].toString(),
//               storyType: storyData['type'].toString(),
//               viewed: storyData['viewed'].toString(),
//             ));
//           }

//           newStories.add(StoryUser(
//             username: username,
//             userImage: glb.API.baseURL + userImage,
//             stories: stories,
//             user_id: user_id,
//           ));
//         }

//         setState(() {
//           SU = newStories; // Replace instead of adding
//         });
//       }
//     } catch (e) {
//       print("Error fetching stories: $e");
//     }

//     setState(() => isLoadingStories = false);
//   }

//   /// ✅ Fetch Stories with guest handling (-1)

//   // Future<void> fetchStories_async() async {
//   //   if (isLoadingStories) return;
//   //   setState(() => isLoadingStories = true);

//   //   final currentUserId =
//   //       glb.userDetails.id.isNotEmpty ? glb.userDetails.id : "-1";

//   //   List<StoryUser> allStories = [];

//   //   try {
//   //     // 🟡 1. Fetch all public stories
//   //     final allUrl = Uri.parse(glb.API.GetStories);
//   //     final allRes = await http.post(allUrl, body: {'user_id': currentUserId});

//   //     if (allRes.statusCode == 200 && allRes.body.isNotEmpty) {
//   //       List<dynamic> responseData = jsonDecode(allRes.body);

//   //       for (var storyUserData in responseData) {
//   //         String userId = storyUserData['user_id']?.toString().trim() ?? '';
//   //         String username = storyUserData['username']?.toString() ?? 'Unknown';
//   //         String userImage = storyUserData['userImage']?.toString() ?? '';

//   //         List<Story> stories = [];
//   //         List storiesData = storyUserData['stories'] ?? [];

//   //         for (var storyData in storiesData) {
//   //           stories.add(Story(
//   //             imageUrl: glb.API.baseURL +
//   //                 "/" +
//   //                 (storyData['imageUrl']
//   //                         ?.toString()
//   //                         .replaceFirst("public/", "") ??
//   //                     ''),
//   //             timeAgo: storyData['timeAgo']?.toString() ?? '',
//   //             storyId: storyData['story_id']?.toString() ?? '',
//   //             storyType: storyData['type']?.toString() ?? '',
//   //             viewed: storyData['viewed']?.toString() ?? '0',
//   //           ));
//   //         }

//   //         allStories.add(StoryUser(
//   //           username: username.trim(),
//   //           userImage: glb.API.baseURL + userImage,
//   //           stories: stories,
//   //           user_id: userId,
//   //         ));
//   //       }
//   //     }

//   //     // 🟢 2. Fetch your own stories only if logged in
//   //     if (currentUserId != "-1") {
//   //       final myUrl = Uri.parse(glb.API.GetMyStories);
//   //       final myRes = await http.post(myUrl, body: {'user_id': currentUserId});

//   //       if (myRes.statusCode == 200 && myRes.body.isNotEmpty) {
//   //         final myStoriesData = jsonDecode(myRes.body);
//   //         print("🟢 My stories fetched: ${myStoriesData.length}");

//   //         if (myStoriesData.isNotEmpty) {
//   //           final myStories = myStoriesData.map<Story>((storyData) {
//   //             String storyPath = storyData['story']?.toString() ?? '';
//   //             if (storyPath.startsWith('public/')) {
//   //               storyPath = storyPath.replaceFirst('public/', '');
//   //             }
//   //             if (!storyPath.startsWith('/')) {
//   //               storyPath = '/' + storyPath;
//   //             }

//   //             return Story(
//   //               imageUrl: glb.API.baseURL + storyPath,
//   //               timeAgo: storyData['time_stamp']?.toString() ?? '',
//   //               storyId: storyData['id']?.toString() ?? '',
//   //               storyType: storyData['s_type']?.toString() ?? '',
//   //               viewed: "0",
//   //             );
//   //           }).toList();

//   //           print("✅ Inserted ${myStories.length} self stories");
//   //           setState(() {
//   //             SU2 = myStoriesData;
//   //           });
//   //           // Remove any duplicates
//   //           // allStories.removeWhere((u) => u.user_id == currentUserId);

//   //           // Add your story first
//   //           allStories.insert(
//   //             0,
//   //             StoryUser(
//   //               username: glb.userDetails.user_name.isNotEmpty
//   //                   ? glb.userDetails.user_name
//   //                   : "You",
//   //               userImage: glb.userDetails.profile_img.isNotEmpty
//   //                   ? glb.API.baseURL + glb.userDetails.profile_img
//   //                   : "",
//   //               stories: myStories,
//   //               user_id: currentUserId,
//   //             ),
//   //           );
//   //         }
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print("Error fetching stories: $e");
//   //   }

//   //   setState(() {
//   //     SU = allStories;
//   //     isLoadingStories = false;
//   //   });
//   // }

//   // /// ✅ Story Section (always one Your Story)
//   Widget _buildStoriesSection() {
//     return SizedBox(
//       height: 15.h,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: SU.length + 1,
//         itemBuilder: (context, index) {
//           return index == 0
//               ? SizedBox(height: 15.h, child: AddStoryCircle(myStories: SU))
//               : StoriesCircle(
//                   name: 'Story $index',
//                   idx: index - 1,
//                   storyUsers: SU,
//                   myStories: [],
//                 );
//         },
//       ),
//     );
//   }

//   /// ✅ Show login dialog for guests
//   void _showLoginPrompt(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Login Required"),
//         content:
//             const Text("Please log in or register to perform this action."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, RouteGenerator.rt_login);
//             },
//             child: const Text("Login"),
//           ),
//         ],
//       ),
//     );
//   }

//   int _getAdCount() => PM.isEmpty ? 0 : (PM.length / 5).floor();

//   int _getPostIndex(int listIndex) {
//     int adsBefore = (listIndex / 6).floor();
//     return listIndex - adsBefore;
//   }

//   bool _shouldShowNativeAd(int index) => index > 0 && index % 6 == 0;

//   Widget _buildRandomAd() {
//     final adTypes = ['native', 'banner'];
//     final randomType = adTypes[DateTime.now().millisecondsSinceEpoch % 2];
//     if (randomType == 'native') {
//       return NativeAdWidget();
//     } else {
//       return AdBannerWidget();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     int totalItems = PM.length + _getAdCount();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xfff8faf8),
//         title: Image.asset('assets/images/icon.jpeg', height: 32),
//         centerTitle: true,
//         elevation: 1.0,
//         leading: IconButton(
//           icon: const Icon(Icons.camera_alt, color: Colors.black),
//           onPressed: () async {
//             if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1") {
//               _showLoginPrompt(context);
//               return;
//             }

//             final cameras = await availableCameras();
//             final firstCamera = cameras.first;
//             Navigator.of(context).push(
//               PageRouteBuilder(
//                 pageBuilder: (context, animation, secondaryAnimation) =>
//                     CameraScrn(camera: firstCamera),
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(-1.0, 0.0);
//                   const end = Offset.zero;
//                   const curve = Curves.easeInOut;
//                   var tween = Tween(begin: begin, end: end)
//                       .chain(CurveTween(curve: curve));
//                   var offsetAnimation = animation.drive(tween);
//                   return SlideTransition(
//                     position: offsetAnimation,
//                     child: child,
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.send, color: Colors.black),
//             onPressed: () {
//               if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1") {
//                 _showLoginPrompt(context);
//                 return;
//               }
//               Navigator.pushNamed(context, RouteGenerator.rt_msgLst);
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.person_add_alt_1_outlined,
//                 color: Colors.black),
//             onPressed: () async {
//               if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1") {
//                 _showLoginPrompt(context);
//                 return;
//               }
//               await Navigator.pushNamed(
//                   context, RouteGenerator.rt_followRequests);
//               if (glb.shouldRefreshProfile) setState(() {});
//             },
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refresh,
//         child: ListView(
//           controller: _scrollController,
//           children: [
//             if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1")
//               Container(
//                 color: Colors.blue.shade50,
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Log in to like, comment or post stories",
//                       style: TextStyle(color: Colors.black87),
//                     ),
//                     ElevatedButton(
//                       onPressed: () =>
//                           Navigator.pushNamed(context, RouteGenerator.rt_login),
//                       child: const Text("Login"),
//                     ),
//                   ],
//                 ),
//               ),
//             isLoadingStories
//                 ? SizedBox(
//                     height: 15.h,
//                     child: const Center(child: CircularProgressIndicator()),
//                   )
//                 : _buildStoriesSection(),
//             SizedBox(height: 1.h),
//             ListView.builder(
//               itemCount: totalItems + (isLoadingPosts ? 1 : 0),
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 if (index == totalItems) {
//                   return isLoadingPosts
//                       ? const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(16.0),
//                             child: CircularProgressIndicator(),
//                           ),
//                         )
//                       : const SizedBox();
//                 }

//                 if (_shouldShowNativeAd(index)) {
//                   return AdMobNativeAdWidget();
//                 }

//                 int postIndex = _getPostIndex(index);
//                 if (postIndex < PM.length) {
//                   return Posts_card(posts: PM[postIndex]);
//                 }

//                 return const SizedBox();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
import 'dart:convert';
import 'package:awesome_book/Cards/posts_card.dart';
import 'package:awesome_book/Image/Camera_scrn.dart';
import 'package:awesome_book/Image/addStoryCircle.dart';
import 'package:awesome_book/Image/mystories.dart';
import 'package:awesome_book/Route/router.dart';
import 'package:awesome_book/ads/ad_post.dart';
import 'package:awesome_book/ads/add_mob_native_add.dart';
import 'package:awesome_book/ads/native_ad.dart';

import 'package:awesome_book/models/posts_model.dart';
import 'package:awesome_book/models/stories_model.dart';
import 'package:awesome_book/try/camera.dart';
import 'package:awesome_book/utils/sharedPrefs.dart';

import 'package:awesome_book/widgets/mytext.dart';
import 'package:awesome_book/widgets/storiesCircle.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_book/utils/global.dart' as glb;

class Home_scrn extends StatefulWidget {
  const Home_scrn({super.key});

  @override
  State<Home_scrn> createState() => _Home_scrnState();
}

class _Home_scrnState extends State<Home_scrn> {
  List<Post_model> PM = [];
  List<StoryUser> SU = [];
  List<MyStories> myStories = [];
  ScrollController _scrollController = ScrollController();
  bool isLoadingPosts = false;
  bool isLoadingStories = false;
  int page = 1;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupScrollListener();
  }

  void _initializeData() {
    fetchPosts_async();
    fetchStories_async();
    fetchMyStories();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingPosts) {
        fetchPosts_async();
      }
    });
  }

  Future<void> _refresh() async {
    setState(() {
      PM.clear();
      SU.clear(); // Clear stories as well
      page = 1;
    });

    // Fetch both posts and stories concurrently
    await Future.wait([
      fetchPosts_async(),
      fetchStories_async(),
    ]);
  }

  Future<void> fetchPosts_async() async {
    if (isLoadingPosts) return;
    setState(() => isLoadingPosts = true);

    Uri url = Uri.parse("${glb.API.GetPosts}?page=$page&limit=$limit");

    try {
      var res = await http.post(url, body: {'follower_id': '1'});
      print("Posts response = ${res.body}");

      if (res.statusCode == 200) {
        List<dynamic> body = jsonDecode(res.body);
        List<Post_model> newPosts = body
            .map((p) => Post_model(
                  id: p['id'].toString(),
                  name: "public/" + p['p_name'].toString(),
                  user_name: p['user_name'].toString(),
                  type: p['p_type'].toString(),
                  caption: p['caption'].toString(),
                  dateTime: p['timestamp'].toString(),
                  no_likes: p['like_count'].toString(),
                  no_comments: p['comment_count'].toString(),
                  isFollowing: p['is_following'].toString(),
                  profileImage: p['profile_image'].toString(),
                  verified: p['verified'].toString(),
                  is_liked: p['is_liked'].toString(),
                ))
            .toList();

        setState(() {
          PM.addAll(newPosts);
          page++;
        });
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }

    setState(() => isLoadingPosts = false);
  }

  Future<void> fetchStories_async() async {
    if (isLoadingStories) return;
    setState(() => isLoadingStories = true);

    Uri url = Uri.parse("${glb.API.GetStories}");

    try {
      var res = await http.post(url, body: {'user_id': glb.userDetails.id});
      print("Stories response = ${res.body}");

      if (res.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(res.body);
        List<StoryUser> newStories = [];

        for (var storyUserData in responseData) {
          String user_id = storyUserData['user_id'].toString();
          String username = storyUserData['username'].toString();
          String userImage = storyUserData['userImage'].toString();

          List<Story> stories = [];
          List storiesData = storyUserData['stories'] ?? [];

          for (var storyData in storiesData) {
            stories.add(Story(
              imageUrl:
                  glb.API.baseURL + "public" + storyData['imageUrl'].toString(),
              timeAgo: storyData['timeAgo'].toString(),
              storyId: storyData['story_id'].toString(),
              storyType: storyData['type'].toString(),
              viewed: storyData['viewed'].toString(),
            ));
          }

          newStories.add(StoryUser(
            username: username,
            userImage: glb.API.baseURL + userImage,
            stories: stories,
            user_id: user_id,
          ));
        }

        setState(() {
          SU = newStories; // Replace instead of adding
        });
      }
    } catch (e) {
      print("Error fetching stories: $e");
    }

    setState(() => isLoadingStories = false);
  }

  int _getAdCount() {
    return PM.isEmpty ? 0 : (PM.length / 5).floor();
  }

  int _getPostIndex(int listIndex) {
    // Calculate actual post index accounting for ads
    int adsBefore = (listIndex / 6).floor();
    return listIndex - adsBefore;
  }

  bool _shouldShowNativeAd(int index) {
    // Show native ad every 6 posts
    return index > 0 && index % 6 == 0;
  }

  // Optional: Mix different ad types
  Widget _buildRandomAd() {
    final adTypes = ['native', 'banner'];
    final randomType = adTypes[DateTime.now().millisecondsSinceEpoch % 2];

    if (randomType == 'native') {
      return NativeAdWidget();
    } else {
      return AdBannerWidget(); // Your existing banner ad
    }
  }

//   /// ✅ Show login dialog for guests
  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Required"),
        content:
            const Text("Please log in or register to perform this action."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RouteGenerator.rt_login);
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  Future<void> fetchMyStories() async {
    // if (isLoading) return;
    // setState(() => isLoading = true);

    final url = Uri.parse("${glb.API.GetMyStories}");

    try {
      final res = await http.post(url, body: {
        'user_id': glb.userDetails.id,
      });

      if (res.statusCode == 200) {
        final List<dynamic> body = jsonDecode(res.body);
        final newPosts = body
            .map((p) => MyStories(
                  id: p['id'].toString(),
                  storyURL: glb.API.baseURL + p['story'].toString(),
                  type: p['p_type'].toString(),
                  timeStamp: p['time_stamp'].toString(),
                  status: p['status'].toString(),
                  viewCount: p['viewers'].toList().length.toString(),
                  viewersList: (p['viewers'] as List)
                      .map<ViewerModel>((v) => ViewerModel(
                            id: v['viewer_id'].toString(),
                            name: v['viewer_name'].toString(),
                            imageURL: glb.API.baseURL +
                                v['viewer_profileimg']
                                    .toString(), // if image field exists
                            timeStamp: v['viewTime'].toString(),
                          ))
                      .toList(),
                ))
            .toList();

        setState(() {
          myStories.clear();
          myStories.addAll(newPosts);
          page++;
        });
      }
    } catch (e) {
      print("Error fetching my stories: $e");
    } finally {
      // setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = PM.length + _getAdCount();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff8faf8),
        title: Image.asset(
          'assets/images/icon.jpeg',
          height: 32,
        ),
        centerTitle: true,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.camera_alt, color: Colors.black),
          onPressed: () async {
            if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1") {
              _showLoginPrompt(context);
              return;
            }
            final cameras = await availableCameras();
            final firstCamera = cameras.first;
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    CameraScrn(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        actions: [
          // ✉️ Messages
          IconButton(
            icon: const Icon(Icons.send, color: Colors.black),
            onPressed: () {
              if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1") {
                _showLoginPrompt(context);
                return;
              }
              Navigator.pushNamed(context, RouteGenerator.rt_msgLst);
            },
          ),
          // 👥 Follow Requests
          IconButton(
              icon: const Icon(Icons.person_add_alt_1_outlined,
                  color: Colors.black),
              onPressed: () async {
                if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1") {
                  _showLoginPrompt(context);
                  return;
                }
                await Navigator.pushNamed(
                    context, RouteGenerator.rt_followRequests);
                if (glb.shouldRefreshProfile) setState(() {});
              }),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          controller: _scrollController,
          children: [
            if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1")
              Container(
                color: Colors.blue.shade50,
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Log in to like, comment or post stories",
                      style: TextStyle(color: Colors.black87),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, RouteGenerator.rt_login),
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),
            // Stories Section
            isLoadingStories
                ? SizedBox(
                    height: 15.h,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : _buildStoriesSection(),
            // _buildStoriesSection(),
            // SizedBox(
            //   height: 15.h,
            //   child: SU.isEmpty && isLoadingStories
            //       ? Center(child: CircularProgressIndicator())
            //       : ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: SU.length,
            //           itemBuilder: (context, index) {
            //             return StoriesCircle(
            //               name: 'Story $index',
            //               idx: index,
            //               storyUsers: SU,
            //             );
            //           },
            //         ),
            // ),
            SizedBox(height: 1.h),

            // Posts and Native Ads Section
            ListView.builder(
              itemCount: totalItems + (isLoadingPosts ? 1 : 0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                // Show loading indicator at the end
                if (index == totalItems) {
                  return isLoadingPosts
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox();
                }

                // Show native ad every 6 posts
                if (_shouldShowNativeAd(index)) {
                  return AdMobNativeAdWidget(); // Native ad that looks like a post
                }

                // Show post
                int postIndex = _getPostIndex(index);
                if (postIndex < PM.length) {
                  return Posts_card(posts: PM[postIndex]);
                }

                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesSection() {
    return SizedBox(
      height: 15.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: SU.length + 1,
        itemBuilder: (context, index) {
          return index == 0
              ? SizedBox(
                  height: 15.h, child: AddStoryCircle(myStories: myStories))
              : StoriesCircle(
                  name: 'Story $index',
                  idx: index - 1,
                  storyUsers: SU,
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}





// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:awesome_book/Cards/posts_card.dart';
// import 'package:awesome_book/Image/Camera_scrn.dart';
// import 'package:awesome_book/Image/addStory.dart';
// import 'package:awesome_book/Route/router.dart';
// import 'package:awesome_book/ads/ad_post.dart';
// import 'package:awesome_book/ads/add_mob_native_add.dart';
// import 'package:awesome_book/ads/native_ad.dart';
// import 'package:awesome_book/models/posts_model.dart';
// import 'package:awesome_book/models/stories_model.dart';
// import 'package:awesome_book/utils/sharedPrefs.dart';
// import 'package:awesome_book/widgets/mytext.dart';
// import 'package:awesome_book/widgets/storiesCircle.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:http/http.dart' as http;
// import 'package:awesome_book/utils/global.dart' as glb;

// class Home_scrn extends StatefulWidget {
//   const Home_scrn({super.key});

//   @override
//   State<Home_scrn> createState() => _Home_scrnState();
// }

// class _Home_scrnState extends State<Home_scrn> {
//   List<Post_model> PM = [];
//   List<StoryUser> SU = [];
//   ScrollController _scrollController = ScrollController();
//   bool isLoadingPosts = false;
//   bool isLoadingStories = false;
//   int page = 1;
//   final int limit = 10;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     _setupScrollListener();
//   }

//   void _initializeData() {
//     fetchPosts_async();
//     fetchStories_async();
//   }

//   void _setupScrollListener() {
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//               _scrollController.position.maxScrollExtent - 200 &&
//           !isLoadingPosts) {
//         fetchPosts_async();
//       }
//     });
//   }

//   Future<void> _refresh() async {
//     setState(() {
//       PM.clear();
//       SU.clear();
//       page = 1;
//     });

//     await Future.wait([
//       fetchPosts_async(),
//       fetchStories_async(),
//     ]);
//   }

//   /// ✅ Fetch Posts with guest handling (-1)
//   Future<void> fetchStories() async {
//     debugPrint("Fetching stories...");
//     if (glb.userDetails.id == null) return;

//     final url = Uri.parse(glb.API.GetStories);

//     try {
//       final res = await http.post(url, body: {'user_id': glb.userDetails.id});

//       if (res.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(res.body);
//         final List<StoryUser> loadedStories = [];

//         for (var storyUser in data) {
//           final List<Story> userStories =
//               (storyUser['stories'] as List).map((s) {
//             return Story(
//               imageUrl: glb.API.baseURL + s['imageUrl'].toString(),
//               timeAgo: s['timeAgo'].toString(),
//               storyId: s['story_id'].toString(),
//               storyType: s['type'].toString(),
//               viewed: s['viewed'].toString(),
//             );
//           }).toList();

//           loadedStories.add(StoryUser(
//             username: storyUser['username'].toString(),
//             userImage: glb.API.baseURL + storyUser['userImage'].toString(),
//             stories: userStories,
//             user_id: storyUser['user_id'].toString(),
//           ));
//         }

//         setState(() => stories = loadedStories);
//       }
//     } catch (e) {
//       print("Error fetching stories: $e");
//     }
//   }


 
//   Future<void> fetchStories_async() async {
//     if (isLoadingStories) return;

//     setState(() => isLoadingStories = true);
//     final currentUserId = glb.userDetails.id.isNotEmpty
//         ? glb.userDetails.id
//         : "-1"; // send -1 for guests
//     Uri url = Uri.parse(glb.API.GetStories);

//     try {
//       var res = await http.post(url, body: {'user_id': currentUserId});
//       print("Stories response = ${res.body}");

//       if (res.statusCode == 200) {
//         List<dynamic> responseData = jsonDecode(res.body);
//         List<StoryUser> newStories = [];

//         for (var storyUserData in responseData) {
//           String userId = storyUserData['user_id']?.toString().trim() ?? '';
//           String username = storyUserData['username']?.toString() ?? 'Unknown';
//           String userImage = storyUserData['userImage']?.toString() ?? '';

//           List<Story> stories = [];
//           List storiesData = storyUserData['stories'] ?? [];

//           for (var storyData in storiesData) {
//             stories.add(Story(
//               imageUrl: glb.API.baseURL +
//                   "public" +
//                   (storyData['imageUrl']?.toString() ?? ''),
//               timeAgo: storyData['timeAgo']?.toString() ?? '',
//               storyId: storyData['story_id']?.toString() ?? '',
//               storyType: storyData['type']?.toString() ?? '',
//               viewed: storyData['viewed']?.toString() ?? '0',
//             ));
//           }

//           newStories.add(StoryUser(
//             username: username,
//             userImage: glb.API.baseURL + userImage,
//             stories: stories,
//             user_id: userId,
//           ));
//         }

//         // ✅ Filter duplicates and maintain unique list
//         final uniqueStories = <StoryUser>[];
//         for (var s in newStories) {
//           if (!uniqueStories.any((u) =>
//               u.user_id.trim() == s.user_id.trim() ||
//               u.username.trim().toLowerCase() ==
//                   s.username.trim().toLowerCase())) {
//             uniqueStories.add(s);
//           }
//         }

//         setState(() {
//           SU = uniqueStories;
//         });
//       }
//     } catch (e) {
//       print("Error fetching stories: $e");
//     }

//     setState(() => isLoadingStories = false);
//   }
//     Future<void> fetchMyStories() async {
//     if (isLoading) return;
//     setState(() => isLoading = true);

//     final url = Uri.parse("${glb.API.GetMyStories}");

//     try {
//       final res = await http.post(url, body: {
//         'user_id': glb.userDetails.id,
//       });

//       if (res.statusCode == 200) {
//         final List<dynamic> body = jsonDecode(res.body);
//         final newPosts = body
//             .map((p) => MyStories(
//                   id: p['id'].toString(),
//                   storyURL: glb.API.baseURL + p['story'].toString(),
//                   type: p['p_type'].toString(),
//                   timeStamp: p['time_stamp'].toString(),
//                   status: p['status'].toString(),
//                   viewCount: p['viewers'].toList().length.toString(),
//                   viewersList: (p['viewers'] as List)
//                       .map<ViewerModel>((v) => ViewerModel(
//                             id: v['viewer_id'].toString(),
//                             name: v['viewer_name'].toString(),
//                             imageURL: glb.API.baseURL +
//                                 v['viewer_profileimg']
//                                     .toString(), // if image field exists
//                             timeStamp: v['viewTime'].toString(),
//                           ))
//                       .toList(),
//                 ))
//             .toList();

//         setState(() {
//           myStories.clear();
//           myStories.addAll(newPosts);
//           page++;
//         });
//       }
//     } catch (e) {
//       print("Error fetching my stories: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   /// ✅ Story Section (always one Your Story)
//   Widget _buildStoriesSection() {
//     final filteredStories = SU;

//     return SizedBox(
//       height: 15.h,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: filteredStories.length + 1,
//         itemBuilder: (context, index) {
//           if (index == 0) {
//             // ✅ Always single manual "Your Story"
//             return GestureDetector(
//               onTap: () async {
//                 if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1") {
//                   _showLoginPrompt(context);
//                   return;
//                 }

//                 final cameras = await availableCameras();
//                 final firstCamera = cameras.first;

//                 final XFile? capturedFile = await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CameraScrn(camera: firstCamera),
//                   ),
//                 );

//                 if (capturedFile != null) {
//                   final File mediaFile = File(capturedFile.path);
//                   final isImage =
//                       mediaFile.path.toLowerCase().endsWith('.jpg') ||
//                           mediaFile.path.toLowerCase().endsWith('.png');

//                   Uint8List imgBytes = Uint8List(0);
//                   if (isImage) imgBytes = await mediaFile.readAsBytes();

//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AddStory_scrn(
//                         img: imgBytes,
//                         type: isImage,
//                         mediaFile: mediaFile,
//                         myStories: SU,
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 2.w),
//                 child: Column(
//                   children: [
//                     Stack(
//                       alignment: Alignment.bottomRight,
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundColor: Colors.grey.shade300,
//                           backgroundImage: (glb.userDetails.profile_img !=
//                                       null &&
//                                   glb.userDetails.profile_img.isNotEmpty)
//                               ? NetworkImage(
//                                   glb.API.baseURL + glb.userDetails.profile_img)
//                               : null,
//                           child: (glb.userDetails.profile_img == null ||
//                                   glb.userDetails.profile_img.isEmpty)
//                               ? const Icon(Icons.person,
//                                   color: Colors.white, size: 28)
//                               : null,
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.blueAccent,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 2),
//                           ),
//                           child: const Icon(Icons.add,
//                               size: 18, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 0.8.h),
//                     const Text(
//                       "Your Story",
//                       style: TextStyle(fontSize: 12, color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           final storyUser = filteredStories[index - 1];
//           return StoriesCircle(
//             name: storyUser.username,
//             idx: index - 1,
//             storyUsers: filteredStories,
//             myStories: [],
//           );
//         },
//       ),
//     );
//   }

//   /// ✅ Show login dialog for guests
//   void _showLoginPrompt(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Login Required"),
//         content:
//             const Text("Please log in or register to perform this action."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, RouteGenerator.rt_login);
//             },
//             child: const Text("Login"),
//           ),
//         ],
//       ),
//     );
//   }

//   int _getAdCount() => PM.isEmpty ? 0 : (PM.length / 5).floor();

//   int _getPostIndex(int listIndex) {
//     int adsBefore = (listIndex / 6).floor();
//     return listIndex - adsBefore;
//   }

//   bool _shouldShowNativeAd(int index) => index > 0 && index % 6 == 0;

//   Widget _buildRandomAd() {
//     final adTypes = ['native', 'banner'];
//     final randomType = adTypes[DateTime.now().millisecondsSinceEpoch % 2];
//     if (randomType == 'native') {
//       return NativeAdWidget();
//     } else {
//       return AdBannerWidget();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     int totalItems = PM.length + _getAdCount();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xfff8faf8),
//         title: Image.asset('assets/images/icon.jpeg', height: 32),
//         centerTitle: true,
//         elevation: 1.0,
//         leading: IconButton(
//           icon: const Icon(Icons.camera_alt, color: Colors.black),
//           onPressed: () async {
//             if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1") {
//               _showLoginPrompt(context);
//               return;
//             }

//             final cameras = await availableCameras();
//             final firstCamera = cameras.first;
//             Navigator.of(context).push(
//               PageRouteBuilder(
//                 pageBuilder: (context, animation, secondaryAnimation) =>
//                     CameraScrn(camera: firstCamera),
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(-1.0, 0.0);
//                   const end = Offset.zero;
//                   const curve = Curves.easeInOut;
//                   var tween = Tween(begin: begin, end: end)
//                       .chain(CurveTween(curve: curve));
//                   var offsetAnimation = animation.drive(tween);
//                   return SlideTransition(
//                     position: offsetAnimation,
//                     child: child,
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.send, color: Colors.black),
//             onPressed: () {
//               if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1") {
//                 _showLoginPrompt(context);
//                 return;
//               }
//               Navigator.pushNamed(context, RouteGenerator.rt_msgLst);
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.person_add_alt_1_outlined,
//                 color: Colors.black),
//             onPressed: () async {
//               if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1") {
//                 _showLoginPrompt(context);
//                 return;
//               }
//               await Navigator.pushNamed(
//                   context, RouteGenerator.rt_followRequests);
//               if (glb.shouldRefreshProfile) setState(() {});
//             },
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refresh,
//         child: ListView(
//           controller: _scrollController,
//           children: [
//             if (glb.userDetails.id.isEmpty || glb.userDetails.id == "-1")
//               Container(
//                 color: Colors.blue.shade50,
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Log in to like, comment or post stories",
//                       style: TextStyle(color: Colors.black87),
//                     ),
//                     ElevatedButton(
//                       onPressed: () =>
//                           Navigator.pushNamed(context, RouteGenerator.rt_login),
//                       child: const Text("Login"),
//                     ),
//                   ],
//                 ),
//               ),
//             isLoadingStories
//                 ? SizedBox(
//                     height: 15.h,
//                     child: const Center(child: CircularProgressIndicator()),
//                   )
//                 : _buildStoriesSection(),
//             SizedBox(height: 1.h),
//             ListView.builder(
//               itemCount: totalItems + (isLoadingPosts ? 1 : 0),
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 if (index == totalItems) {
//                   return isLoadingPosts
//                       ? const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(16.0),
//                             child: CircularProgressIndicator(),
//                           ),
//                         )
//                       : const SizedBox();
//                 }

//                 if (_shouldShowNativeAd(index)) {
//                   return AdMobNativeAdWidget();
//                 }

//                 int postIndex = _getPostIndex(index);
//                 if (postIndex < PM.length) {
//                   return Posts_card(posts: PM[postIndex]);
//                 }

//                 return const SizedBox();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
