import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';

bool shouldRefreshProfile = false;
// ✅ Store follow/unfollow state temporarily in memory
Map<String, bool> followCache = {};
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
bool get isLoggedIn =>
    userDetails.id != null &&
    userDetails.id.isNotEmpty &&
    userDetails.id != "-1";

// ✅ Global in-memory user object
UserDetails userDetails = UserDetails();

// ✅ User model (non-static, instance-based)
class UserDetails {
  String id = "";
  String name = "";
  String user_name = "";
  String email_id = "";
  String profile_img = "";
  String pswd = "";
  String verified = "";
  String status = "";
  String open = "";
  String dateTime = "";
  String no_posts = "";
  String no_follower = "";
  String no_following = "";
  String bio = "";
}

class newUser {
  late String id;
  late String name;
  late String user_name;
  late String email_id;
  late String profile_img;
  late String pswd;
  late String verified;
  late String status;
  late String open;
  late String dateTime;
  late String no_posts;
  late String no_follower;
  late String no_following;
  late String bio;

  newUser({
    required this.id,
    required this.name,
    required this.user_name,
    required this.email_id,
    required this.profile_img,
    required this.pswd,
    required this.verified,
    required this.status,
    required this.open,
    required this.dateTime,
    required this.no_posts,
    required this.no_follower,
    required this.no_following,
    required this.bio,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_name': user_name,
      'email_id': email_id,
      'profile_img': profile_img,
      'pswd': pswd,
      'verified': verified,
      'status': status,
      'open': open,
      'dateTime': dateTime,
      'no_posts': no_posts,
      'no_follower': no_follower,
      'no_following': no_following,
      'bio': bio,
    };
  }

  // Convert JSON to object
  factory newUser.fromJson(Map<String, dynamic> json) {
    return newUser(
      id: json['id']?.toString() ?? "",
      name: json['name']?.toString() ?? "",
      user_name: json['user_name']?.toString() ?? "", // ✅ fixed
      email_id: json['email_id']?.toString() ?? "",
      profile_img: json['profile_img']?.toString() ?? "",
      pswd: json['pswd']?.toString() ?? "",
      verified: json['verified']?.toString() ?? "",
      status: json['status']?.toString() ?? "",
      open: json['open']?.toString() ?? "",
      dateTime: json['dateTime']?.toString() ?? "",
      no_posts: json['no_posts']?.toString() ?? "",
      no_follower: json['no_follower']?.toString() ?? "",
      no_following: json['no_following']?.toString() ?? "",
      bio: json['bio']?.toString() ?? "",
    );
  }
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
  static const String unlike_post = baseURL + "unlike_post";
  static const String ViewStory = baseURL + "View_story";
  static const String uploadComment = baseURL + "Upload_comments";
  static const String GetMsgLst = baseURL + "GetMsgLst";
  static const String getConvo = baseURL + "GetConvo";
  static const String search = baseURL + "search";
  static const String GetMyDets = baseURL + "GetMyDets";
  static const String GetMyStories = baseURL + "GetMyStories";
  static const String UploadStory = baseURL + "Upload_story";
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
  try {
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
  } catch (e) {
    return "Now";
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
// ======== Toast & Loading Utilities ========

void successToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void infoToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.blueAccent,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<void> showLoginPrompt(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Login Required",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "You need to login or register to perform this action.",
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // just close
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'rt_login'); // route to login
            },
            child: const Text("Login"),
          ),
        ],
      );
    },
  );
}
