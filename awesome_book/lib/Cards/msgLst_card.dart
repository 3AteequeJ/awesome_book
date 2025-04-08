import 'package:awesome_book/models/allMessagesList_model.dart';
import 'package:awesome_book/screens/Home/bottomNavScreens/Messages/message_scrn.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MessageList_Card extends StatefulWidget {
  final AllmessageslistModel allMessagesList;
  const MessageList_Card({
    super.key,
    required this.allMessagesList,
  });

  @override
  State<MessageList_Card> createState() => _MessageList_CardState();
}

class _MessageList_CardState extends State<MessageList_Card> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MessageScreen(
                      userDetails: widget.allMessagesList,
                    )));
      },
      child: Container(
        height: 10.h,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              // BoxShadow(
              //   color: Colors.black.withOpacity(0.2),
              //   // offset: Offset(0, 4), // Only bottom
              //   blurRadius: 6,
              //   spreadRadius: 0,
              // ),
            ],
            border:
                Border(bottom: BorderSide(color: Colors.grey.withOpacity(.5)))),
        child: Padding(
          padding: EdgeInsets.all(8.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        NetworkImage(widget.allMessagesList.profile_image),
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Txt(text: widget.allMessagesList.name),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
