import 'package:awesome_book/screens/Home/BottomNav_scrn.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/messageList_scrn.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/profile%20screens/editProfile_scrn.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/profile%20screens/following_scrn.dart';
import 'package:awesome_book/screens/Home/uploadPost_scrn.dart';
import 'package:awesome_book/screens/preScreens/login_scrn.dart';
import 'package:awesome_book/screens/preScreens/signUp_scrn.dart';
import 'package:awesome_book/screens/preScreens/splash_scrn.dart';
import 'package:awesome_book/utils/post_fullscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/Home/bottomNavScreens/profile screens/followers_scrn.dart';

class RouteGenerator {
  static const String rt_splash = 'rt_splash';
  static const String rt_login = "rt_login";
  static const String rt_signup = "rt_signup";
  static const String rt_home = "rt_home";
  static const String rt_followers = "rt_followers";
  static const String rt_following = "rt_following";
  static const String rt_editprofile = "rt_editprofile";
  static const String rt_msgLst = "rt_msgLst";
  static const String rt_uploadPost = "rt_uploadPost";
  static const String rt_postFullScrn = "rt_postFullScrn";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case rt_splash:
        return myRoute(Splash_scrn());
      case rt_login:
        return myRoute(Login_scrn());
      case rt_signup:
        return myRoute(Signup_scrn());
      case rt_home:
        return myRoute(BottomNav_scrn());
      case rt_followers:
        return myRoute(Followers_scrn(
          type: '1',
        ));
      case rt_following:
        return myRoute(Following_scrn(
          type: '2',
        ));
      case rt_editprofile:
        return myRoute(EditProfile_scrn());
      case rt_msgLst:
        return myRoute(Messagelist_Scrn(
          type: '0',
        ));
      case rt_uploadPost:
        return myRoute(UploadPost_scrn());
      // case rt_postFullScrn:
      //   return myRoute(PostFullscreen());

      default:
        return myRoute(Login_scrn());
    }
  }
}

myRoute(Route) {
  return CupertinoPageRoute(builder: (_) => Route);
}
