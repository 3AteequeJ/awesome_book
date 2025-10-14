// import 'package:awesome_book/Route/router.dart';
// import 'package:awesome_book/widgets/mytext.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:awesome_book/utils/global.dart' as glb;

// class Profile_scrn extends StatefulWidget {
//   @override
//   State<Profile_scrn> createState() => _Profile_scrnState();
// }

// class _Profile_scrnState extends State<Profile_scrn> {
//   bool posts = true;

//   @override
//   Widget build(BuildContext context) {
//     print(
//         "👤 Profile -> user_name='${glb.userDetails.user_name}', name='${glb.userDetails.name}'");
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Txt(
//           text: glb.userDetails.user_name.isNotEmpty
//               ? glb.userDetails.user_name
//               : glb.userDetails.name.isNotEmpty
//                   ? glb.userDetails.name
//                   : "My Profile",
//         ),
//         actions: [
//           // IconButton(
//           //   icon: Icon(Icons.menu),
//           //   onPressed: () {
//           //     // Add menu functionality here
//           //   },
//           // ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundImage: AssetImage('assets/images/post1.jpg'),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Column(
//                               children: [
//                                 Text(glb.userDetails.no_posts,
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold)),
//                                 Text('Posts'),
//                               ],
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.pushNamed(
//                                     context, RouteGenerator.rt_followers);
//                               },
//                               child: Column(
//                                 children: [
//                                   Text(glb.userDetails.no_follower,
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                   Text('Followers'),
//                                 ],
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.pushNamed(
//                                     context, RouteGenerator.rt_following);
//                               },
//                               child: Column(
//                                 children: [
//                                   Text(glb.userDetails.no_following,
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                   Text('Following'),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(glb.userDetails.bio),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushNamed(
//                             context, RouteGenerator.rt_editprofile);
//                       },
//                       child: Text('Edit profile'),
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushNamed(
//                             context, RouteGenerator.rt_uploadPost);
//                       },
//                       child: Text('New post'),
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             posts = true;
//                           });
//                         },
//                         child: Icon(
//                           Icons.grid_on,
//                         ),
//                       ),
//                       Text('Posts'),
//                     ],
//                   ),
//                   // Column(
//                   //   children: [
//                   //     Icon(
//                   //       Icons.video_library,
//                   //     ),
//                   //     Text('Reels'),
//                   //   ],
//                   // ),
//                   // InkWell(
//                   //   onTap: () {
//                   //     setState(() {
//                   //       posts = false;
//                   //     });
//                   //   },
//                   //   child: Column(
//                   //     children: [
//                   //       Icon(
//                   //         CupertinoIcons.tag,
//                   //       ),
//                   //       Text('Tags'),
//                   //     ],
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//             posts
//                 ? AnimatedContainer(
//                     duration: Duration(seconds: 5),
//                     transform: Matrix4.translationValues(
//                         posts ? 0 : -MediaQuery.of(context).size.width, 0, 0),
//                     child: GridView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3),
//                       itemCount: 16,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: Image.asset('assets/images/post2.png',
//                                 fit: BoxFit.cover),
//                           ),
//                         );
//                       },
//                     ),
//                   )
//                 : GridView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3),
//                     itemCount: 16,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: Image.asset('assets/images/post1.jpg',
//                               fit: BoxFit.cover),
//                         ),
//                       );
//                     },
//                   ),
//           ],
//         ),
//       ),
//       endDrawer: Drawer(
//         child: ListView(
//           children: <Widget>[
//             DrawerHeader(
//               child: Text('Drawer Header'),
//               decoration: BoxDecoration(
//                 color: Colors.blue.withOpacity(.2),
//               ),
//             ),
//             ListTile(
//               title: Text('Account & privacy'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: Text('Terms & conditions'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: Text('Logout'),
//               trailing: Icon(Icons.logout_rounded),
//               onTap: () async {
//                 final shouldLogout = await showDialog<bool>(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: Text('Confirm Logout'),
//                     content: Text('Are you sure you want to log out?'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, false),
//                         child: Text('Cancel'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () => Navigator.pop(context, true),
//                         child: Text('Logout'),
//                       ),
//                     ],
//                   ),
//                 );

//                 if (shouldLogout == true) {
//                   // ✅ Reset user details
//                   glb.userDetails.id = "";
//                   glb.userDetails.name = "";
//                   glb.userDetails.user_name = "";
//                   glb.userDetails.email_id = "";
//                   glb.userDetails.profile_img = "";
//                   glb.userDetails.no_posts = "";
//                   glb.userDetails.no_follower = "";
//                   glb.userDetails.no_following = "";
//                   glb.userDetails.bio = "";

//                   // ✅ Navigate to login screen
//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     RouteGenerator.rt_login,
//                     (Route<dynamic> route) => false,
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:awesome_book/Route/router.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/follow_req.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/profile%20screens/post_preview_page.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:flutter/scheduler.dart';

class Profile_scrn extends StatefulWidget {
  @override
  State<Profile_scrn> createState() => _Profile_scrnState();
}

class _Profile_scrnState extends State<Profile_scrn> with RouteAware {
  bool isLoading = true;
  bool isVerifying = false;
  List<dynamic> userPosts = [];

  @override
  void initState() {
    super.initState();
    _loadProfileOnce();
    fetchProfileAndPosts();

    @override
    void didPopNext() {
      print("🔁 Returned to profile screen");
      if (glb.shouldRefreshProfile) {
        print("🔄 Refreshing profile data...");
        fetchProfileAndPosts();
        glb.shouldRefreshProfile = false;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      glb.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    glb.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    if (glb.shouldRefreshProfile) {
      fetchProfileAndPosts();
      glb.shouldRefreshProfile = false;
    }
  }

  // ✅ Fetch profile info & posts
  @override

  /// ✅ Prevent double API calls and refresh properly when needed
  Future<void> _loadProfileOnce() async {
    print("🚀 Initializing profile screen...");
    if (isLoading) return; // prevent duplicate triggers
    setState(() => isLoading = true);
    await fetchProfileAndPosts();
    setState(() => isLoading = false);
  }

  /// ✅ Unified function — only one API run per refresh
  @override
  Future<void> fetchProfileAndPosts() async {
    final userId = glb.userDetails.id;
    if (userId.isEmpty) {
      print("⚠️ No user_id found");
      return;
    }

    print("🚀 Starting fetchProfileAndPosts() for user_id=$userId");
    setState(() => isLoading = true);

    try {
      // ✅ Fetch profile
      final profileRes = await http.post(
        Uri.parse("https://awesomebook.in/awesomebookbackend/GetMyDets"),
        body: {"user_id": userId},
      );

      print("📨 Raw GetMyDets response: ${profileRes.body}");

      if (profileRes.statusCode == 200 && profileRes.body.isNotEmpty) {
        final decoded = jsonDecode(profileRes.body);
        final data = decoded is List ? decoded.first : decoded;

        // ✅ Update user details
        glb.userDetails.name = data["name"] ?? "";
        glb.userDetails.user_name = data["user_name"] ?? "";
        glb.userDetails.bio = data["bio"] ?? "";
        glb.userDetails.no_posts = data["total_posts"]?.toString() ?? "0";
        glb.userDetails.no_follower =
            data["total_followers"]?.toString() ?? "0";
        glb.userDetails.no_following =
            data["total_following"]?.toString() ?? "0";
        glb.userDetails.verified = data["verified"]?.toString() ?? "0";
        glb.userDetails.profile_img = data["profile_image"]?.toString() ?? "";

        print(
            "✅ Updated counts → Followers: ${glb.userDetails.no_follower}, Following: ${glb.userDetails.no_following}");
      }

      // ✅ Fetch posts
      final postsRes = await http.post(
        Uri.parse("https://awesomebook.in/awesomebookbackend/GetMyPosts"),
        body: {"user_id": userId},
      );

      if (postsRes.statusCode == 200 && postsRes.body.isNotEmpty) {
        final postsData = jsonDecode(postsRes.body);
        setState(() {
          if (postsData is List) {
            userPosts = postsData;
          } else if (postsData is Map && postsData["posts"] is List) {
            userPosts = postsData["posts"];
          }
        });
      }
    } catch (e) {
      print("❌ Error fetching profile/posts: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _fixImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) return "";
    if (raw.startsWith("http")) return raw;
    if (raw.startsWith("/images/")) {
      return "https://awesomebook.in/awesomebookbackend/public$raw";
    } else if (raw.startsWith("public/")) {
      return "https://awesomebook.in/awesomebookbackend/$raw";
    } else {
      return "https://awesomebook.in/awesomebookbackend/public/$raw";
    }
  }

  Future<void> _handleVerificationRequest() async {
    final userId = glb.userDetails.id;
    if (userId.isEmpty) {
      glb.errorToast(context, "User not found. Please login again.");
      return;
    }

    // 🧩 Show modal bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return VerificationBadgeModal(
            userId: userId,
            onVerified: () {
              // Refresh profile data once verified
              setState(() => glb.userDetails.verified = "1");
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Txt(
              text: glb.userDetails.user_name.isNotEmpty
                  ? glb.userDetails.user_name
                  : glb.userDetails.name.isNotEmpty
                      ? glb.userDetails.name
                      : "My Profile",
              fntWt: FontWeight.w600,
              fntSz: 18,
            ),
            if (glb.userDetails.verified == "1") ...[
              const SizedBox(width: 5),
              const Icon(Icons.verified, color: Colors.blue, size: 18),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined,
                color: Colors.black),
            onPressed: () async {
              // 👇 open follow requests and refresh if changed
              final changed = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FollowRequestsScreen()),
              );
              if (changed == true && mounted) {
                await fetchProfileAndPosts();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage:
                              glb.userDetails.profile_img.isNotEmpty
                                  ? NetworkImage(
                                      _fixImageUrl(glb.userDetails.profile_img))
                                  : const AssetImage('assets/images/post1.jpg')
                                      as ImageProvider,
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _statItem(glb.userDetails.no_posts, "Posts"),
                              InkWell(
                                onTap: () async {
                                  final changed = await Navigator.pushNamed(
                                      context, RouteGenerator.rt_followers);
                                  if (changed == true && mounted) {
                                    await fetchProfileAndPosts();
                                  }
                                },
                                child: _statItem(
                                    glb.userDetails.no_follower, "Followers"),
                              ),
                              InkWell(
                                onTap: () async {
                                  final changed = await Navigator.pushNamed(
                                      context, RouteGenerator.rt_following);
                                  if (changed == true && mounted) {
                                    await fetchProfileAndPosts();
                                  }
                                },
                                child: _statItem(
                                    glb.userDetails.no_following, "Following"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(glb.userDetails.bio,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 14)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(
                          "Edit profile", RouteGenerator.rt_editprofile),
                      _actionButton("New post", RouteGenerator.rt_uploadPost),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: _handleVerificationRequest, // 👈 Opens modal
                      icon: const Icon(Icons.verified, color: Colors.white),
                      label: const Text(
                        "Verification Badge",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(double.infinity, 40),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (glb.userDetails.verified != "1")
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton.icon(
                        onPressed:
                            isVerifying ? null : _handleVerificationRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        icon: const Icon(Icons.verified, color: Colors.white),
                        label: Text(
                          isVerifying
                              ? "Sending request..."
                              : "Request Verification Badge",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Posts",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildPostsGrid(),
                ],
              ),
            ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: Colors.black54, fontSize: 13)),
      ],
    );
  }

  Widget _actionButton(String text, String route) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, route),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 251, 221, 221),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(text, style: const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  Widget _buildPostsGrid() {
    if (userPosts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text("No posts yet",
            style: TextStyle(color: Colors.black54, fontSize: 14)),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: userPosts.length,
      itemBuilder: (context, index) {
        final post = userPosts[index];
        final rawImg = post["p_name"] ??
            post["image"] ??
            post["post_image"] ??
            post["img"] ??
            "";
        final imageUrl = _fixImageUrl(rawImg.toString());

        return GestureDetector(
          onTap: () async {
            final deleted = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostPreviewPage(post: post),
              ),
            );
            if (deleted == true) {
              setState(() {
                userPosts.removeAt(index);
                glb.userDetails.no_posts =
                    (int.parse(glb.userDetails.no_posts) - 1).toString();
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}

class VerificationBadgeModal extends StatefulWidget {
  final String userId;
  final VoidCallback onVerified;
  const VerificationBadgeModal({
    super.key,
    required this.userId,
    required this.onVerified,
  });

  @override
  State<VerificationBadgeModal> createState() => _VerificationBadgeModalState();
}

class _VerificationBadgeModalState extends State<VerificationBadgeModal> {
  String _status = "Checking...";
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    try {
      final res = await http.post(
        Uri.parse(
            "https://awesomebook.in/awesomebookbackend/veriRequest_status"),
        body: {"user_id": widget.userId},
      );
      final body = res.body.toLowerCase().trim();

      if (body.contains("approved") ||
          body.contains("verified") ||
          body.contains("1")) {
        setState(() => _status = "✅ Verified");
        widget.onVerified();
      } else if (body.contains("pending")) {
        setState(() => _status = "🕓 Pending");
      } else {
        setState(() => _status = "Not Requested");
      }
    } catch (e) {
      setState(() => _status = "Error fetching status");
    }
  }

  Future<void> _sendRequest() async {
    setState(() => _isSending = true);
    try {
      final res = await http.post(
        Uri.parse("https://awesomebook.in/awesomebookbackend/send_veriRequest"),
        body: {"user_id": widget.userId},
      );

      if (res.statusCode == 200 &&
          (res.body.contains("1") ||
              res.body.toLowerCase().contains("success"))) {
        glb.successToast(context, "Verification request sent successfully ✅");
        setState(() => _status = "🕓 Pending");
      } else {
        glb.errorToast(context, "Failed to send verification request.");
      }
    } catch (e) {
      glb.errorToast(context, "Error: $e");
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, color: Colors.blue, size: 50),
          const SizedBox(height: 12),
          const Text(
            "Verification Badge Status",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            _status,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          if (_status == "Not Requested")
            ElevatedButton.icon(
              onPressed: _isSending ? null : _sendRequest,
              icon: const Icon(Icons.send, color: Colors.white),
              label: Text(
                _isSending ? "Sending..." : "Send Verification Request",
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          if (_status == "🕓 Pending")
            const Text("Your request is under review 🕓",
                style: TextStyle(color: Colors.orange, fontSize: 14)),
          if (_status == "✅ Verified")
            const Text("You are verified ✅",
                style: TextStyle(color: Colors.green, fontSize: 14)),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:awesome_book/Route/router.dart';
// import 'package:awesome_book/screens/Home/bottomNavScreens/profile%20screens/post_preview_page.dart';
// import 'package:awesome_book/widgets/mytext.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:awesome_book/utils/global.dart' as glb;

// class Profile_scrn extends StatefulWidget {
//   @override
//   State<Profile_scrn> createState() => _Profile_scrnState();
// }

// class _Profile_scrnState extends State<Profile_scrn> {
//   bool posts = true;
//   bool isLoading = true;
//   List<dynamic> userPosts = [];

//   // ✅ Helper: Fix broken image paths
//   String fixImageUrl(String? url) {
//     if (url == null || url.isEmpty) return "";
//     if (url.startsWith("http")) return url;

//     // 🔹 Correct base path for your backend — this works with your structure
//     return "https://awesomebook.in/awesomebookbackend/$url";
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchProfileAndPosts();
//   }

//   Future<void> fetchProfileAndPosts() async {
//     final userId = glb.userDetails.id;
//     if (userId.isEmpty) {
//       print("⚠️ No user_id found");
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       // ✅ Step 1: Fetch profile info
//       final profileRes = await http.post(
//         Uri.parse(
//             "https://awesomebook.in/awesomebookbackend/UpdateUserDetails"),
//         body: {"user_id": userId},
//       );

//       print("📡 Profile API => ${profileRes.statusCode}");
//       print("📡 Profile Body => ${profileRes.body}");

//       if (profileRes.statusCode == 200 && profileRes.body.isNotEmpty) {
//         final data = jsonDecode(profileRes.body);
//         if (data is Map) {
//           glb.userDetails.name = data["name"] ?? glb.userDetails.name;
//           glb.userDetails.user_name =
//               data["user_name"] ?? glb.userDetails.user_name;
//           glb.userDetails.bio = data["bio"] ?? glb.userDetails.bio;
//           glb.userDetails.profile_img =
//               data["profile_image"] ?? glb.userDetails.profile_img;
//           glb.userDetails.no_posts = data["total_posts"]?.toString() ?? "0";
//           glb.userDetails.no_follower =
//               data["total_followers"]?.toString() ?? "0";
//           glb.userDetails.no_following =
//               data["total_following"]?.toString() ?? "0";
//         }
//       }

//       // ✅ Step 2: Fetch user's posts
//       final postsRes = await http.post(
//         Uri.parse("https://awesomebook.in/awesomebookbackend/GetMyPosts"),
//         body: {"user_id": userId},
//       );

//       print("🧩 Posts API => ${postsRes.statusCode}");
//       print("🧩 Posts Body => ${postsRes.body}");

//       if (postsRes.statusCode == 200 && postsRes.body.isNotEmpty) {
//         final postsData = jsonDecode(postsRes.body);
//         if (postsData is List) {
//           setState(() {
//             userPosts = postsData;
//           });
//         } else if (postsData is Map && postsData["posts"] is List) {
//           setState(() {
//             userPosts = postsData["posts"];
//           });
//         } else {
//           print("⚠️ Unexpected posts format: ${postsData.runtimeType}");
//         }
//       }
//     } catch (e) {
//       print("❌ Error fetching profile/posts: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Txt(
//           text: glb.userDetails.user_name.isNotEmpty
//               ? glb.userDetails.user_name
//               : glb.userDetails.name.isNotEmpty
//                   ? glb.userDetails.name
//                   : "My Profile",
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundImage:
//                               glb.userDetails.profile_img.isNotEmpty
//                                   ? NetworkImage(
//                                       fixImageUrl(glb.userDetails.profile_img))
//                                   : const AssetImage('assets/images/post1.jpg')
//                                       as ImageProvider,
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               _statItem(glb.userDetails.no_posts, "Posts"),
//                               _statItem(
//                                   glb.userDetails.no_follower, "Followers"),
//                               _statItem(
//                                   glb.userDetails.no_following, "Following"),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Text(glb.userDetails.bio),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _actionButton(
//                           "Edit profile", RouteGenerator.rt_editprofile),
//                       _actionButton("New post", RouteGenerator.rt_uploadPost),
//                     ],
//                   ),
//                   Text("Posts",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       )),
//                   const SizedBox(height: 10),
//                   _buildPostsGrid(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _statItem(String value, String label) {
//     return Column(
//       children: [
//         Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
//         Text(label),
//       ],
//     );
//   }

//   Widget _actionButton(String text, String route) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: ElevatedButton(
//           onPressed: () => Navigator.pushNamed(context, route),
//           style: ElevatedButton.styleFrom(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           child: Text(text),
//         ),
//       ),
//     );
//   }

//   // ✅ FIXED GRID SECTION
//   Widget _buildPostsGrid() {
//     if (userPosts.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.all(20),
//         child: Text("No posts yet"),
//       );
//     }

//     return GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       gridDelegate:
//           const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//       itemCount: userPosts.length,
//       itemBuilder: (context, index) {
//         final post = userPosts[index];

//         // ✅ Use correct key
//         final rawImage = post["p_name"] ?? "";

//         String imageUrl = rawImage;

// // ✅ FIX: normalize inconsistent backend paths
//         if (imageUrl.isNotEmpty && !imageUrl.startsWith("http")) {
//           // Case 1: path starts with "/images/"
//           if (imageUrl.startsWith("/images/")) {
//             imageUrl =
//                 "https://awesomebook.in/awesomebookbackend/public${imageUrl}";
//           }
//           // Case 2: path starts with "public/"
//           else if (imageUrl.startsWith("public/")) {
//             imageUrl = "https://awesomebook.in/awesomebookbackend/$imageUrl";
//           }
//           // Case 3: fallback
//           else {
//             imageUrl =
//                 "https://awesomebook.in/awesomebookbackend/public/$imageUrl";
//           }
//         }

//         print("🖼 FINAL => $imageUrl");

//         print("🖼 Post Image URL => $imageUrl");
//         print("🖼 RAW  -> ${post["p_name"]}");
//         print("🖼 FINAL -> $imageUrl");

//         return GestureDetector(
//           onTap: () async {
//             final deleted = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PostPreviewPage(post: post),
//               ),
//             );

//             if (deleted == true) {
//               setState(() {
//                 userPosts.removeAt(index);
//                 glb.userDetails.no_posts =
//                     (int.parse(glb.userDetails.no_posts) - 1).toString();
//               });
//             }
//           },
//           child: Container(
//             decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
//             child: Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
