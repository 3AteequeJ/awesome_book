// import 'package:awesome_book/Route/router.dart';

// import 'package:awesome_book/utils/colours.dart';
// import 'package:camera/camera.dart';
// import 'package:email_otp/email_otp.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// late List<CameraDescription> _cameras;
// Future<void> main() async {
//   debugPrint = (String? message, {int? wrapWidth}) {};
//   // WidgetsFlutterBinding.ensureInitialized();

//   // Use RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("9325AA6C0862E631388E210ED7DA4B36")) to get test ads on this device.
//   WidgetsFlutterBinding.ensureInitialized();
//   // await MobileAds.instance.initialize();
//   // final config = RequestConfiguration(
//   //   // testDeviceIds: ['9325AA6C0862E631388E210ED7DA4B36'],
//   //   testDeviceIds: ['2DEB5FE6EE761CD0925C193DD00624B3'],
//   // );
//   // MobileAds.instance.updateRequestConfiguration(config);
//   await MobileAds.instance.initialize();
//   final config = RequestConfiguration(
//     testDeviceIds: ["2DEB5FE6EE761CD0925C193DD00624B3"], // your device ID
//   );
//   MobileAds.instance.updateRequestConfiguration(config);

//   MobileAds.instance.updateRequestConfiguration(
//     RequestConfiguration(testDeviceIds: ["2DEB5FE6EE761CD0925C193DD00624B3"]),
//   );

//   _cameras = await availableCameras();
//   EmailOTP.config(
//     appName: 'Awesome book',
//     otpType: OTPType.numeric,
//     expiry: 30000,
//     emailTheme: EmailTheme.v6,
//     appEmail: 'ateeque.crawlerstechnologies@gmail.com',
//     otpLength: 6,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveSizer(
//       builder: (BuildContext, Orientation, ScreenType) {
//         return MaterialApp(
//           title: 'Flutter Demo',
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData(
//             colorScheme: ColorScheme.fromSeed(
//                 seedColor: Colors.black, background: Colours.Backgorund_white),
//             useMaterial3: true,
//           ),
//           initialRoute: RouteGenerator.rt_splash,
//           onGenerateRoute: RouteGenerator.generateRoute,
//           // home: HomePage(),
//           // home: ChatScreen(
//           //   userId: 1,
//           //   receiverId: 2,
//           // ),
//         );
//       },
//     );
//   }
// }

import 'dart:async';

import 'package:awesome_book/Route/router.dart';
import 'package:awesome_book/core/errrors/error_reporter.dart';
import 'package:awesome_book/utils/colours.dart';
import 'package:awesome_book/utils/sharedPrefs.dart';
import 'package:camera/camera.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadUserFromPrefs();

  // ✅ Initialize AdMob SDK
  await MobileAds.instance.initialize();

  // ✅ Register this phone as test device (from logcat)
  final config = RequestConfiguration(
    testDeviceIds: ["2DEB5FE6EE761CD0925C193DD00624B3"],
  );
  MobileAds.instance.updateRequestConfiguration(config);

  // ✅ Setup Camera
  _cameras = await availableCameras();

  // ✅ Setup Email OTP
  EmailOTP.config(
    appName: 'Awesome book',
    otpType: OTPType.numeric,
    expiry: 30000,
    emailTheme: EmailTheme.v6,
    appEmail: 'ateeque.crawlerstechnologies@gmail.com',
    otpLength: 6,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    ErrorReporter.report(details.exception, details.stack);
  };

  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stackTrace) => ErrorReporter.report(error, stackTrace),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
              background: Colours.Backgorund_white,
            ),
            useMaterial3: true,
          ),
          initialRoute: RouteGenerator.rt_splash,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
