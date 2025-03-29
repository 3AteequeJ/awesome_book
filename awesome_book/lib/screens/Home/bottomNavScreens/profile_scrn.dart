import 'package:awesome_book/Route/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_book/utils/global.dart' as glb;

class Profile_scrn extends StatefulWidget {
  @override
  State<Profile_scrn> createState() => _Profile_scrnState();
}

class _Profile_scrnState extends State<Profile_scrn> {
  bool posts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(glb.userDetails.user_name),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.menu),
          //   onPressed: () {
          //     // Add menu functionality here
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/post1.jpg'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(glb.userDetails.no_posts,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text('Posts'),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteGenerator.rt_followers);
                              },
                              child: Column(
                                children: [
                                  Text(glb.userDetails.no_follower,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Followers'),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteGenerator.rt_following);
                              },
                              child: Column(
                                children: [
                                  Text(glb.userDetails.no_following,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Following'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(glb.userDetails.bio),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RouteGenerator.rt_editprofile);
                      },
                      child: Text('Edit profile'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RouteGenerator.rt_uploadPost);
                      },
                      child: Text('New post'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            posts = true;
                          });
                        },
                        child: Icon(
                          Icons.grid_on,
                        ),
                      ),
                      Text('Posts'),
                    ],
                  ),
                  // Column(
                  //   children: [
                  //     Icon(
                  //       Icons.video_library,
                  //     ),
                  //     Text('Reels'),
                  //   ],
                  // ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        posts = false;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.tag,
                        ),
                        Text('Tags'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            posts
                ? AnimatedContainer(
                    duration: Duration(seconds: 5),
                    transform: Matrix4.translationValues(
                        posts ? 0 : -MediaQuery.of(context).size.width, 0, 0),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemCount: 16,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset('assets/images/post2.png',
                                fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  )
                : GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Image.asset('assets/images/post1.jpg',
                              fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.2),
              ),
            ),
            ListTile(
              title: Text('Account & privacy'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Terms & conditions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.logout_rounded),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
