import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_book/utils/global.dart' as glb;

Future<void> saveUser(glb.newUser user) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String userJson = jsonEncode(user.toJson()); // Convert to JSON string
  await prefs.setString('user_data', userJson);
  print("User details saved: $userJson");
}

// Function to retrieve user data
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
