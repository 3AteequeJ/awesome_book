import 'dart:convert';
import 'package:awesome_book/Cards/posts_card.dart';
import 'package:awesome_book/Image/Camera_scrn.dart';
import 'package:awesome_book/Route/router.dart';
import 'package:awesome_book/models/posts_model.dart';
import 'package:awesome_book/models/stories_model.dart';
import 'package:awesome_book/try/camera.dart';
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
  bool isLoading = false;
  int page = 1;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    fetchPosts_async();
    // fetchStories_async();

    // Attach scroll listener for infinite scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading) {
        fetchPosts_async();
      }
    });
  }

  Future<void> _refresh() async {
    setState(() {
      PM.clear();
      page = 1;
    });
    // fetchStories_async();
    await fetchPosts_async();
  }

  Future<void> fetchPosts_async() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    Uri url = Uri.parse("${glb.API.GetPosts}?page=$page&limit=$limit");
    // print("Fetching: $url");

    try {
      var res = await http.post(url, body: {'follower_id': '1'});
      print("pot bdy = ${res.body}");
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

    setState(() => isLoading = false);
  }

  Future<void> fetchStories_async() async {
    print("Fetching stories...");
    // List<StoryUser> story_users = [];
    if (isLoading) return;
    setState(() => isLoading = true);

    Uri url = Uri.parse("${glb.API.GetStories}");
    // print("Fetching: $url");

    try {
      var res = await http.post(url, body: {'user_id': glb.userDetails.id});
      print("pot bdy = ${res.body}");
      if (res.statusCode == 200) {
        for (var i = 0; i < 5; i++) {
          var story = jsonDecode(res.body)[i];
          String username = story['username'].toString();
          String userImage = story['userImage'].toString();

          List<Story> stories = [];

          for (var j = 0; j < 5; j++) {
            var storyData = jsonDecode(res.body)[i]['stories'][j];
            stories.add(Story(
              imageUrl: glb.API.baseURL +
                  "public/" +
                  storyData['imageUrl'].toString(),
              timeAgo: storyData['timestamp'].toString(),
            ));
          }
          SU.add(StoryUser(
            username: username,
            userImage: glb.API.baseURL + "public/" + userImage,
            stories: stories,
          ));
        }
        // stories.add(StoryUser(

        //     username: username, userImage: userImage, stories: stories));
        setState(() {
          // SU = story_users;
          // page++;
        });
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff8faf8),
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
            SizedBox(
              height: 15.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: SU.length,
                itemBuilder: (context, index) {
                  return StoriesCircle(
                    name: 'Story $index',
                    idx: index,
                  );
                },
              ),
            ),
            SizedBox(height: 1.h),
            ListView.builder(
              itemCount: PM.length + 1,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == PM.length) {
                  return isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox();
                }
                return Posts_card(posts: PM[index]);
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
