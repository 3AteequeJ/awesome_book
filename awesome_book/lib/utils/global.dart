import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class userDetails {
  static String id = "";
  static String name = "";
  static String user_name = "";
  static String email_id = "";
  static String profile_img = "";
  static String pswd = "";
  static String verified = "";
  static String status = "";
  static String open = "";
  static String dateTime = "";
  static String no_posts = "";
  static String no_follower = "";
  static String no_following = "";
  static String bio = "";
}

class API {
  static const String baseURL = "https://awesomebook.in/awesomebookbackend/";
  static const String Login = baseURL + "login";
  static const String GetPosts = baseURL + "u_getPosts";
  static const String GetStories = baseURL + "Get_stories";
  static const String GetReels = baseURL + "Get_reels";
  static const String Get_foryouPosts = baseURL + "Get_foryou";
  static const String GetComments = baseURL + "get_comments";
  static const String UploadPost = baseURL + "Upload_post";
  static const String AddLike = baseURL + "Upload_likes";
  static const String uploadComment = baseURL + "Upload_comments";
}

errorSnackBar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt(text: "Error"),
          Txt(text: "${message}"),
        ],
      ),
    ),
  );
}

doneDialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SizedBox(
          height: 30.w,
          width: 30.w,
          child: Image.asset(
            "assets/images/done.gif",
            key:
                UniqueKey(), // This ensures the gif starts from the beginning each time
          ),
        ),
      );
    },
  );

  Future.delayed(Duration(seconds: 5), () {
    Navigator.of(context).pop();
  });
}

getDateTime(String dt) {
  DateTime date_time = DateTime.parse(dt);
  date_time = date_time.add(Duration(hours: 5, minutes: 30));
  final DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
  final String formatted = formatter.format(date_time);
  return formatted;
}

getDuration(String dt) {
  DateTime now = DateTime.now();
  DateTime pastdate = DateTime.parse(dt);
  Duration duration = now.difference(pastdate);
  if (duration.inSeconds < 60) {
    return '${duration.inSeconds} seconds ago';
  } else if (duration.inMinutes < 60) {
    return '${duration.inMinutes} minutes ago';
  } else if (duration.inHours < 24) {
    return '${duration.inHours} hours ago';
  } else {
    return '${duration.inDays} days ago';
  }
}

ConfirmationBox(BuildContext context, String msg, VoidCallback onPrsd) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Txt(
            text: "Are you sure?",
            fntWt: FontWeight.bold,
          ),
          content: Txt(text: msg),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Txt(text: "Cancle"),
            ),
            ElevatedButton(
              onPressed: onPrsd,
              child: Txt(text: "OK"),
            ),
          ],
        );
      });
}

loading(BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Txt(text: "Loading..."),
          content: SizedBox(
              height: 10.h, child: Center(child: CircularProgressIndicator())),
        );
      });
}

DonePopUp(BuildContext context) {
  return showDialog(
      // barrierColor: Colors.white,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Txt(text: "DONE"),
          content: SizedBox(
            height: 10.h,
            child: Center(
              child: Image.asset("assets/images/done2.gif"),
            ),
          ),
        );
      }).timeout(Duration(seconds: 5), onTimeout: () {
    Navigator.pop(context);
  });
}

errorToast(context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.only(bottom: 80.h),
      dismissDirection: DismissDirection.up,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.sp),
      ),
      behavior: SnackBarBehavior.floating,
      content: Txt(text: msg),
      backgroundColor: Colors.redAccent,
    ),
  );
}

Future<void> showLoadingDialog(
    BuildContext context, Future<void> dataFuture) async {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents user from dismissing manually
    builder: (context) {
      return const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Loading..."),
          ],
        ),
      );
    },
  );

  // Wait for whichever happens first: data retrieval or timeout
  await Future.any([
    dataFuture, // Your data fetching Future
    Future.delayed(const Duration(seconds: 10)), // Timeout duration
  ]);

  if (context.mounted) {
    Navigator.pop(context); // Close the dialog
  }
}
