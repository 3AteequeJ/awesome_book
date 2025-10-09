import 'package:flutter/foundation.dart';

class ErrorReporter {
  static void report(dynamic error, [StackTrace? stackTrace]) {
    debugPrint("🔥 GLOBAL ERROR: $error");
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }

    // ✅ Later: integrate Firebase Crashlytics or Sentry here
  }
}
