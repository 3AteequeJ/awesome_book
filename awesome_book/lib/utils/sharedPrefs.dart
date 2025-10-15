// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:awesome_book/utils/global.dart' as glb;

// Future<void> loadUserFromPrefs() async {
//   final prefs = await SharedPreferences.getInstance();

//   glb.userDetails.id = prefs.getString('sp_userID') ?? "";
//   glb.userDetails.name = prefs.getString('sp_Name') ?? "";
//   glb.userDetails.user_name = prefs.getString('sp_userNm') ?? "";
//   glb.userDetails.email_id = prefs.getString('sp_email') ?? "";
//   glb.userDetails.pswd = prefs.getString('sp_pswd') ?? "";
//   glb.userDetails.profile_img = prefs.getString('sp_img') ?? "";
//   glb.userDetails.verified = prefs.getString('sp_verified') ?? "";
//   glb.userDetails.status = prefs.getString('sp_status') ?? "";
//   glb.userDetails.open = prefs.getString('sp_open') ?? "";
//   glb.userDetails.dateTime = prefs.getString('sp_datetime') ?? "";
//   glb.userDetails.no_posts = prefs.getString('sp_no_posts') ?? "";
//   glb.userDetails.no_follower = prefs.getString('sp_no_follower') ?? "";
//   glb.userDetails.no_following = prefs.getString('sp_no_following') ?? "";
//   glb.userDetails.bio = prefs.getString('sp_bio') ?? "";
// }

// Future<void> saveUser(glb.newUser user) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   String userJson = jsonEncode(user.toJson()); // Convert to JSON string
//   await prefs.setString('user_data', userJson);
//   print("User details saved: $userJson");
// }

// // Function to retrieve user data
// Future<glb.newUser?> getUser() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? userJson = prefs.getString('user_data');

//   if (userJson == null || userJson.isEmpty) {
//     return null; // No data found or empty string
//   }

//   try {
//     return glb.newUser
//         .fromJson(jsonDecode(userJson)); // Convert JSON back to object
//   } catch (e) {
//     print('Error decoding user data: $e');
//     return null; // Return null if decoding fails
//   }
// }

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_book/utils/global.dart' as glb;

/// ✅ Clear all saved preferences
Future<void> clearAllPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print("✅ All SharedPreferences cleared.");
}

/// ✅ Load user data from SharedPreferences into global user object
Future<void> loadUserFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();

  glb.userDetails.id = prefs.getString('sp_userID') ?? "";
  glb.userDetails.name = prefs.getString('sp_Name') ?? "";
  glb.userDetails.user_name = prefs.getString('sp_userNm') ?? "";
  glb.userDetails.email_id = prefs.getString('sp_email') ?? "";
  glb.userDetails.pswd = prefs.getString('sp_pswd') ?? "";
  glb.userDetails.profile_img = prefs.getString('sp_img') ?? "";
  glb.userDetails.verified = prefs.getString('sp_verified') ?? "";
  glb.userDetails.status = prefs.getString('sp_status') ?? "";
  glb.userDetails.open = prefs.getString('sp_open') ?? "";
  glb.userDetails.dateTime = prefs.getString('sp_datetime') ?? "";
  glb.userDetails.no_posts = prefs.getString('sp_no_posts') ?? "";
  glb.userDetails.no_follower = prefs.getString('sp_no_follower') ?? "";
  glb.userDetails.no_following = prefs.getString('sp_no_following') ?? "";
  glb.userDetails.bio = prefs.getString('sp_bio') ?? "";

  print("✅ User loaded from prefs: ${glb.userDetails.user_name}");
}

/// ✅ Save user object into SharedPreferences
Future<void> saveUser(glb.newUser user) async {
  final prefs = await SharedPreferences.getInstance();
  String userJson = jsonEncode(user.toJson());
  await prefs.setString('user_data', userJson);
  print("✅ User saved: $userJson");
}

/// ✅ Get user from SharedPreferences (returns null if not found)/ // Function to retrieve user data
Future<glb.newUser?> getUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('user_data');

  if (userJson == null || userJson.isEmpty) {
    return null; // No data found or empty string
  }

  try {
    return glb.newUser
        .fromJson(jsonDecode(userJson)); // Convert JSON back to object
  } catch (e) {
    print('Error decoding user data: $e');
    return null; // Return null if decoding fails
  }
}
