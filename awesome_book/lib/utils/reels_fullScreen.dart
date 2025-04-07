import 'dart:convert';

import 'package:awesome_book/models/comments_model.dart';
import 'package:awesome_book/models/posts_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:http/http.dart' as http;

class ReelsFull_scrn extends StatefulWidget {
  const ReelsFull_scrn({
    super.key,
    required this.reel,
  });

  final Post_model reel;

  @override
  State<ReelsFull_scrn> createState() => _ReelsFull_scrnState();
}

class _ReelsFull_scrnState extends State<ReelsFull_scrn> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isLiked = false;
  bool _isBookmarked = false;
  bool _showComments = false;
  double _videoProgress = 0.0;
  double opacity = 0;
  TextEditingController _commentController = TextEditingController();

  // Mock data for user account and comments
  // final Map<String, dynamic> _accountData = {
  //   'username': 'instagram_user',
  //   'profileImage': 'https://via.placeholder.com/150',
  //   'isVerified': true,
  //   'isFollowing': false,
  //   'caption': 'Enjoying my day! #reels #instagram',
  //   'music': '♫ Original Sound - instagram_user',
  // };

  final List<Map<String, dynamic>> _comments = [
    {
      'username': 'user1',
      'profileImage': 'https://via.placeholder.com/150',
      'comment': 'This is amazing! 🔥',
      'timeAgo': '2h',
      'likes': 24,
    },
    {
      'username': 'user2',
      'profileImage': 'https://via.placeholder.com/150',
      'comment': 'Love this content! Keep it up 👏',
      'timeAgo': '5h',
      'likes': 15,
    },
    {
      'username': 'user3',
      'profileImage': 'https://via.placeholder.com/150',
      'comment': 'Where is this place? Looks beautiful! 👌😍💕',
      'timeAgo': '1d',
      'likes': 8,
    },
    {
      'username': 'user4',
      'profileImage': 'https://via.placeholder.com/150',
      'comment': 'I need to visit there someday 😍',
      'timeAgo': '1d',
      'likes': 5,
    },
    {
      'username': 'user5',
      'profileImage': 'https://via.placeholder.com/150',
      'comment': 'The lighting is perfect!',
      'timeAgo': '2d',
      'likes': 3,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    setState(() {
      _isInitialized = false;
      _hasError = false;
    });

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(glb.API.baseURL + widget.reel.name),
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: false,
        mixWithOthers: false,
      ),
    );

    _controller.initialize().then((_) {
      setState(() {
        _isInitialized = true;
      });
      _controller.setLooping(true);
      _controller.play();

      // Add listener for video progress
      _controller.addListener(_updateVideoProgress);
    }).catchError((error) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load video: ${error.toString()}';
        print('Video player error: $_errorMessage');
      });
    });

    _controller.addListener(() {
      if (_controller.value.hasError) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'Video playback error: ${_controller.value.errorDescription}';
          print('Video player error: $_errorMessage');
        });
      }
    });
  }

  void _updateVideoProgress() {
    if (_controller.value.isInitialized &&
        _controller.value.duration.inMilliseconds > 0) {
      final double progress = _controller.value.position.inMilliseconds /
          _controller.value.duration.inMilliseconds;

      // Only update if the progress has actually changed
      if ((progress - _videoProgress).abs() > 0.01) {
        setState(() {
          _videoProgress = progress.clamp(0.0, 1.0);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateVideoProgress);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _toggleFollow() {
    setState(() {
      // widget.reel.isFollowing  = !_accountData['isFollowing'];
    });
  }

  List<CommentsModel> comments = [];
  _toggleComments() async {
    comments = [];
    Uri url = Uri.parse(glb.API.GetComments);

    try {
      var res = await http.post(url, body: {'post_id': widget.reel.id});
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
          _showComments = !_showComments;
        });
      }
    } catch (e) {}

    setState(() {
      _showComments = !_showComments;
    });
  }

  void _seekVideo(double position) {
    if (!_controller.value.isInitialized) return;

    final Duration duration = _controller.value.duration;
    print("Video duration = $duration");
    if (duration == Duration.zero) return;

    // Calculate the position in milliseconds
    final int milliseconds = (position * duration.inMilliseconds).round();

    // Ensure the position is within valid range
    final int clampedMilliseconds =
        milliseconds.clamp(0, duration.inMilliseconds);

    // Create a new duration with the clamped value
    final Duration newPosition = Duration(milliseconds: clampedMilliseconds);

    // Temporarily pause to make seeking smoother
    bool wasPlaying = _controller.value.isPlaying;
    if (wasPlaying) {
      _controller.pause();
    }

    // Perform the seek operation
    _controller.seekTo(newPosition).then((_) {
      // Resume playback if it was playing before
      if (wasPlaying) {
        _controller.play();
      }

      // Update the progress indicator with the actual position
      setState(() {
        _videoProgress = _controller.value.position.inMilliseconds /
            _controller.value.duration.inMilliseconds;
      });
    });
  }

  likePost_async(Post_model post) async {
    Uri url = Uri.parse(glb.API.AddLike);

    var res = await http.post(url, body: {
      'user_id': glb.userDetails.id,
      'post_id': post.id,
    });

    print(res.body);
  }

  void onDoubleTap(Post_model post) {
    setState(() {
      // isLiked = true;
      opacity = 1;
    });
    if (post.is_liked == '0') {
      likePost_async(post);
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video Player
          GestureDetector(
            onTap: _togglePlayPause,
            onDoubleTap: () {
              onDoubleTap(widget.reel);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ),
                if (!_isPlaying)
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 100.0,
                  ),
              ],
            ),
          ),

          // Video Progress Bar (only for current video)

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 30,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                      thumbColor: Colors.white,
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.grey.withOpacity(0.5),
                      overlayColor: Colors.white.withOpacity(0.3),
                    ),
                    child: Slider(
                      value: _videoProgress.clamp(0.0, 1.0),
                      onChanged: (value) {
                        setState(() {
                          _videoProgress = value;
                        });
                      },
                      onChangeEnd: (value) {
                        _seekVideo(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Caption and User Info (Bottom Left)
          Positioned(
            bottom: 80,
            left: 10,
            right: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                          glb.API.baseURL + widget.reel.profileImage),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.reel.user_name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    if (widget.reel.verified == '1')
                      Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 14,
                      ),
                    SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _toggleFollow,
                      child: Text(
                        widget.reel.isFollowing == '1' ? 'Following' : 'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white),
                        minimumSize: Size(20, 30),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.reel.caption,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),

          // Action Buttons (Right)
          Positioned(
            bottom: 2.h,
            right: 2.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.sp),
                  bottomLeft: Radius.circular(15.sp),
                ),
              ),
              child: Column(
                children: [
                  // Like Button
                  Column(
                    children: [
                      IconButton(
                        icon: widget.reel.is_liked == '1'
                            ? Icon(Icons.favorite, color: Colors.red, size: 28)
                            : Icon(CupertinoIcons.heart,
                                color: Colors.white, size: 24),
                        onPressed: _toggleLike,
                      ),
                      Text(
                        widget.reel.no_likes,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Comment Button
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(CupertinoIcons.chat_bubble,
                            color: Colors.white, size: 24),
                        onPressed: _toggleComments,
                      ),
                      Text(
                        widget.reel.no_comments,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Share Button
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(CupertinoIcons.share,
                            color: Colors.white, size: 24),
                        onPressed: () {
                          // Add share functionality
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 15),

                  // Bookmark Button
                  IconButton(
                    icon: _isBookmarked
                        ? Icon(Icons.bookmark, color: Colors.white, size: 28)
                        : Icon(CupertinoIcons.bookmark,
                            color: Colors.white, size: 24),
                    onPressed: _toggleBookmark,
                  ),
                  SizedBox(height: 15),

                  // More Options
                  IconButton(
                    icon: Icon(Icons.more_horiz, color: Colors.white, size: 24),
                    onPressed: () {
                      // Show more options
                    },
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator at the bottom for infinite scroll
          // if ( isLoading)
          // Positioned(
          //   bottom: 10,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: CircularProgressIndicator(
          //       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //     ),
          //   ),
          // ),

          // Comments Section (Slide Up)
          if (_showComments)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {}, // Prevent tap from closing comments
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Comments Header
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      'Comments',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          _showComments = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey.shade800),

                              // Comments List
                              Expanded(
                                child: comments.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No comments yet',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: comments.length,
                                        itemBuilder: (context, index) {
                                          final comment = comments[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 14,
                                                  backgroundImage: NetworkImage(
                                                      glb.API.baseURL +
                                                          comment.user_img),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        comment.user_name,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        comment.comment,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        comment.date_time,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ),

                              // Comment Input
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(
                                          glb.API.baseURL +
                                              glb.userDetails.profile_img),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _commentController,
                                        decoration: InputDecoration(
                                          hintText: 'Add a comment...',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Post comment
                                        if (_commentController
                                            .text.isNotEmpty) {
                                          // In a real app, you would send this to your API
                                          print(
                                              'Posted comment: ${_commentController.text}');

                                          uploadComment(widget.reel,
                                              _commentController.text.trim());
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Positioned.fill(
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: opacity,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  uploadComment(Post_model post, String comment) async {
    Uri url = Uri.parse(glb.API.uploadComment);

    var newComment = CommentsModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
      user_id: glb.userDetails.id,
      post_id: post.id,
      date_time: DateTime.now().toString(), // Temporary timestamp
      comment: comment,
      user_name: glb.userDetails.name, // Get from user details
      user_img: glb.userDetails.profile_img, // Get from user details
    );

    setState(() {
      comments.insert(0, newComment); // Add the new comment at the top
      post.no_comments = (int.parse(post.no_comments) + 1).toString();
      _showComments = false;
      _showComments = true;
    });

    var res = await http.post(url, body: {
      'post_id': post.id,
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

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Loading video...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'Failed to load video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _initializeVideoPlayer();
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // You could add URL validation or debugging info here
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Video URL'),
                    content: SelectableText(glb.API.baseURL + widget.reel.name),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Check URL', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}
