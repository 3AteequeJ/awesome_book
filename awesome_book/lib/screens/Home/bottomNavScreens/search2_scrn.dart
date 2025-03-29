import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Search2_scrn extends StatefulWidget {
  const Search2_scrn({super.key});

  @override
  State<Search2_scrn> createState() => _Search2_scrnState();
}

class _Search2_scrnState extends State<Search2_scrn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.xmark),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Search"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            TextField(
              // enabled: false,
              decoration: InputDecoration(
                hintText: "Search people",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.w),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
