import 'package:awesome_book/Cards/people_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Following_scrn extends StatefulWidget {
  final String type;
  const Following_scrn({super.key, required this.type});

  @override
  State<Following_scrn> createState() => _Following_scrnState();
}

class _Following_scrnState extends State<Following_scrn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Following"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            TextField(
              // enabled: false,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.w),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return People_card(
                        type: widget.type,
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
