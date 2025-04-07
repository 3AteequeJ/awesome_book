import 'dart:convert';
import 'package:awesome_book/utils/global.dart' as glb;
import 'package:awesome_book/Route/router.dart';
import 'package:awesome_book/screens/preScreens/signUp_scrn.dart';
import 'package:awesome_book/utils/mybutton.dart';
import 'package:awesome_book/utils/sharedPrefs.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login_scrn extends StatefulWidget {
  const Login_scrn({super.key});

  @override
  State<Login_scrn> createState() => _Login_scrnState();
}

class _Login_scrnState extends State<Login_scrn> {
  @override
  bool Pswd_visible = false;
  FocusNode mob_no_FN = FocusNode();
  FocusNode pswd_FN = FocusNode();
  TextEditingController name_cont = TextEditingController();
  TextEditingController pswd_cont = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 90.h,
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Row(),
                    // Container(
                    //   height: 100,
                    //   width: 100,
                    //   color: Colors.amber,
                    // ),
                    // Container(
                    //   height: 12.69.h,
                    //   width: 27.77.w,
                    //   color: Colors.blue,
                    // ),
                    // MyText(text: "${MediaQuery.of(context).size.width}"),
                    // MyText(text: "${MediaQuery.of(context).size.height}"),
                    // Text(
                    //   "Welcome back",
                    //   style: TextStyle(
                    //       color: Colors.white70,
                    //       fontFamily: "Poppins",
                    //       fontSize: 22,
                    //       fontWeight: FontWeight.bold),
                    // ),
                    Txt(
                      text: "Welcome back",
                      fntWt: FontWeight.bold,
                      fntSz: 22,
                    ),
                    SizedBox(
                      height: 25.h,
                      child: Image.asset("assets/images/welcome.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Txt(
                        text: "Login to your account with valid credentials",
                        // size: 16.sp,
                      ),
                      // child: Text(
                      //   "Login to your account with valid credentials",
                      //   style: TextStyle(
                      //     color: Colors.white70,
                      //     fontFamily: "Poppins",
                      //     fontSize: 16,
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(18.sp),
                child: Container(
                  child: Column(
                    children: [
                      Material(
                        elevation: 5,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.sp),
                        ),
                        child: TextField(
                          focusNode: mob_no_FN,
                          controller: name_cont,
                          style: TextStyle(color: Colors.black),
                          // keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            // fillColor: mob_no_FN.hasFocus
                            //     ? Colors.white
                            //     : Colors.grey.shade100.withOpacity(0.9),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.sp),
                              borderSide: const BorderSide(
                                color: Color(0xff667BF2),
                              ),
                            ),
                            hintText: 'Mobile number',
                            // prefixIcon: Icon(Icons.call),
                            prefixIcon: Icon(CupertinoIcons.person),
                            prefixStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.sp),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Material(
                        elevation: 5,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.sp),
                        ),
                        child: TextField(
                          focusNode: pswd_FN,
                          controller: pswd_cont,
                          obscureText: !Pswd_visible,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            // fillColor: pswd_FN.hasFocus
                            //     ? Colors.white
                            //     : Colors.grey.shade100.withOpacity(0.9),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.sp),
                              borderSide: const BorderSide(
                                color: Color(0xff667BF2),
                              ),
                            ),
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  Pswd_visible = !Pswd_visible;
                                });
                              },
                              icon: Icon(
                                Pswd_visible
                                    ? Icons.lock
                                    : Icons.remove_red_eye,
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.sp),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Signup_scrn(),
                              ),
                            );
                            // Navigator.pushNamed(
                            //     context, RouteGenerator.SignupScrn_rt);
                          },
                          child: RichText(
                            text: const TextSpan(
                                text: "New here? ",
                                style: TextStyle(color: Colors.black87),
                                children: [
                                  TextSpan(
                                    text: "Signup",
                                    style: TextStyle(
                                      color: Colors.pink,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                    foregroundColor: Colors.black,
                    required_widget: const Txt(
                      text: "Login",
                    ),
                    on_tap: () {
                      var a = name_cont.text.trim();
                      var b = pswd_cont.text.trim();
                      if (a.isEmpty && b.isEmpty) {
                        // glb.error_Snackbar(
                        //     context, "Please fill all the details");
                      } else {
                        if (a.isEmpty) {
                          // glb.error_Snackbar(
                          //     context, "Please enter mobile number");
                        } else if (b.isEmpty) {
                          // glb.error_Snackbar(context, "Please enter password");
                        } else {
                          // Login_async(a, b);
                          // Navigator.pushNamed(context, RouteGenerator.rt_home);

                          Login_async(a, b);
                        }
                      }

                      // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (context) => const BottomNavBar_scrn(),
                      //   ),
                      // );
                    }),
              ),
              SizedBox(
                height: 5.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  getMeMyUser() async {
    glb.newUser? user = await getUser();
    if (user != null) {
      print("Name: ${user.name},");
    } else {
      print("No user data found");
    }
  }

  Login_async(String mobile_number, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri URL = Uri.parse(glb.API.Login);
    try {
      var res = await http.post(URL, body: {
        'user_data': mobile_number,
      });

      // print(res.statusCode);
      // print(res.body);
      var bdy = jsonDecode(res.body);

      var rcvd_pswd = bdy[0]['password'];
      // print("password = $rcvd_pswd");
      if (password.toString() == rcvd_pswd.toString()) {
        // print("Correct pswd");

        setState(() {
          glb.userDetails.id = bdy[0]['id'].toString();
          glb.userDetails.name = bdy[0]['name'].toString();
          glb.userDetails.user_name = bdy[0]['user_name'].toString();
          glb.userDetails.email_id = bdy[0]['email_id'].toString();
          glb.userDetails.pswd = bdy[0]['password'].toString();
          glb.userDetails.profile_img = bdy[0]['profile_image'].toString();
          glb.userDetails.verified = bdy[0]['verified'].toString();
          glb.userDetails.status = bdy[0]['status'].toString();
          glb.userDetails.open = bdy[0]['open'].toString();
          glb.userDetails.dateTime = bdy[0]['timestamp'].toString();
          glb.userDetails.no_posts = bdy[0]['total_posts'].toString();
          glb.userDetails.no_follower = bdy[0]['total_followers'].toString();
          glb.userDetails.no_following = bdy[0]['total_following'].toString();
          glb.userDetails.bio = bdy[0]['bio'].toString();

          // glb.userDetails.refer_id = bdy[0]['refer_id'].toString();
        });
        print('here');
        await saveUser(glb.newUser(
            id: bdy[0]['id'].toString(),
            name: bdy[0]['name'].toString(),
            user_name: bdy[0]['user_name'].toString(),
            email_id: bdy[0]['email_id'].toString(),
            profile_img: bdy[0]['profile_image'].toString(),
            verified: bdy[0]['verified'].toString(),
            status: bdy[0]['status'].toString(),
            open: bdy[0]['open'].toString(),
            dateTime: bdy[0]['timestamp'].toString(),
            no_posts: bdy[0]['total_posts'].toString(),
            no_follower: bdy[0]['total_followers'].toString(),
            no_following: bdy[0]['total_following'].toString(),
            bio: bdy[0]['bio'].toString(),
            pswd: bdy[0]['password'].toString()));
        print('here 2 ');
        // var b = await getUser();
        getMeMyUser();
        print('here 3');
        // print("sp id = ${b!.id}");

        print("here 2");
        await prefs.setString('sp_userID', '${glb.userDetails.id}');
        await prefs.setString('sp_userNm', '${glb.userDetails.user_name}');
        await prefs.setString('sp_Name', '${glb.userDetails.name}');
        await prefs.setString('sp_pswd', '${glb.userDetails.pswd}');
        await prefs.setString('sp_email', '${glb.userDetails.email_id}');
        await prefs.setString('sp_verified', '${glb.userDetails.verified}');
        await prefs.setString('sp_open', '${glb.userDetails.open}');
        await prefs.setString('sp_status', '${glb.userDetails.status}');
        await prefs.setString('sp_img', '${glb.userDetails.profile_img}');
        await prefs.setString('sp_datetime', '${glb.userDetails.dateTime}');
        await prefs.setString('sp_bio', '${glb.userDetails.bio}');
        await prefs.setString('sp_no_posts', '${glb.userDetails.no_posts}');
        await prefs.setString(
            'sp_no_follower', '${glb.userDetails.no_follower}');
        await prefs.setString(
            'sp_no_following', '${glb.userDetails.no_following}');
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(
        //     builder: (context) => const BottomNavBar_scrn(),
        //   ),
        // );
        // Navigator.pushNamed(context, RouteGenerator.rt_home);
      } else {
        print("Wrong pswd");
        glb.errorToast(context, "Wrong pswd");
        // glb.error_Snackbar(context, "Wrong password");
      }
    } catch (e) {
      print("Login exception ==> ${e}");
    }
  }
}

// // ignore_for_file: prefer_const_constructors

// import 'package:new_new_bc_club/screens/login/signup_scrn.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

// class Login_scrn extends StatefulWidget {
//   const Login_scrn({super.key});

//   @override
//   State<Login_scrn> createState() => _Login_scrnState();
// }

// class _Login_scrnState extends State<Login_scrn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             height: 200,
//             // color: Colors.black,
//             decoration: BoxDecoration(
//               color: Colors.black,
//               // gradient: LinearGradient(
//               //   begin: Alignment.bottomLeft,
//               //   end: Alignment.topRight,
//               //   colors: [
//               //     Colors.black,
//               //     Color.fromARGB(255, 44, 43, 43),
//               //     Color.fromARGB(255, 44, 43, 43),
//               //     Colors.black,
//               //   ],
//               // ),
//             ),
//             // color: Color(0xff08E8DE),
//             child: Padding(
//               padding: EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 5),
//               child: Column(
//                 children: [
//                   Row(),
//                   // Align(
//                   //   alignment: Alignment.centerRight,
//                   //   child: Text(
//                   //     "Signup",
//                   //     style: TextStyle(
//                   //       fontFamily: "Aleo",
//                   //       color: Colors.white,
//                   //       decoration: TextDecoration.underline,
//                   //       decorationColor: Colors.white,
//                   //     ),
//                   //   ),
//                   // ),
//                   Expanded(child: Container()),
//                   Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Text(
//                       "Login",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: "Aleo",
//                         fontSize: 22,
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Text(
//                       "Tell us your mobile number",
//                       style: TextStyle(
//                         color: Colors.white, fontFamily: "Aleo",
//                         // fontSize: 22,
//                       ),
//                     ),
//                   ),
//                   // Align(
//                   //   alignment: Alignment.bottomLeft,
//                   //   child: Text(
//                   //     "Tell us your mobile number",
//                   //     style:
//                   //         TextStyle(color: Colors.white, fontFamily: "Poppins"
//                   //             // fontSize: 22,
//                   //             ),
//                   //   ),
//                   // )
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Material(
//               elevation: 100,
//               shadowColor: Colors.amber,
//               child: Container(
//                   color: Colors.white70,
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       left: 10,
//                       right: 10,
//                       top: 30,
//                       bottom: 10,
//                     ),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextField(
//                             keyboardType: TextInputType.phone,
//                             decoration: InputDecoration(
//                               label: Text("Mobile number"),
//                               prefixText: "+91 ",
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.grey,
//                                 ), // Border color when not focused
//                               ),
//                               border: OutlineInputBorder(
//                                 // borderRadius: BorderRadius.circular(10),
//                                 borderSide: BorderSide(
//                                   style: BorderStyle.solid,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           TextField(
//                             keyboardType: TextInputType.phone,
//                             decoration: InputDecoration(
//                               label: Text("Password"),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.grey,
//                                 ), // Border color when not focused
//                               ),
//                               border: OutlineInputBorder(
//                                 // borderRadius: BorderRadius.circular(10),
//                                 borderSide: BorderSide(
//                                   style: BorderStyle.solid,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     CupertinoPageRoute(
//                                         builder: (context) => SignUp_scrn()));
//                               },
//                               child: Text(
//                                 "new here? " + "Signup",
//                                 style: TextStyle(
//                                   fontFamily: "Aleo",
//                                   // color: Colors.white,
//                                   decoration: TextDecoration.underline,
//                                   // decorationColor: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 100,
//                           ),
//                           SizedBox(
//                             width: 200,
//                             child: NeoPopButton(
//                               color: Color.fromARGB(255, 65, 205, 182),
//                               shadowColor: Colors.black,
//                               onTapUp: () => HapticFeedback.vibrate(),
//                               onTapDown: () => HapticFeedback.vibrate(),
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 15),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text("Login"),
//                                     Icon(Icons.arrow_right)
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
