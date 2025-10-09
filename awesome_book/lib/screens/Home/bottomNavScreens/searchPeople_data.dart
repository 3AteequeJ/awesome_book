import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:awesome_book/widgets/mytext.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isProcessing = false;
  bool isFollowing = false;
  List<dynamic> userPosts = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // -------------------- API CALLS --------------------

  Future<void> fetchUserData() async {
    try {
      final url =
          Uri.parse("https://awesomebook.in/awesomebookbackend/userData");
      final res = await http.post(url, body: {"user_id": widget.userId});

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final decoded = jsonDecode(res.body);
        if (decoded is Map) {
          final data = Map<String, dynamic>.from(decoded);

          setState(() {
            userData = {
              "id": (data["id"] ?? "").toString(),
              "user_name": data["user_name"] ?? "",
              "bio": data["bio"] ?? "",
              "profile_img": data["profile_image"] ?? "",
              "verified": (data["verified"] ?? "0").toString(),
              "no_posts": (data["total_posts"] ?? 0).toString(),
              "no_follower": (data["total_followers"] ?? 0).toString(),
              "no_following": (data["total_following"] ?? 0).toString(),
              // If backend later returns this, we’ll respect it; else default 0
              "is_following": (data["is_following"] ?? "0").toString(),
            };
            isFollowing = userData!["is_following"] == "1";
          });

          if (isFollowing) {
            await fetchUserPosts();
          }
        }
      }
    } catch (e) {
      debugPrint("❌ fetchUserData error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchUserPosts() async {
    try {
      final url =
          Uri.parse("https://awesomebook.in/awesomebookbackend/GetMyPosts");
      final res = await http.post(url, body: {"user_id": widget.userId});

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final body = jsonDecode(res.body);
        if (body is List) {
          // Log a few items for sanity
          for (var i = 0; i < body.length && i < 5; i++) {
            debugPrint("🖼 RAW p_name -> ${body[i]["p_name"]}");
          }
          setState(() => userPosts = body);
        }
      }
    } catch (e) {
      debugPrint("❌ fetchUserPosts error: $e");
    }
  }

  Future<void> toggleFollow() async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    try {
      final followerId = glb.userDetails.id; // logged-in user
      final followingId = widget.userId; // visited user

      final url =
          Uri.parse("https://awesomebook.in/awesomebookbackend/unfollow");
      final res = await http.post(url, body: {
        "follower_id": followerId,
        "following_id": followingId,
      });

      if (res.statusCode == 200) {
        final wasFollowing = isFollowing;
        setState(() {
          isFollowing = !isFollowing;
          userData!['is_following'] = isFollowing ? '1' : '0';

          final currentFollowers =
              int.tryParse(userData!['no_follower'] ?? '0') ?? 0;
          userData!['no_follower'] =
              (isFollowing ? currentFollowers + 1 : currentFollowers - 1)
                  .clamp(0, 1 << 31)
                  .toString();
        });

        if (!wasFollowing && isFollowing) {
          // Just followed -> load real posts
          await fetchUserPosts();
          glb.successToast(context, "Followed successfully ✅");
        } else if (wasFollowing && !isFollowing) {
          // Just unfollowed -> hide posts
          setState(() => userPosts.clear());
          glb.infoToast(context, "Unfollowed successfully ❌");
        } else {
          glb.infoToast(context, "Updated.");
        }
      } else {
        glb.errorToast(context, "Server error (${res.statusCode})");
      }
    } catch (e) {
      glb.errorToast(context, "Error: $e");
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // -------------------- URL HELPERS --------------------

  /// For profile images
  String _fixProfileUrl(String? path) {
    if (path == null || path.isEmpty) {
      return "https://awesomebook.in/awesomebookbackend/public/images/default.png";
    }
    if (path.startsWith("http")) return path;
    if (path.startsWith("public/")) {
      return "https://awesomebook.in/awesomebookbackend/$path";
    }
    if (path.startsWith("/images/")) {
      return "https://awesomebook.in/awesomebookbackend/public$path";
    }
    return "https://awesomebook.in/awesomebookbackend/public/$path";
  }

  /// For post images (handles both `public/...` and `/images/...`)
  String _fixPostUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path;
    if (path.startsWith("public/")) {
      return "https://awesomebook.in/awesomebookbackend/$path";
    }
    if (path.startsWith("/images/")) {
      return "https://awesomebook.in/awesomebookbackend/public$path";
    }
    // Some backends return 'images/...'
    if (path.startsWith("images/")) {
      return "https://awesomebook.in/awesomebookbackend/public/$path";
    }
    // Fallback
    return "https://awesomebook.in/awesomebookbackend/public/$path";
  }

  // -------------------- UI --------------------

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text("User not found")),
      );
    }

    final verified = userData!["verified"] == "1";

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Txt(text: userData!['user_name'] ?? 'Profile'),
            if (verified) ...[
              const SizedBox(width: 6),
              const Icon(Icons.verified, color: Colors.blue, size: 20),
            ],
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      _fixProfileUrl(userData!['profile_img']),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _countColumn(userData!['no_posts'], 'Posts'),
                        _countColumn(userData!['no_follower'], 'Followers'),
                        _countColumn(userData!['no_following'], 'Following'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  userData!['bio'] ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Follow / Following button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: isProcessing ? null : toggleFollow,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  backgroundColor:
                      isFollowing ? Colors.grey : Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isFollowing ? "Following" : "Follow",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Posts grid (only when following)
            if (isFollowing)
              userPosts.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text("No posts available yet"),
                    )
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: userPosts.length,
                      itemBuilder: (context, index) {
                        final post = userPosts[index];

                        // IMPORTANT: use p_name as primary
                        final raw = (post["p_name"] ??
                                post["post_image"] ??
                                post["image"] ??
                                "")
                            .toString();

                        final imgUrl = _fixPostUrl(raw);

                        // Debug (you can remove later)
                        if (index < 6) {
                          debugPrint("🖼 FIXED -> $imgUrl");
                        }

                        if (imgUrl.isEmpty) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image),
                          );
                        }

                        return AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image),
                            ),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
            else
              const Column(
                children: [
                  SizedBox(height: 50),
                  Icon(Icons.lock, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "This account is private",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Follow to see their posts and activity.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _countColumn(String? count, String label) {
    return Column(
      children: [
        Text(
          count ?? '0',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label),
      ],
    );
  }
}
