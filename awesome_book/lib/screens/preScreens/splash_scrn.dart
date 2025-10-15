import 'package:awesome_book/Route/router.dart';
import 'package:awesome_book/utils/sharedPrefs.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_book/utils/global.dart' as glb;

class Splash_scrn extends StatefulWidget {
  const Splash_scrn({super.key});

  @override
  State<Splash_scrn> createState() => _Splash_scrnState();
}

class _Splash_scrnState extends State<Splash_scrn> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), getSharedPrefs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/icon.jpeg',
          // height: 32,
        ),
        // child: Txt(
        //   text: "This is a splash screen",
        // ),
      ),
    );
  }

// getMeMyUser() async {
//     glb.newUser? user = await getUser();
//     if (user != null) {
//       print("Name: ${user.name}, Age: ${user.age}");
//     } else {
//       print("No user data found");
//     }
//   }

  getSharedPrefs() async {
    try {
      glb.newUser? user = await getUser();

      // If user data not found → treat as guest
      if (user == null || user.id.isEmpty) {
        // set guest ID = "-1"
        glb.userDetails.id = "-1";
        glb.userDetails.name = "Guest";
        glb.userDetails.user_name = "GuestUser";
        glb.userDetails.email_id = "";
        glb.userDetails.profile_img = "";
        glb.userDetails.verified = "0";
        glb.userDetails.status = "GUEST";
        glb.userDetails.bio = "";

        // Navigate to home (guest mode)
        Navigator.pushReplacementNamed(context, RouteGenerator.rt_home);
        return;
      }

      // If user exists → save and go to home
      setState(() {
        glb.userDetails.id = user.id;
        glb.userDetails.name = user.name;
        glb.userDetails.user_name = user.user_name;
        glb.userDetails.email_id = user.email_id;
        glb.userDetails.verified = user.verified;
        glb.userDetails.open = user.open;
        glb.userDetails.status = user.status;
        glb.userDetails.profile_img = user.profile_img;
        glb.userDetails.dateTime = user.dateTime;
        glb.userDetails.no_posts = user.no_posts;
        glb.userDetails.no_follower = user.no_follower;
        glb.userDetails.no_following = user.no_following;
        glb.userDetails.bio = user.bio;
      });

      Navigator.pushReplacementNamed(context, RouteGenerator.rt_home);
    } catch (e) {
      // Any error = treat as guest and go home
      glb.userDetails.id = "-1";
      glb.userDetails.name = "Guest";
      glb.userDetails.user_name = "GuestUser";
      Navigator.pushReplacementNamed(context, RouteGenerator.rt_home);
    }
  }
}
