import 'dart:convert';

import 'package:awesome_book/Cards/msgLst_card.dart';
import 'package:awesome_book/Cards/people_card.dart';
import 'package:awesome_book/models/allMessagesList_model.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';

class Messagelist_Scrn extends StatefulWidget {
  final String type;
  const Messagelist_Scrn({super.key, required this.type});

  @override
  State<Messagelist_Scrn> createState() => _Messagelist_ScrnState();
}

class _Messagelist_ScrnState extends State<Messagelist_Scrn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmessageList_async();
  }

  List<AllmessageslistModel> msgList = [];

  getmessageList_async() async {
    Uri url = Uri.parse(glb.API.GetMsgLst);

    try {
      var res = await http.post(url, body: {
        'user_id': glb.userDetails.id,
      });

      print(res.body);
      List b = jsonDecode(res.body);
      var bdy = jsonDecode(res.body);

      for (var user in bdy) {
        msgList.add(AllmessageslistModel(
          id: user['id'].toString(),
          name: user['user_name'].toString(),
          profile_image: glb.API.baseURL + user['profile_image'].toString(),
        ));
      }
      setState(() {});
    } catch (e) {}
  }

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
        title: Txt(text: "Messages"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.sp),
            child: Icon(Icons.message_rounded),
          )
        ],
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
                    itemCount: msgList.length,
                    itemBuilder: (context, index) {
                      return MessageList_Card(
                        allMessagesList: msgList[index],
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
