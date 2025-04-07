import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_book/Route/router.dart';
import 'package:awesome_book/screens/preScreens/login_scrn.dart';
import 'package:awesome_book/try.dart';
import 'package:awesome_book/try/camera.dart';
import 'package:awesome_book/try3.dart';

import 'package:awesome_book/utils/colours.dart';
import 'package:awesome_book/widgets/mytext.dart';
import 'package:camera/camera.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

//
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

late List<CameraDescription> _cameras;
Future<void> main() async {
  debugPrint = (String? message, {int? wrapWidth}) {};
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  EmailOTP.config(
    appName: 'Awesome book',
    otpType: OTPType.numeric,
    expiry: 30000,
    emailTheme: EmailTheme.v6,
    appEmail: 'ateeque.crawlerstechnologies@gmail.com',
    otpLength: 6,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (BuildContext, Orientation, ScreenType) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.black, background: Colours.Backgorund_white),
            useMaterial3: true,
          ),
          initialRoute: RouteGenerator.rt_splash,
          onGenerateRoute: RouteGenerator.generateRoute,
          // home: HomePage(),
          // home: ChatScreen(
          //   userId: 1,
          //   receiverId: 2,
          // ),
        );
      },
    );
  }
}
