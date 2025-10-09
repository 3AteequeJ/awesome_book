// import 'package:awesome_book/Cards/people_card.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class Following_scrn extends StatefulWidget {
//   final String type;
//   const Following_scrn({super.key, required this.type});

//   @override
//   State<Following_scrn> createState() => _Following_scrnState();
// }

// class _Following_scrnState extends State<Following_scrn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(CupertinoIcons.back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text("Following"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(12.sp),
//         child: Column(
//           children: [
//             TextField(
//               // enabled: false,
//               decoration: InputDecoration(
//                 hintText: "Search",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5.w),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 2.h,
//             ),
//             Expanded(
//                 child: ListView.builder(
//                     itemCount: 10,
//                     itemBuilder: (context, index) {
//                       return People_card(
//                         type: widget.type,
//                       );
//                     }))
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';

class Following_scrn extends StatefulWidget {
  const Following_scrn({super.key});

  @override
  State<Following_scrn> createState() => _Following_scrnState();
}

class _Following_scrnState extends State<Following_scrn> {
  List<dynamic> followingList = [];
  List<dynamic> _allFollowing = [];
  bool _loading = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    fetchFollowing();
  }

  Future<void> fetchFollowing() async {
    setState(() {
      _loading = true;
      _error = false;
    });

    final userId = glb.userDetails.id;
    if (userId.isEmpty) {
      glb.errorToast(context, "User not found. Please re-login.");
      setState(() => _loading = false);
      return;
    }

    final url =
        Uri.parse("https://awesomebook.in/awesomebookbackend/GetFollowing");

    print("📡 Fetching following list for user_id: $userId");

    try {
      final res = await http.post(url, body: {"user_id": userId});
      print("🔹 API Response: ${res.statusCode}");
      print("🔹 Body: ${res.body}");

      if (res.statusCode == 200) {
        dynamic body;
        try {
          body = jsonDecode(res.body);
        } catch (_) {
          body = [];
        }

        if (body is List) {
          followingList = body;
          _allFollowing = body;
        } else {
          followingList = [];
        }
      } else {
        _error = true;
        glb.errorToast(context, "Server error (${res.statusCode})");
      }
    } catch (e) {
      _error = true;
      glb.errorToast(context, "Network error: $e");
    } finally {
      _loading = false;
      setState(() {});
    }
  }

  String _fullImageUrl(dynamic img) {
    if (img == null || img.toString().isEmpty) return "";
    final str = img.toString();
    if (str.startsWith("http")) return str;
    return "https://awesomebook.in/awesomebookbackend/$str";
  }

  Future<void> _toggleFollow(String targetId, bool currentlyFollowing) async {
    final followerId = glb.userDetails.id;

    try {
      final res = await http.post(
        Uri.parse("https://awesomebook.in/awesomebookbackend/unfollow"),
        body: {
          "follower_id": followerId,
          "following_id": targetId,
        },
      );

      print(
          "📩 Raw response: ${res.body.substring(0, 100)}..."); // show only start

      // Check if response is HTML
      if (res.body.contains("<!DOCTYPE html>")) {
        glb.infoToast(context,
            "Server returned invalid response (HTML). Please check backend route.");
        return;
      }

      // Handle valid response
      final clean = res.body.replaceAll(RegExp(r'<[^>]*>'), '').toLowerCase();
      final isUnfollow =
          clean.contains("unfollow") || clean.contains("removed");
      final isFollow = clean.contains("follow") || clean.contains("success");

      if (isUnfollow) {
        glb.infoToast(context, "Unfollowed successfully ❌");
      } else if (isFollow) {
        glb.successToast(context, "Followed successfully ✅");
      } else {
        glb.infoToast(context, "Action completed ✅");
      }

      setState(() {
        final index =
            followingList.indexWhere((u) => (u["id"].toString() == targetId));
        if (index != -1) {
          followingList[index]["is_following"] = currentlyFollowing ? "0" : "1";
        }
      });
    } catch (e) {
      glb.errorToast(context, "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text("Following"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search following...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.w),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  if (query.isEmpty) {
                    followingList = List.from(_allFollowing);
                  } else {
                    followingList = _allFollowing
                        .where((p) => (p["user_name"] ?? "")
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  }
                });
              },
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error
                      ? const Center(
                          child: Text("Failed to load following list.",
                              style: TextStyle(color: Colors.red)),
                        )
                      : followingList.isEmpty
                          ? const Center(
                              child: Text(
                                "You’re not following anyone yet.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: followingList.length,
                              itemBuilder: (context, index) {
                                final user = followingList[index];
                                final username =
                                    user["user_name"]?.toString() ?? "";
                                final imgUrl = _fullImageUrl(
                                    user["profile_image"] ??
                                        user["profile_img"]);
                                final targetId = user["id"].toString();
                                final isFollowing =
                                    user["is_following"].toString() == "1";

                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: imgUrl.isNotEmpty
                                        ? NetworkImage(imgUrl)
                                        : const AssetImage(
                                                'assets/images/post1.jpg')
                                            as ImageProvider,
                                  ),
                                  title: Text(username,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  trailing: ElevatedButton(
                                    onPressed: () =>
                                        _toggleFollow(targetId, isFollowing),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isFollowing
                                          ? Colors.grey.shade300
                                          : Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.sp),
                                      ),
                                    ),
                                    child: Text(
                                      isFollowing ? "Following" : "Follow",
                                      style: TextStyle(
                                        color: isFollowing
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
