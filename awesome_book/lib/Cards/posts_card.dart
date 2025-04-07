import 'dart:convert';

import 'package:awesome_book/models/comments_model.dart';
import 'package:awesome_book/models/posts_model.dart';
import 'package:awesome_book/utils/reels_fullScreen.dart';
import 'package:awesome_book/widgets/mytext.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:http/http.dart' as http;

class Posts_card extends StatefulWidget {
  const Posts_card({
    super.key,
    required this.posts,
  });
  final Post_model posts;
  @override
  State<Posts_card> createState() => _Posts_cardState();
}

class _Posts_cardState extends State<Posts_card> {
  late VideoPlayerController _controller;
  final String _postId = UniqueKey().toString();
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
        Uri.parse(glb.API.baseURL + widget.posts.name))
      ..initialize().then((_) {
        setState(() {});

        _controller.setLooping(true);
      }).onError((e, s) {});
    // _controller = VideoPlayerController.asset("assets/videos/insta.mp4")
    //   ..initialize().then((_) {
    //     setState(() {});
    //     // Don't auto-play here, we'll control playback based on visibility
    //     _controller.setLooping(true);
    //   });
    _controller.addListener(() {
      if (_controller.value.hasError) {
        print("Video Player Error: ${_controller.value.errorDescription}");
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  double opacity = 0;
  void _handleVisibilityChanged(VisibilityInfo info) {
    // If more than 50% of the widget is visible, play the video
    if (info.visibleFraction > 0.5) {
      _controller.play();
      _isPlaying = true;
      setState(() {});
    } else {
      _controller.pause();
      _isPlaying = false;
      setState(() {});
    }
  }

  void _showCommentsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal take up the full height
      backgroundColor: Colors.transparent,

      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return CommentsBottomSheet(post: widget.posts);
            }));
      },
    );
  }

  likePost_async() async {
    Uri url = Uri.parse(glb.API.AddLike);

    var res = await http.post(url, body: {
      'user_id': glb.userDetails.id,
      'post_id': widget.posts.id,
    });

    print(res.body);
  }

  void onDoubleTap() {
    print("${widget.posts.id}\n${glb.userDetails.id}");
    setState(() {
      // isLiked = true;
      opacity = 1;
    });
    if (widget.posts.is_liked == '0') {
      likePost_async();
    }

    // Fade out the heart icon after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opacity = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(12.sp),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage:
                      NetworkImage(glb.API.baseURL + widget.posts.profileImage),
                ),
              ),
              Text(widget.posts.user_name,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              widget.posts.verified == '1' ? Icon(Icons.verified) : Container(),
            ],
          ),
          InkWell(
            onDoubleTap: onDoubleTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100.w,
                  height: widget.posts.type == '0' ? 100.w : 50.h,
                  child: widget.posts.type == '0'
                      ? InteractiveViewer(
                          panEnabled: false, // Prevent panning
                          boundaryMargin: EdgeInsets.all(0),
                          minScale: 1.0,
                          maxScale: 4.0, // Allows zoom up to 4x
                          child: Image.network(
                            fit: BoxFit.contain,
                            // "https://awesomebook.in/awesomebookbackend/public/images/post_images/" +
                            glb.API.baseURL + widget.posts.name,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Txt(
                                    text:
                                        "Something went worng \n ${widget.posts.name}"),
                              );
                            },
                          ),
                        )
                      : VisibilityDetector(
                          key: Key(_postId),
                          onVisibilityChanged: _handleVisibilityChanged,
                          child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Builder(builder: (context) {
                                  return InkWell(
                                      onTap: () {
                                        // print(glb.API.baseURL + widget.posts.name);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReelsFull_scrn(
                                                        reel: widget.posts)));
                                      },
                                      child: VideoPlayer(_controller));
                                }),
                                IconButton(
                                    onPressed: () {
                                      _isPlaying
                                          ? {
                                              _controller.pause(),
                                              setState(() {
                                                _isPlaying = false;
                                              })
                                            }
                                          : {
                                              _controller.play(),
                                              setState(() {
                                                _isPlaying = true;
                                              })
                                            };
                                    },
                                    icon: Icon(_isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow))
                              ]),
                        ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: opacity,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 100,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          (widget.posts.is_liked == '1')
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: (widget.posts.is_liked == '1')
                              ? Colors.red
                              : Colors.grey,
                        ),
                        Container(
                          height: 2.h,
                          constraints: BoxConstraints(maxWidth: 10.w),
                          child: Txt(text: widget.posts.no_likes),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.sp),
                      child: InkWell(
                        onTap: _showCommentsModal,
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.chat_bubble),
                            Container(
                              height: 2.h,
                              constraints: BoxConstraints(maxWidth: 10.w),
                              child: Txt(text: widget.posts.no_comments),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.sp),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.paperplane),
                          Container(
                            width: 10.w,
                            height: 2.h,
                            constraints: BoxConstraints(maxWidth: 10.w),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 15.w,
                      height: 2.h,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 2.w,
                            backgroundColor: Colors.red.shade300,
                          ),
                          CircleAvatar(
                            radius: 2.w,
                            backgroundColor: Colors.yellow.shade300,
                          ),
                          CircleAvatar(
                            radius: 2.w,
                            backgroundColor: Colors.green.shade300,
                          ),
                        ],
                      ),
                    ),
                    Text(' Liked by atq_J and 12 others'),
                  ],
                ),
                Row(
                  children: [
                    Txt(
                      text: 'atq_J',
                      fntWt: FontWeight.bold,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Txt(text: widget.posts.caption)
                  ],
                ),
                Txt(
                    text: glb.getDuration(widget.posts.dateTime),
                    fntWt: FontWeight.w500),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentsBottomSheet extends StatefulWidget {
  final Post_model post;

  const CommentsBottomSheet({Key? key, required this.post}) : super(key: key);

  @override
  _CommentsBottomSheetState createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    _toggleComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  List<CommentsModel> comments = [];
  _toggleComments() async {
    comments = [];
    Uri url = Uri.parse(glb.API.GetComments);

    try {
      var res = await http.post(url, body: {'post_id': widget.post.id});
      print("body hai");
      print(res.statusCode);
      print(res.body);
      var body = jsonDecode(res.body);
      List b = jsonDecode(res.body);

      for (var i = 0; i < b.length; i++) {
        comments.add(CommentsModel(
          id: body[i]['id'].toString(),
          user_id: body[i]['user_id'].toString(),
          post_id: body[i]['post_id'].toString(),
          date_time: body[i]['date/time'].toString(),
          comment: body[i]['comments'].toString(),
          user_name: body[i]['user_name'].toString(),
          user_img: body[i]['profile_image'].toString(),
        ));
        setState(() {
          widget.post.no_comments = b.length.toString();
        });
        // setState(() {
        //   _showComments = !_showComments;
        // });
      }
    } catch (e) {}

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          // Handle bar at the top
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Comments header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(),
          // Comments list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            NetworkImage(glb.API.baseURL + comment.user_img),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: comment.user_name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Text(comment.comment),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  glb.getDuration(comment.date_time),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 12),
                                // Text(
                                //   'Reply',
                                //   style: TextStyle(
                                //     color: Colors.grey[600],
                                //     fontSize: 12,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(CupertinoIcons.heart, size: 16),
                      //   onPressed: () {},
                      //   padding: EdgeInsets.zero,
                      //   constraints: BoxConstraints(),
                      // ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Comment input field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
              color: Colors.white,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                        glb.API.baseURL + widget.post.profileImage),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment ...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add comment functionality would go here
                      if (_commentController.text.isNotEmpty) {
                        // In a real app, you would send this to your API
                        print('Posted comment: ${_commentController.text}');
                        // _commentController.clear();
                        uploadComment();
                      }
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  uploadComment() async {
    Uri url = Uri.parse(glb.API.uploadComment);

    var newComment = CommentsModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
      user_id: glb.userDetails.id,
      post_id: widget.post.id,
      date_time: DateTime.now().toString(), // Temporary timestamp
      comment: _commentController.text.trim(),
      user_name: glb.userDetails.name, // Get from user details
      user_img: glb.userDetails.profile_img, // Get from user details
    );

    setState(() {
      comments.insert(0, newComment); // Add the new comment at the top
    });

    _commentController.clear(); // Clear text field

    var res = await http.post(url, body: {
      'post_id': widget.post.id,
      'user_id': glb.userDetails.id,
      'comments': newComment.comment,
    });

    print(res.body);

    if (res.body != '1') {
      // If API call fails, remove the temporary comment
      setState(() {
        comments.add(newComment);
      });
    }
  }
}
