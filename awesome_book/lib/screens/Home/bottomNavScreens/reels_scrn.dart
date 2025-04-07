import 'dart:convert';

import 'package:awesome_book/models/comments_model.dart';
import 'package:awesome_book/models/posts_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:http/http.dart' as http;

class Reels_scrn extends StatefulWidget {
  const Reels_scrn({
    super.key,
  });

  @override
  State<Reels_scrn> createState() => _Reels_scrnState();
}

class _Reels_scrnState extends State<Reels_scrn> {
  late PageController _pageController;
  Map<int, VideoPlayerController> _controllers = {};
  late TextEditingController _commentController;
  int _currentIndex = 0;
  bool _isPlaying = true;
  bool _isLiked = false;
  bool _isBookmarked = false;
  bool _showComments = false;
  double _videoProgress = 0.0;

  bool isLoading = false;
  double opacity = 0;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _pageController = PageController();
    fetchPosts_async();
  }

  int page = 1;
  final int limit = 10;

  List<Post_model> PM = [];
  Future<void> fetchPosts_async() async {
    if (isLoading || !hasMoreData) return;
    setState(() => isLoading = true);

    Uri url = Uri.parse("${glb.API.GetReels}?page=$page&limit=$limit");
    print("Fetching: $url");

    try {
      var res = await http.post(url, body: {'follower_id': '1'});
      print("post body = ${res.body}");
      if (res.statusCode == 200) {
        List<dynamic> body = jsonDecode(res.body);

        if (body.isEmpty) {
          setState(() {
            hasMoreData = false;
            isLoading = false;
          });
          return;
        }

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

        // Initialize controllers for new videos
        for (int i = PM.length - newPosts.length; i < PM.length; i++) {
          _initializeVideoController(i);
        }
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }

    setState(() => isLoading = false);
  }

  void _initializeVideoController(int index) {
    if (_controllers.containsKey(index)) return;

    final videoUrl = glb.API.baseURL + PM[index].name;
    print("Initializing video at index $index: $videoUrl");

    _controllers[index] = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: false,
        mixWithOthers: false,
      ),
    );

    _controllers[index]!.initialize().then((_) {
      // Only play if this is the current video
      if (index == _currentIndex) {
        _controllers[index]!.play();
        _controllers[index]!.setLooping(true);
      }

      // Force a rebuild to show the initialized video
      if (mounted) setState(() {});

      // Add listener for video progress
      _controllers[index]!.addListener(() {
        _updateVideoProgress(index);
      });
    }).catchError((error) {
      print('Video player error for index $index: ${error.toString()}');
    });
  }

  void _updateVideoProgress(int index) {
    if (index != _currentIndex) return;

    final controller = _controllers[index];
    if (controller != null &&
        controller.value.isInitialized &&
        controller.value.duration.inMilliseconds > 0) {
      final double progress = controller.value.position.inMilliseconds /
          controller.value.duration.inMilliseconds;

      // Only update if the progress has actually changed
      if ((progress - _videoProgress).abs() > 0.01) {
        setState(() {
          _videoProgress = progress.clamp(0.0, 1.0);
        });
      }
    }
  }

  void _onPageChanged(int index) {
    // Check if we need to load more data
    if (index >= PM.length - 2 && !isLoading && hasMoreData) {
      fetchPosts_async();
    }
    _showComments = false;

    // Pause the previous video
    if (_controllers.containsKey(_currentIndex)) {
      _controllers[_currentIndex]!.pause();
    }

    setState(() {
      _currentIndex = index;
      _isPlaying = true;
      _isLiked = PM[index].is_liked == '1';
      _isBookmarked = false;
      _videoProgress = 0.0;
    });

    // Initialize the controller if it doesn't exist
    if (!_controllers.containsKey(index)) {
      _initializeVideoController(index);
    } else if (_controllers[index]!.value.isInitialized) {
      // Play the current video if it's already initialized
      _controllers[index]!.play();
      _controllers[index]!.setLooping(true);
    }

    // Preload the next video
    if (index + 1 < PM.length && !_controllers.containsKey(index + 1)) {
      _initializeVideoController(index + 1);
    }
  }

  @override
  void dispose() {
    // Dispose all video controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controllers.containsKey(_currentIndex)) {
      setState(() {
        if (_controllers[_currentIndex]!.value.isPlaying) {
          _controllers[_currentIndex]!.pause();
          _isPlaying = false;
        } else {
          _controllers[_currentIndex]!.play();
          _isPlaying = true;
        }
      });
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      // Update the like count in the model
      if (_isLiked) {
        PM[_currentIndex].no_likes =
            (int.parse(PM[_currentIndex].no_likes) + 1).toString();
      } else {
        PM[_currentIndex].no_likes =
            (int.parse(PM[_currentIndex].no_likes) - 1).toString();
      }
      PM[_currentIndex].is_liked = _isLiked ? '1' : '0';
    });
    // Here you would typically call an API to update the like status
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _toggleFollow() {
    setState(() {
      // Toggle following status
      bool isFollowing = PM[_currentIndex].isFollowing == '1';
      PM[_currentIndex].isFollowing = isFollowing ? '0' : '1';
    });
    // Here you would typically call an API to update the follow status
  }

  List<CommentsModel> comments = [];
  _toggleComments() async {
    if (PM.isEmpty) return;

    comments = [];
    Uri url = Uri.parse(glb.API.GetComments);

    try {
      var res = await http.post(url, body: {'post_id': PM[_currentIndex].id});
      print("Comments response: ${res.statusCode}");
      print(res.body);

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        List b = body;

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
        }
      }
    } catch (e) {
      print("Error fetching comments: $e");
    }

    setState(() {
      _showComments = !_showComments;
    });
  }

  void _seekVideo(double position) {
    if (!_controllers.containsKey(_currentIndex) ||
        !_controllers[_currentIndex]!.value.isInitialized) return;

    final controller = _controllers[_currentIndex]!;
    final Duration duration = controller.value.duration;
    if (duration == Duration.zero) return;

    // Calculate the position in milliseconds
    final int milliseconds = (position * duration.inMilliseconds).round();

    // Ensure the position is within valid range
    final int clampedMilliseconds =
        milliseconds.clamp(0, duration.inMilliseconds);

    // Create a new duration with the clamped value
    final Duration newPosition = Duration(milliseconds: clampedMilliseconds);

    // Temporarily pause to make seeking smoother
    bool wasPlaying = controller.value.isPlaying;
    if (wasPlaying) {
      controller.pause();
    }

    // Perform the seek operation
    controller.seekTo(newPosition).then((_) {
      // Resume playback if it was playing before
      if (wasPlaying) {
        controller.play();
      }

      // Update the progress indicator with the actual position
      setState(() {
        _videoProgress = controller.value.position.inMilliseconds /
            controller.value.duration.inMilliseconds;
      });
    });
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 1.h),
          Text(
            'Loading video...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
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
              errorMessage,
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _initializeVideoController(_currentIndex);
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (PM.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: _buildLoadingWidget(),
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        itemCount: PM.length,
        itemBuilder: (context, index) {
          final reel = PM[index];
          final hasController = _controllers.containsKey(index);
          final controller = hasController ? _controllers[index] : null;
          final isInitialized = controller?.value.isInitialized ?? false;
          final hasError = controller?.value.hasError ?? false;

          return Stack(
            children: [
              // Video Player
              GestureDetector(
                onTap: _togglePlayPause,
                onDoubleTap: () {
                  onDoubleTap(reel);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    hasController && isInitialized && !hasError
                        ? Center(
                            child: AspectRatio(
                              aspectRatio: controller!.value.aspectRatio,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: controller.value.size.width,
                                  height: controller.value.size.height,
                                  child: VideoPlayer(controller),
                                ),
                              ),
                            ),
                          )
                        : hasController && hasError
                            ? _buildErrorWidget("Error loading video")
                            : _buildLoadingWidget(),
                    if (index == _currentIndex && !_isPlaying)
                      Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                      ),
                  ],
                ),
              ),

              // Video Progress Bar (only for current video)
              if (index == _currentIndex)
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
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 12),
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
                          backgroundImage:
                              NetworkImage(glb.API.baseURL + reel.profileImage),
                        ),
                        SizedBox(width: 10),
                        Text(
                          reel.user_name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        if (reel.verified == '1')
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 14,
                          ),
                        SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: _toggleFollow,
                          child: Text(
                            reel.isFollowing == '1' ? 'Following' : 'Follow',
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
                      reel.caption,
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
                            icon: reel.is_liked == '1'
                                ? Icon(Icons.favorite,
                                    color: Colors.red, size: 28)
                                : Icon(CupertinoIcons.heart,
                                    color: Colors.white, size: 24),
                            onPressed:
                                index == _currentIndex ? _toggleLike : null,
                          ),
                          Text(
                            reel.no_likes,
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
                            onPressed:
                                index == _currentIndex ? _toggleComments : null,
                          ),
                          Text(
                            reel.no_comments,
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
                        icon: index == _currentIndex && _isBookmarked
                            ? Icon(Icons.bookmark,
                                color: Colors.white, size: 28)
                            : Icon(CupertinoIcons.bookmark,
                                color: Colors.white, size: 24),
                        onPressed:
                            index == _currentIndex ? _toggleBookmark : null,
                      ),
                      SizedBox(height: 15),

                      // More Options
                      IconButton(
                        icon: Icon(Icons.more_horiz,
                            color: Colors.white, size: 24),
                        onPressed: () {
                          // Show more options
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Loading indicator at the bottom for infinite scroll
              if (index == PM.length - 1 && isLoading)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),

              // Comments Section (Slide Up)
              if (index == _currentIndex && _showComments)
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
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
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: comments.length,
                                            itemBuilder: (context, index) {
                                              final comment = comments[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 10,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 14,
                                                      backgroundImage:
                                                          NetworkImage(glb
                                                                  .API.baseURL +
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
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          SizedBox(height: 3),
                                                          Text(
                                                            comment.comment,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            comment.date_time,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
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
                                            style:
                                                TextStyle(color: Colors.white),
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

                                              uploadComment(
                                                  reel,
                                                  _commentController.text
                                                      .trim());
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
          );
        },
      ),
    );
  }
}
