// import 'package:awesome_book/Cards/people_card.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class Followers_scrn extends StatefulWidget {
//   final String type;
//   const Followers_scrn({super.key, required this.type});

//   @override
//   State<Followers_scrn> createState() => _Followers_scrnState();
// }

// class _Followers_scrnState extends State<Followers_scrn> {
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
//         title: Text("Followers"),
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
//                         userName: null,
//                         profileImg: null,
//                         name: null,
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

class Followers_scrn extends StatefulWidget {
  final String type;
  const Followers_scrn({super.key, required this.type});

  @override
  State<Followers_scrn> createState() => _Followers_scrnState();
}

class _Followers_scrnState extends State<Followers_scrn> {
  List<dynamic> followersList = [];
  List<dynamic> _allFollowers = [];
  bool _loading = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    fetchFollowers();
  }

  Future<void> fetchFollowers() async {
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
        Uri.parse("https://awesomebook.in/awesomebookbackend/GetFollowers");

    print("📡 Fetching followers list for user_id: $userId");

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
          setState(() {
            followersList = body;
            _allFollowers = body;
          });
        } else {
          followersList = [];
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
        body: {"follower_id": followerId, "following_id": targetId},
      );

      print("📩 Follow/Unfollow response: ${res.body}");

      if (res.statusCode == 200) {
        final clean = res.body.replaceAll(RegExp(r'<[^>]*>'), '').toLowerCase();

        if (clean.contains("unfollow")) {
          glb.infoToast(context, "Unfollowed successfully ❌");
        } else if (clean.contains("follow")) {
          glb.successToast(context, "Followed successfully ✅");
        }

        setState(() {
          final index =
              followersList.indexWhere((u) => u["id"].toString() == targetId);
          if (index != -1) {
            followersList[index]["is_following"] =
                currentlyFollowing ? "0" : "1";
          }
        });
      } else {
        glb.errorToast(context, "Failed (${res.statusCode})");
      }
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
        title: const Text("Followers"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search ${widget.type}...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.w),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  if (query.isEmpty) {
                    followersList = List.from(_allFollowers);
                  } else {
                    followersList = _allFollowers
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
                          child: Text("Failed to load followers list.",
                              style: TextStyle(color: Colors.red)),
                        )
                      : followersList.isEmpty
                          ? const Center(
                              child: Text(
                                "You don’t have any followers yet.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: followersList.length,
                              itemBuilder: (context, index) {
                                final user = followersList[index];
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
