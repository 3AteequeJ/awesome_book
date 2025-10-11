import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_book/utils/global.dart' as glb;

class FollowRequestsScreen extends StatefulWidget {
  const FollowRequestsScreen({super.key});

  @override
  State<FollowRequestsScreen> createState() => _FollowRequestsScreenState();
}

class _FollowRequestsScreenState extends State<FollowRequestsScreen> {
  bool isLoading = true;
  List<dynamic> requests = [];
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    fetchFollowRequests();
  }

  // ✅ Fetch follow requests
  Future<void> fetchFollowRequests() async {
    final userId = glb.userDetails.id;
    if (userId.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final res = await http.post(
        Uri.parse("https://awesomebook.in/awesomebookbackend/follow_requests"),
        body: {
          "user_id": userId,
          "type": "received",
        },
      );

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final decoded = jsonDecode(res.body);
        if (decoded is Map && decoded["requests"] is List) {
          setState(() {
            requests = decoded["requests"];
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      glb.errorToast(context, "Error loading requests: $e");
    }
  }

  // ✅ Accept follow request
  Future<void> acceptFollowRequest(String followerId) async {
    final followingId = glb.userDetails.id;
    try {
      final res = await http.post(
        Uri.parse("https://awesomebook.in/awesomebookbackend/acceptFollow"),
        body: {"follower_id": followerId, "following_id": followingId},
      );

      if (res.statusCode == 200) {
        glb.successToast(context, "Request accepted ✅");
        _changed = true; // mark page as changed
        await _updateUserProfileData(); // pull new counts into glb

        setState(() {
          requests
              .removeWhere((r) => r["follower_id"].toString() == followerId);
        });
      }
    } catch (e) {
      glb.errorToast(context, "Error: $e");
    }
  }

  // ✅ Reject follow request
  Future<void> rejectFollowRequest(String followerId) async {
    final followingId = glb.userDetails.id;
    try {
      final res = await http.post(
        Uri.parse("https://awesomebook.in/awesomebookbackend/rejectFollow"),
        body: {"follower_id": followerId, "following_id": followingId},
      );

      if (res.statusCode == 200) {
        glb.infoToast(context, "Request rejected ❌");
        _changed = true; // mark page as changed

        setState(() {
          requests
              .removeWhere((r) => r["follower_id"].toString() == followerId);
        });
      }
    } catch (e) {
      glb.errorToast(context, "Error: $e");
    }
  }

  // ✅ Refresh user’s profile counts after accept
  Future<void> _updateUserProfileData() async {
    final userId = glb.userDetails.id;
    if (userId.isEmpty) return;

    try {
      final res = await http.post(
        Uri.parse("https://awesomebook.in/awesomebookbackend/GetMyDets"),
        body: {"user_id": userId},
      );

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final decoded = jsonDecode(res.body);
        if (decoded is List && decoded.isNotEmpty) {
          final data = decoded[0];
          glb.userDetails.no_follower =
              data["total_followers"]?.toString() ?? "0";
          glb.userDetails.no_following =
              data["total_following"]?.toString() ?? "0";
        }
      }
    } catch (e) {
      debugPrint("⚠️ Failed to update profile counts: $e");
    }
  }

  String _fixImageUrl(String? img) {
    if (img == null || img.isEmpty) {
      return "https://cdn-icons-png.flaticon.com/512/149/149071.png";
    }
    if (img.startsWith("http")) return img;
    if (img.startsWith("public/")) {
      return "https://awesomebook.in/awesomebookbackend/$img";
    }
    return "https://awesomebook.in/awesomebookbackend/public/$img";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context, _changed); // send result when system back pressed
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Follow Requests",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 1,
          leading: BackButton(
            color: Colors.black,
            onPressed: () => Navigator.pop(context, _changed), // send result
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.black))
            : requests.isEmpty
                ? const Center(
                    child: Text(
                      "No follow requests yet 👀",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index];
                      final followerId = req["follower_id"].toString();

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(_fixImageUrl(req["profile_image"])),
                        ),
                        title: Text(
                          req["user_name"] ?? "Unknown",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(req["name"] ?? ""),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () => acceptFollowRequest(followerId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(70, 35),
                              ),
                              child: const Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () => rejectFollowRequest(followerId),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                minimumSize: const Size(70, 35),
                              ),
                              child: const Text(
                                "Reject",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
