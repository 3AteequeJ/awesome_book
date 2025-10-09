// import 'package:awesome_book/widgets/mytext.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class EditProfile_scrn extends StatefulWidget {
//   const EditProfile_scrn({super.key});

//   @override
//   State<EditProfile_scrn> createState() => _EditProfile_scrnState();
// }

// class _EditProfile_scrnState extends State<EditProfile_scrn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           flexibleSpace: Container(
//             child: Image.asset(
//               fit: BoxFit.cover,
//               "assets/images/bg_gradient.jpeg",
//             ),
//           ),
//           leading: IconButton(
//             icon: Icon(CupertinoIcons.back),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: Text("Edit Profile"),
//         ),
//         body: ListView(children: [
//           Padding(
//             padding: EdgeInsets.all(12.sp),
//             child: Column(
//               children: [
//                 Stack(
//                   alignment: Alignment.bottomRight,
//                   children: [
//                     CircleAvatar(
//                       radius: 20.w,
//                       backgroundImage: AssetImage('assets/images/post2.png'),
//                     ),
//                     CircleAvatar(
//                       radius: 5.w,
//                       backgroundColor: Colors.blue.withOpacity(.5),
//                       child: Icon(Icons.edit),
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 TextField(
//                   // enabled: false,
//                   decoration: InputDecoration(
//                     hintText: "Name",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.w),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 TextField(
//                   // enabled: false,
//                   decoration: InputDecoration(
//                     hintText: "Username",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.w),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 TextField(
//                   // enabled: false,
//                   decoration: InputDecoration(
//                     hintText: "Bio",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.w),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 TextField(
//                   // enabled: false,
//                   decoration: InputDecoration(
//                     hintText: "Email",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.w),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 TextField(
//                   // enabled: false,
//                   decoration: InputDecoration(
//                     hintText: "Phone",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.w),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 TextField(
//                   // enabled: false,
//                   decoration: InputDecoration(
//                     hintText: "Location",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(5.w),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(onPressed: () {}, child: Txt(text: "Save"))
//               ],
//             ),
//           ),
//         ]));
//   }
// }

import 'dart:convert';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile_scrn extends StatefulWidget {
  const EditProfile_scrn({super.key});

  @override
  State<EditProfile_scrn> createState() => _EditProfile_scrnState();
}

class _EditProfile_scrnState extends State<EditProfile_scrn> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _location = TextEditingController();

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    // ✅ Prefill user data (loaded from SharedPrefs at app start)
    _name.text = glb.userDetails.name;
    _username.text = glb.userDetails.user_name;
    _bio.text = glb.userDetails.bio;
    _email.text = glb.userDetails.email_id;
    _phone.text =
        glb.userDetails.pswd; // replace with actual phone if available
    _location.text = "";
  }

  // 🔹 Common reusable input widget
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
      ),
    );
  }

  // 🔹 API call for update
  Future<void> _updateProfile() async {
    if (_saving) return;
    setState(() => _saving = true);
    glb.loading(context);

    try {
      final userId = glb.userDetails.id;
      if (userId.isEmpty) {
        Navigator.pop(context);
        glb.errorToast(context, "User not found. Please re-login.");
        return;
      }

      final url = Uri.parse(
          "https://awesomebook.in/awesomebookbackend/UpdateUserDetails");

      final body = {
        "user_id": userId,
        "name": _name.text.trim(),
        "user_name": _username.text.trim(),
        "bio": _bio.text.trim(),
      };

      print("📡 Sending Update => $body");

      final res = await http.post(url, body: body);

      print("🔹 Response Code: ${res.statusCode}");
      print("🔹 Response Body: ${res.body}");

      Navigator.pop(context); // close loader

      if (res.statusCode == 200) {
        final clean = res.body.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        print("🧹 Cleaned Response: $clean");

        bool success = false;

        // The backend returns either 1, true, or "success"
        if (clean == "1" ||
            clean.toLowerCase().contains("true") ||
            clean.toLowerCase().contains("success") ||
            clean.toLowerCase().contains("update")) {
          success = true;
        }

        if (success) {
          // ✅ Update locally
          glb.userDetails.name = _name.text.trim();
          glb.userDetails.user_name = _username.text.trim();
          glb.userDetails.bio = _bio.text.trim();

          // ✅ Save for persistence
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('sp_Name', glb.userDetails.name);
          await prefs.setString('sp_userNm', glb.userDetails.user_name);
          await prefs.setString('sp_bio', glb.userDetails.bio);

          glb.successToast(context, "Profile updated successfully ✅");
          if (mounted) Navigator.pop(context, true);
        } else {
          glb.errorToast(context, "Failed to update profile. Response: $clean");
        }
      } else {
        glb.errorToast(context, "Server error (${res.statusCode})");
      }
    } catch (e) {
      Navigator.pop(context);
      glb.errorToast(context, "Error: $e");
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_gradient.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.all(12.sp),
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 20.w,
                    backgroundImage: (glb.userDetails.profile_img.isNotEmpty)
                        ? NetworkImage(glb.userDetails.profile_img
                                .startsWith("http")
                            ? glb.userDetails.profile_img
                            : "https://awesomebook.in/${glb.userDetails.profile_img}")
                        : const AssetImage('assets/images/post2.png')
                            as ImageProvider,
                  ),
                  CircleAvatar(
                    radius: 5.w,
                    backgroundColor: Colors.blue.withOpacity(.5),
                    child: const Icon(Icons.edit, color: Colors.white),
                  )
                ],
              ),
              SizedBox(height: 2.h),
              _inputField(controller: _name, hint: "Name", icon: Icons.person),
              SizedBox(height: 2.h),
              _inputField(
                  controller: _username,
                  hint: "Username",
                  icon: Icons.alternate_email),
              SizedBox(height: 2.h),
              _inputField(
                  controller: _bio,
                  hint: "Bio",
                  icon: Icons.info_outline,
                  maxLines: 3),
              SizedBox(height: 2.h),
              _inputField(controller: _email, hint: "Email"),
              SizedBox(height: 2.h),
              _inputField(controller: _phone, hint: "Phone"),
              SizedBox(height: 2.h),
              _inputField(controller: _location, hint: "Location"),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 206, 206, 206),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.sp)),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Txt(
                    text: _saving ? "Saving..." : "Save",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:awesome_book/utils/global.dart' as glb;
// import 'package:awesome_book/utils/mybutton.dart';
// import 'package:awesome_book/utils/sharedPrefs.dart';
// import 'package:awesome_book/widgets/mytext.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:responsive_sizer/responsive_sizer.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _name = TextEditingController();
//   final TextEditingController _username = TextEditingController();
//   final TextEditingController _bio = TextEditingController();

//   bool _saving = false;

//   @override
//   void initState() {
//     super.initState();
//     // Prefill from global user details
//     _name.text = glb.userDetails.name;
//     _username.text = glb.userDetails.user_name;
//     _bio.text = glb.userDetails.bio;
//   }

//   @override
//   void dispose() {
//     _name.dispose();
//     _username.dispose();
//     _bio.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _saving = true);
//     glb.loading(context);

//     try {
//       final userId = glb.userDetails.id.toString();
//       print("🧠 Sending user_id: $userId");

//       if (userId.isEmpty || userId == "0" || userId == "null") {
//         Navigator.pop(context);
//         glb.errorToast(context, "Invalid user ID. Please re-login.");
//         return;
//       }

//       // Use form-data (backend expects this, not JSON)
//       final response = await http.post(
//         Uri.parse(
//             "https://awesomebook.in/awesomebookbackend/UpdateUserDetails"),
//         body: {
//           "user_id": userId,
//           "name": _name.text.trim(),
//           "user_name": _username.text.trim(),
//           "bio": _bio.text.trim(),
//         },
//       );

//       print("🔹 Status: ${response.statusCode}");
//       print("🔹 Raw Response: ${response.body}");

//       if (!mounted) return;
//       Navigator.pop(context); // close loading dialog

//       if (response.statusCode == 200) {
//         final resBody = response.body.trim();

//         // ✅ Handle plain "1" or "0" or full JSON map
//         bool success = false;
//         String message = "";

//         if (resBody == "1") {
//           success = true;
//           message = "Profile updated successfully.";
//         } else if (resBody == "0") {
//           success = false;
//           message = "Update failed — user not found or invalid data.";
//         } else {
//           try {
//             final decoded = jsonDecode(resBody);
//             if (decoded is Map) {
//               message = decoded["message"]?.toString() ??
//                   decoded["msg"]?.toString() ??
//                   "";
//               success = message.toLowerCase().contains("update") ||
//                   decoded["status"] == true ||
//                   decoded["success"] == true;
//             }
//           } catch (_) {
//             message = resBody;
//             success = resBody.toLowerCase().contains("update") ||
//                 resBody.toLowerCase().contains("success");
//           }
//         }

//         if (success) {
//           // ✅ Update local user data
//           setState(() {
//             glb.userDetails.name = _name.text.trim();
//             glb.userDetails.user_name = _username.text.trim();
//             glb.userDetails.bio = _bio.text.trim();
//           });

//           // ✅ Save locally for persistence
//           await glb.saveUser(glb.newUser(
//             id: glb.userDetails.id,
//             name: glb.userDetails.name,
//             user_name: glb.userDetails.user_name,
//             email_id: glb.userDetails.email_id,
//             profile_img: glb.userDetails.profile_img,
//             pswd: glb.userDetails.pswd,
//             verified: glb.userDetails.verified,
//             status: glb.userDetails.status,
//             open: glb.userDetails.open,
//             dateTime: glb.userDetails.dateTime,
//             no_posts: glb.userDetails.no_posts,
//             no_follower: glb.userDetails.no_follower,
//             no_following: glb.userDetails.no_following,
//             bio: glb.userDetails.bio,
//           ));

//           await glb.DonePopUp(context);
//           if (mounted) Navigator.pop(context, true);
//         } else {
//           glb.errorToast(
//               context,
//               message.isNotEmpty
//                   ? message
//                   : "Update failed. Please try again.");
//         }
//       } else {
//         glb.errorToast(context, "Server error (${response.statusCode})");
//       }
//     } catch (e) {
//       if (mounted) {
//         Navigator.pop(context);
//         glb.errorToast(context, "Network error: $e");
//       }
//     } finally {
//       if (mounted) setState(() => _saving = false);
//     }
//   }

//   Widget _field({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return Material(
//       elevation: 5,
//       color: Colors.black,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.sp),
//       ),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         style: const TextStyle(color: Colors.black),
//         validator: validator,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15.sp),
//             borderSide: const BorderSide(color: Color(0xff667BF2)),
//           ),
//           hintText: hint,
//           prefixIcon: Icon(icon, color: Colors.black),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15.sp),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: const Txt(text: "Edit Profile"),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(18.sp),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 40,
//                 backgroundImage: (glb.userDetails.profile_img.isNotEmpty &&
//                         !glb.userDetails.profile_img.startsWith("file:/"))
//                     ? NetworkImage(glb.userDetails.profile_img)
//                     : const AssetImage('assets/images/post1.jpg')
//                         as ImageProvider,
//               ),
//               SizedBox(height: 3.h),
//               _field(
//                 controller: _name,
//                 hint: "Full Name",
//                 icon: Icons.person,
//                 validator: (v) =>
//                     (v == null || v.trim().isEmpty) ? "Enter your name" : null,
//               ),
//               SizedBox(height: 2.h),
//               _field(
//                 controller: _username,
//                 hint: "Username",
//                 icon: Icons.alternate_email,
//                 validator: (v) =>
//                     (v == null || v.trim().isEmpty) ? "Enter username" : null,
//               ),
//               SizedBox(height: 2.h),
//               _field(
//                 controller: _bio,
//                 hint: "Bio",
//                 icon: Icons.info_outline,
//                 maxLines: 3,
//               ),
//               SizedBox(height: 3.h),
//               SizedBox(
//                 width: double.infinity,
//                 child: MyButton(
//                   foregroundColor: Colors.black,
//                   required_widget: Txt(
//                     text: _saving ? "Saving..." : "Save Changes",
//                   ),
//                   on_tap: () {
//                     if (!_saving) _submit();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
