package com.example.awesome_book

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        try {
            // ✅ Safely add plugin if missing
            flutterEngine.plugins.add(GoogleMobileAdsPlugin())

            // ✅ Register Native Ad Factory safely
            GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine,
                "listTile", // must match Dart's factoryId
                ListTileNativeAdFactory(context)
            )

            println("✅ Native Ad Factory registered successfully!")
        } catch (e: Exception) {
            println("⚠️ Failed to register Native Ad Factory: ${e.message}")
        }
    }
}
