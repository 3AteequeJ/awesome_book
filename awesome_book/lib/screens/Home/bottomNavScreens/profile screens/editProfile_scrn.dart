import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditProfile_scrn extends StatefulWidget {
  const EditProfile_scrn({super.key});

  @override
  State<EditProfile_scrn> createState() => _EditProfile_scrnState();
}

class _EditProfile_scrnState extends State<EditProfile_scrn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            child: Image.asset(
              fit: BoxFit.cover,
              "assets/images/bg_gradient.jpeg",
            ),
          ),
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Edit Profile"),
        ),
        body: ListView(children: [
          Padding(
            padding: EdgeInsets.all(12.sp),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 20.w,
                      backgroundImage: AssetImage('assets/images/post2.png'),
                    ),
                    CircleAvatar(
                      radius: 5.w,
                      backgroundColor: Colors.blue.withOpacity(.5),
                      child: Icon(Icons.edit),
                    )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  // enabled: false,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  // enabled: false,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  // enabled: false,
                  decoration: InputDecoration(
                    hintText: "Bio",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  // enabled: false,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  // enabled: false,
                  decoration: InputDecoration(
                    hintText: "Phone",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextField(
                  // enabled: false,
                  decoration: InputDecoration(
                    hintText: "Location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Txt(text: "Save"))
              ],
            ),
          ),
        ]));
  }
}
