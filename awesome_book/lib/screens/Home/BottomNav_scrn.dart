import 'package:awesome_book/screens/Home/bottomNavScreens/Activities_scrn.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/home_scrn.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/profile_scrn.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/reels_scrn.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/search_scrn.dart';
import 'package:awesome_book/try.dart';
import 'package:awesome_book/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNav_scrn extends StatefulWidget {
  const BottomNav_scrn({super.key});

  @override
  State<BottomNav_scrn> createState() => _BottomNav_scrnState();
}

List bodyScreens = [
  Home_scrn(),
  Search_scrn(),
  Reels_scrn(),
  // Activities_scrn(),
  // StoryPage(),
  Profile_scrn()
];

class _BottomNav_scrnState extends State<BottomNav_scrn> {
  int bottomNav_idx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyScreens[bottomNav_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNav_idx,
        onTap: (value) {
          setState(() {
            bottomNav_idx = value;
          });
        },
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
          grade: 12,
          color: Colours.brown,
          size: 22,
        ),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.house), label: " "),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search), label: " "),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.play_rectangle), label: " "),
          // BottomNavigationBarItem(
          //     icon: Icon(CupertinoIcons.bag_fill), label: " "),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled), label: " "),
        ],
      ),
    );
  }
}
