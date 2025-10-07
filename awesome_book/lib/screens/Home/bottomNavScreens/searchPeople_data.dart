import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
  bool posts = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      Uri url = Uri.parse("https://awesomebook.in/awesomebookbackend/userData");
      var res = await http.post(url, body: {"user_id": widget.userId});

      print("📡 Fetching user data for ID: ${widget.userId}");
      print("Response: ${res.body}");

      if (res.statusCode == 200) {
        setState(() {
          userData = jsonDecode(res.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error fetching user data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userData == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("User not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Txt(text: userData!['user_name'] ?? 'Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Profile Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      glb.API.baseURL + (userData!['profile_img'] ?? ''),
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

            // ✅ Bio
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

            // ✅ Follow Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add follow/unfollow logic here later
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Follow",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ✅ Tabs (Posts / Tags)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => setState(() => posts = true),
                  child: Column(
                    children: const [
                      Icon(Icons.grid_on),
                      Text('Posts'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => posts = false),
                  child: Column(
                    children: const [
                      Icon(CupertinoIcons.tag),
                      Text('Tags'),
                    ],
                  ),
                ),
              ],
            ),

            // ✅ Posts Grid (dummy for now)
            posts
                ? GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Image.asset(
                          'assets/images/post1.jpg',
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Image.asset(
                          'assets/images/post2.png',
                          fit: BoxFit.cover,
                        ),
                      );
                    },
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
