import 'package:awesome_book/Cards/people_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Messagelist_Scrn extends StatefulWidget {
  final String type;
  const Messagelist_Scrn({super.key, required this.type});

  @override
  State<Messagelist_Scrn> createState() => _Messagelist_ScrnState();
}

class _Messagelist_ScrnState extends State<Messagelist_Scrn> {
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
        title: Text("Messages"),
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
