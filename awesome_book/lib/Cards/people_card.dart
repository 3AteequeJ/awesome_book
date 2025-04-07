import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class People_card extends StatefulWidget {
  final String type; //? 0-message / 1-followers / 2-following
  const People_card({super.key, required this.type});

  @override
  State<People_card> createState() => _People_cardState();
}

class _People_cardState extends State<People_card> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/1.jpg"),
                ),
                SizedBox(
                  width: 1.w,
                ),
                Txt(text: "User name"),
              ],
            ),
            Visibility(
              visible: widget.type != "0",
              child: widget.type == '1'
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: Text("Unfollow"),
                              content:
                                  Text("Are you sure you want to unfollow?"),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: Text("Yes"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Txt(text: "Follow back"),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: Text("Unfollow"),
                              content:
                                  Text("Are you sure you want to unfollow?"),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: Text("Yes"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Txt(text: "Following"),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
