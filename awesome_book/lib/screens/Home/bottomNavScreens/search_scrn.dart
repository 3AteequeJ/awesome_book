import 'dart:convert';
import 'package:awesome_book/models/posts_model.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/search2_scrn.dart';
import 'package:awesome_book/utils/post_fullscreen.dart';
import 'package:awesome_book/utils/reels_fullScreen.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:video_player/video_player.dart';

class Search_scrn extends StatefulWidget {
  const Search_scrn({super.key});

  @override
  State<Search_scrn> createState() => _Search_scrnState();
}

class _Search_scrnState extends State<Search_scrn> {
  List<Post_model> posts = [];
  bool isLoading = false;
  int page = 1;
  final int limit = 10;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchForUPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading) {
        fetchForUPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      posts.clear();
      page = 1;
    });
    await fetchForUPosts();
  }

  Future<void> fetchForUPosts() async {
    print("Fetching posts for u ");
    if (isLoading) return;
    setState(() => isLoading = true);

    Uri url = Uri.parse("${glb.API.Get_foryouPosts}?page=$page&limit=$limit");

    try {
      var res = await http.post(url, body: {'follower_id': '1'});
      if (res.statusCode == 200) {
        List<dynamic> body = jsonDecode(res.body);
        List<Post_model> newPosts = body
            .map((p) => Post_model(
                  id: p['id'].toString(),
                  name: "public/" + (p['p_name'] ?? ''),
                  user_name: p['user_name'].toString(),
                  type: p['p_type'].toString(),
                  caption: p['caption'].toString(),
                  dateTime: p['timestamp'].toString(),
                  no_likes: p['like_count'].toString(),
                  no_comments: p['comment_count'].toString(),
                  isFollowing: p['is_following'].toString(),
                  profileImage: p['profile_image'] ?? '',
                  verified: p['verified'].toString(),
                  is_liked: p['is_liked'].toString(),
                ))
            .toList();

        setState(() {
          posts.addAll(newPosts);
          page++;
        });
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.all(12.sp),
            child: Material(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: TextField(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const Search2_scrn(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var tween = Tween(
                                begin: const Offset(0.0, 1.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeInOut));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                decoration: InputDecoration(
                  hintText: "Search people",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                ),
              ),
            ),
          ),
          isLoading && posts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : MasonryGridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 3,
                  itemCount: posts.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GridTile(index, posts[index]);
                  },
                ),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class GridTile extends StatefulWidget {
  final int index;
  final Post_model post;

  const GridTile(this.index, this.post, {super.key});

  @override
  State<GridTile> createState() => _GridTileState();
}

class _GridTileState extends State<GridTile> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(glb.API.baseURL + widget.post.name))
      ..initialize().then((_) {
        setState(() {});

        _controller.setLooping(true);
      }).onError((e, s) {});
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.index % 12 == 0 ||
        widget.index % 12 == 5 ||
        widget.index % 12 == 6 ||
        widget.index % 12 == 11;
    final height = isVertical ? 2 : 1.3;

    return InkWell(
      onTap: () {
        widget.post.type == '0'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostFullscreen(
                    post: widget.post,
                  ),
                ),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReelsFull_scrn(
                    reel: widget.post,
                  ),
                ),
              );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          // borderRadius: BorderRadius.circular(8),
        ),
        child: AspectRatio(
          aspectRatio: 1 / height,
          child: ClipRRect(
            // borderRadius: BorderRadius.circular(8),
            child: widget.post.type == '0'
                ? Image.network(
                    glb.API.baseURL + widget.post.name,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                      );
                    },
                  )
                : VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}
