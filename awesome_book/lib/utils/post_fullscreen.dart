import 'dart:convert';

import 'package:awesome_book/models/comments_model.dart';
import 'package:awesome_book/models/posts_model.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:http/http.dart' as http;

class PostFullscreen extends StatefulWidget {
  const PostFullscreen({
    super.key,
    required this.post,
  });
  final Post_model post;
  @override
  State<PostFullscreen> createState() => _PostFullscreenState();
}

class _PostFullscreenState extends State<PostFullscreen> {
  double opacity = 0;

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
              return CommentsBottomSheet(post: widget.post);
            }));
      },
    );
  }

  void onDoubleTap() {
    setState(() {
      // isLiked = true;
      opacity = 1;
    });
    if (widget.post.is_liked == '0') {
      likePost_async();
    }

    // Fade out the heart icon after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opacity = 0;

        if (widget.post.is_liked == '0') {
          widget.post.is_liked = '1';
          widget.post.no_likes =
              (int.parse(widget.post.no_likes) + 1).toString();
        }
      });
    });
  }

  likePost_async() async {
    Uri url = Uri.parse(glb.API.AddLike);

    var res = await http.post(url, body: {
      'user_id': glb.userDetails.id,
      'post_id': widget.post.id,
    });

    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          color: Colors.grey.shade100,
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
                      backgroundImage: NetworkImage(
                          glb.API.baseURL + widget.post.profileImage),
                    ),
                  ),
                  Text(widget.post.user_name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  widget.post.verified == '1'
                      ? Icon(Icons.verified)
                      : Container(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        side: BorderSide(color: Colors.grey, width: 2),
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {},
                      child: Txt(text: "Following"))
                ],
              ),
              InkWell(
                onDoubleTap: onDoubleTap,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        width: 100.w,
                        height: widget.post.type == '0' ? 100.w : 50.h,
                        child: InteractiveViewer(
                          panEnabled: false, // Prevent panning
                          boundaryMargin: EdgeInsets.all(0),
                          minScale: 1.0,
                          maxScale: 4.0, // Allows zoom up to 4x
                          child: Image.network(
                            fit: BoxFit.contain,
                            // "https://awesomebook.in/awesomebookbackend/public/images/post_images/" +
                            glb.API.baseURL + widget.post.name,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Txt(
                                    text:
                                        "Something went worng \n ${widget.post.name}"),
                              );
                            },
                          ),
                        )),
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
                              (widget.post.is_liked == '1')
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: (widget.post.is_liked == '1')
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            Container(
                              // height: 2.h,
                              constraints: BoxConstraints(maxWidth: 10.w),
                              child: Txt(text: widget.post.no_likes),
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
                                  // height: 2.h,
                                  constraints: BoxConstraints(maxWidth: 10.w),
                                  child: Txt(text: widget.post.no_comments),
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
                                // height: 2.h,
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
                        Txt(text: widget.post.caption)
                      ],
                    ),
                    Txt(
                        text: glb.getDuration(widget.post.dateTime),
                        fntWt: FontWeight.w500),
                  ],
                ),
              ),
            ],
          ),
        ));
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
      widget.post.no_comments =
          (int.parse(widget.post.no_comments) + 1).toString();
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
