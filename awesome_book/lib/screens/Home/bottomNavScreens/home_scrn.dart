import 'dart:convert';
import 'package:awesome_book/Cards/posts_card.dart';
import 'package:awesome_book/Image/Camera_scrn.dart';
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

  @override
  Widget build(BuildContext context) {
    int totalItems = PM.length + _getAdCount();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff8faf8),
        // title: ShaderMask(
        //   shaderCallback: (bounds) => LinearGradient(
        //     colors: [Colors.blue, Colors.purple, Colors.red],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ).createShader(bounds),
        //   child: Text(
        //     "Awesomebook",
        //     style: TextStyle(
        //       fontSize: 18,
        //       fontFamily: 'igronte',
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        title: Image.asset(
          'assets/images/icon.jpeg',
          height: 32,
        ),
        centerTitle: true,
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {
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
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                Navigator.pushNamed(context, RouteGenerator.rt_msgLst);
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          controller: _scrollController,
          children: [
            // Stories Section
            SizedBox(
              height: 15.h,
              child: SU.isEmpty && isLoadingStories
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: SU.length,
                      itemBuilder: (context, index) {
                        return StoriesCircle(
                          name: 'Story $index',
                          idx: index,
                          storyUsers: SU,
                        );
                      },
                    ),
            ),
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
