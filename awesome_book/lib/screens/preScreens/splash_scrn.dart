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
    // TODO: implement initState
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Txt(
          text: "This is a splash screen",
        ),
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
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      glb.newUser? user = await getUser();
      // final String userID = prefs.getString('sp_userID').toString();
      // String? userNm = prefs.getString('sp_userNm').toString();
      // String? name = prefs.getString('sp_Name').toString();
      // String? pswd = prefs.getString('sp_pswd').toString();
      // String? email = prefs.getString('sp_email').toString();
      // String? verified = prefs.getString('sp_verified').toString();
      // String? open = prefs.getString('sp_open').toString();
      // String? status = prefs.getString('sp_status').toString();
      // String? profile_img = prefs.getString('sp_img').toString();
      // String? dateTime = prefs.getString('sp_datetime').toString();
      // String? bio = prefs.getString('sp_bio').toString();
      // String? no_posts = prefs.getString('sp_no_posts').toString();
      // String? no_follower = prefs.getString('sp_no_follower').toString();
      // String? no_following = prefs.getString('sp_no_following').toString();

      // print("\n\n\n\nUser id = $userID\n\n\n");
      // if (userID == 'null' ||
      //     userNm == 'null' ||
      //     name == 'null' ||
      //     pswd == 'null' ||
      //     email == 'null' ||
      //     verified == 'null' ||
      //     open == 'null' ||
      //     status == 'null' ||
      //     dateTime == 'null' ||
      //     no_posts == 'null' ||
      //     no_follower == 'null' ||
      //     no_following == 'null' ||
      //     userID.isEmpty ||
      //     userNm.isEmpty ||
      //     name.isEmpty ||
      //     pswd.isEmpty ||
      //     email.isEmpty ||
      //     verified.isEmpty ||
      //     open.isEmpty ||
      //     status.isEmpty ||
      //     dateTime.isEmpty ||
      //     no_posts.isEmpty ||
      //     no_follower.isEmpty ||
      //     no_following.isEmpty) {
      //   Navigator.pushNamed(context, RouteGenerator.rt_login);
      // } else {
      //   Navigator.pushNamed(context, RouteGenerator.rt_home);
      //   setState(() {
      //     glb.userDetails.id = userID;
      //     glb.userDetails.name = name;
      //     glb.userDetails.email_id = email;
      //     glb.userDetails.verified = verified;
      //     glb.userDetails.open = open;
      //   });
      //   print("user name  = ${userNm}");
      // }

      if (user!.id.isEmpty) {
        Navigator.pushNamed(context, RouteGenerator.rt_login);
      } else {
        Navigator.pushNamed(context, RouteGenerator.rt_home);
        setState(() {
          glb.userDetails.id = user.id;
          glb.userDetails.name = user.name!;
          glb.userDetails.email_id = user.email_id!;
          glb.userDetails.verified = user.verified!;
          glb.userDetails.open = user.open!;
          glb.userDetails.status = user.status!;
          glb.userDetails.profile_img = user.profile_img!;
          glb.userDetails.dateTime = user.dateTime!;
          glb.userDetails.no_posts = user.no_posts!;
          glb.userDetails.no_follower = user.no_follower!;
          glb.userDetails.no_following = user.no_following!;
          glb.userDetails.bio = user.bio!;
        });
        // print("user name  = ${userNm}");
      }
    } catch (e) {
      Navigator.pushNamed(context, RouteGenerator.rt_login);
    }
  }
}
