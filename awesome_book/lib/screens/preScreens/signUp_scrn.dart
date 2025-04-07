import 'package:awesome_book/Route/router.dart';
import 'package:awesome_book/utils/colours.dart';
import 'package:awesome_book/utils/mybutton.dart';

import 'package:awesome_book/widgets/mytext.dart';
import 'package:awesome_book/widgets/textField.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:awesome_book/utils/global.dart' as glb;

class Signup_scrn extends StatefulWidget {
  const Signup_scrn({
    super.key,
  });

  @override
  State<Signup_scrn> createState() => _Signup_scrnState();
}

class _Signup_scrnState extends State<Signup_scrn> {
  bool firstCont = true, secondCont = false;
  TextEditingController _codeController = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController pswd_controller = TextEditingController();
  TextEditingController confirmPswd_controller = TextEditingController();

  bool Pswd_visible = false;
  bool confirmPswd_visible = false;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the code passed via deep link
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Txt(
          text: "Sign up",
          fntWt: FontWeight.bold,
          fntSz: 20.sp,
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(),
            // Text(
            //   "Signup",
            //   style: TextStyle(
            //       color: Colors.white70,
            //       fontFamily: "Poppins",
            //       fontSize: 22,
            //       fontWeight: FontWeight.bold),
            // ),
            SizedBox(
              height: 25.h,
              child: Image.asset("assets/images/signup3.png"),
            ),

            // todo: first container
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  curve: Curves.bounceInOut,
                  width: firstCont ? MediaQuery.of(context).size.width : 0,
                  child: firstCont
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Txt(
                                text: "OTP will be sent to this email",
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Material(
                                elevation: 10,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.sp),
                                ),
                                child: TextField(
                                  controller: email_controller,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xff667BF2),
                                      ),
                                    ),
                                    // hintText: 'Mobile number',
                                    labelText: "Email",

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              // ? pswd TF
                              Material(
                                elevation: 10,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.sp),
                                ),
                                child: TextField(
                                  obscureText: !Pswd_visible,
                                  controller: pswd_controller,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xff667BF2),
                                      ),
                                    ),
                                    // hintText: 'Mobile number',
                                    labelText: "Password",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          Pswd_visible = !Pswd_visible;
                                        });
                                      },
                                      icon: Icon(confirmPswd_visible
                                          ? CupertinoIcons.eye_slash
                                          : CupertinoIcons.eye),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
// ?confirm pswd
                              Material(
                                elevation: 10,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.sp),
                                ),
                                child: TextField(
                                  obscureText: !confirmPswd_visible,
                                  controller: confirmPswd_controller,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xff667BF2),
                                      ),
                                    ),
                                    // hintText: 'Mobile number',
                                    labelText: "Confirm Password",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          confirmPswd_visible =
                                              !confirmPswd_visible;
                                        });
                                      },
                                      icon: Icon(confirmPswd_visible
                                          ? CupertinoIcons.eye_slash
                                          : CupertinoIcons.eye),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              MyButton(
                                foregroundColor: Colors.black,
                                required_widget: const Txt(text: "Next"),
                                on_tap: () {
                                  setState(() {
                                    if (email_controller.text
                                        .trim()
                                        .isNotEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: Txt(text: "Confirm email"),
                                              content: Txt(
                                                  text: email_controller.text
                                                      .trim()),
                                              actions: [
                                                CupertinoDialogAction(
                                                  child: Txt(text: "Confirm"),
                                                  onPressed: () {
                                                    // print("$firstCont\n$secondCont");

                                                    sendOTP(
                                                        email_controller.text);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoDialogAction(
                                                  child: Txt(text: "Edit"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    } else {
                                      glb.errorSnackBar(
                                          context, "Enter a vaild mail");
                                    }
                                  });
                                },
                              )
                              // TextField(
                              //   style: TextStyle(color: Colors.white),
                              //   decoration: InputDecoration(
                              //     filled: true,
                              //     fillColor: Colors.grey.shade100.withOpacity(0.3),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(10),
                              //       borderSide: BorderSide(
                              //         color: Color(0xff667BF2),
                              //       ),
                              //     ),
                              //     hintText: 'Password',
                              //     // prefixIcon: Icon(Icons.call),

                              //     prefixStyle: TextStyle(color: Colors.white70),
                              //     border: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(10),
                              //       borderSide: BorderSide.none,
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                            ],
                          ),
                        )
                      : const Column(),
                ),
                // ? Second container

                AnimatedContainer(
                  width: firstCont
                      ? 0
                      : secondCont
                          ? MediaQuery.of(context).size.width
                          : 0,
                  color: Colors.transparent,
                  curve: Curves.bounceInOut,
                  duration: Duration(
                      seconds: firstCont
                          ? 0
                          : secondCont
                              ? 0
                              : 2),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10.sp,
                      right: 10.sp,
                      top: 30.sp,
                      bottom: 10.sp,
                    ),
                    child: firstCont
                        ? const Column()
                        : !secondCont
                            ? const Column()
                            : Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Txt(
                                      text:
                                          "Enter the OTP sent to this email: ${email_controller.text.trim()}",
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    TextField(
                                      controller: _codeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.sp),
                                          borderSide: const BorderSide(
                                            color: Color(0xff667BF2),
                                          ),
                                        ),
                                        // hintText: 'Mobile number',
                                        labelText: "OTP",

                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.sp),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                firstCont = true;
                                                secondCont = false;
                                              });
                                            },
                                            child: Txt(text: "Cancel")),
                                        MyButton(
                                            wdt: 50.w,
                                            foregroundColor: Colors.black,
                                            required_widget:
                                                Txt(text: "Confirm"),
                                            on_tap: () async {
                                              var r = await EmailOTP.verifyOTP(
                                                  otp: _codeController.text);
                                              if (r) {
                                                print("OTP verified");
                                                Navigator.pushNamed(context,
                                                    RouteGenerator.rt_login);
                                                glb.doneDialog(context);
                                              } else {
                                                glb.errorSnackBar(context,
                                                    "Invalid OTP/OTP timeout");
                                              }
                                            }),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   width: 200,
                                    //   child: NeoPopButton(
                                    //     color: Color.fromARGB(255, 65, 205, 182),
                                    //     shadowColor: Colors.black,
                                    //     onTapUp: () => HapticFeedback.vibrate(),
                                    //     onTapDown: () {
                                    //       HapticFeedback.vibrate();
                                    //       setState(() {
                                    //         firstCont = false;
                                    //         secondCont = false;
                                    //       });
                                    //     },
                                    //     child: Padding(
                                    //       padding: EdgeInsets.symmetric(
                                    //           horizontal: 20, vertical: 15),
                                    //       child: Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.center,
                                    //         children: [
                                    //           Text("Next"),
                                    //           Icon(Icons.arrow_right),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  width: firstCont
                      ? 0
                      : secondCont
                          ? 0
                          : MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Column(
                      children: [
                        Material(
                          elevation: 10,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.sp),
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: const BorderSide(
                                  color: Color(0xff667BF2),
                                ),
                              ),
                              labelText: "Full name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Material(
                          elevation: 10,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.sp),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: const BorderSide(
                                  color: Color(0xff667BF2),
                                ),
                              ),
                              labelText: "Password",

                              // prefixIcon: Icon(Icons.call),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          elevation: 10,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.sp),
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: const BorderSide(
                                  color: Color(0xff667BF2),
                                ),
                              ),
                              labelText: "Confirm password",

                              // prefixIcon: Icon(Icons.call),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        MyButton(
                            required_widget: const Txt(text: "Next"),
                            on_tap: () {})
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  sendOTP(String email) async {
    EmailOTP.setTemplate(
      template: '''

<div style="background-color: #f4f4f4; padding: 20px; font-family: Arial, sans-serif;">

<div style="background-color: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">

<h1 style="color: #333;">{{appName}}</h1>

<div id="otp"

style="display: flex; align-items: center;font-size: 2vh; color: #333;   border-radius: 10px; background-color: #f4f4f4;">

<div id="r" style=" height: 100%; width: 50%;">

<p style="color: #333; font-size:3vh; ">Your OTP is </p> <br><br>

</div>

<div id="l" style=" height: 100%; width: 50%; padding-bottom: 5vh;">

<h2>{{otp}}</h2>

</div>

</div>

<p style="color: #333;">This OTP is valid for 5 minutes.</p>

<p style="color: #868686;">Crawlers technologies.</p>

</div>

</div>

''',
    );

    var res = await EmailOTP.sendOTP(email: "$email");

    print("res = ${res}");
    if (res) {
      print("OTP sent successfully");
      print(EmailOTP.getOTP());
      setState(() {
        firstCont = false;
        secondCont = true;
        _codeController.text = EmailOTP.getOTP().toString();
      });
    }
  }
}
