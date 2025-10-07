// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdMobNativeAdWidget extends StatefulWidget {
//   const AdMobNativeAdWidget({Key? key}) : super(key: key);

//   @override
//   State<AdMobNativeAdWidget> createState() => _AdMobNativeAdWidgetState();
// }

// class _AdMobNativeAdWidgetState extends State<AdMobNativeAdWidget> {
//   NativeAd? _nativeAd;
//   bool _isAdLoaded = false;

//   // ✅ Use Google’s official TEST Native Ad Unit
//   static const String _adUnitId = "ca-app-pub-3940256099942544/2247696110";

//   @override
//   void initState() {
//     super.initState();
//     _loadAd();
//   }

//   void _loadAd() {
//     _nativeAd = NativeAd(
//       adUnitId: _adUnitId,
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           print("✅ Native Ad loaded");
//           setState(() => _isAdLoaded = true);
//         },
//         onAdFailedToLoad: (ad, error) {
//           print("❌ Failed to load Native Ad: $error");
//           ad.dispose();
//         },
//       ),
//       nativeTemplateStyle: NativeTemplateStyle(
//         templateType: TemplateType.medium,
//       ),
//     );

//     // 🚀 THIS WAS MISSING
//     _nativeAd!.load();
//   }

//   @override
//   void dispose() {
//     _nativeAd?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(8),
//       child: _isAdLoaded && _nativeAd != null
//           ? SizedBox(height: 200, child: AdWidget(ad: _nativeAd!))
//           : const SizedBox(
//               height: 200,
//               child: Center(child: CircularProgressIndicator()),
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobNativeAdWidget extends StatefulWidget {
  const AdMobNativeAdWidget({Key? key}) : super(key: key);

  @override
  State<AdMobNativeAdWidget> createState() => _AdMobNativeAdWidgetState();
}

class _AdMobNativeAdWidgetState extends State<AdMobNativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  // ✅ Google’s official TEST Native Ad Unit ID
  static const String _testAdUnitId = "ca-app-pub-3940256099942544/2247696110";

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: _testAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Native Ad loaded successfully");
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("❌ Failed to load Native Ad: $error");
          ad.dispose();
          setState(() {
            _isAdLoaded = false;
          });
        },
      ),
      // 👇 Use Google’s built-in medium template
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white,
        cornerRadius: 12.0,
      ),
    );

    _nativeAd!.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: _isAdLoaded && _nativeAd != null
          ? SizedBox(
              height: 250,
              child: AdWidget(ad: _nativeAd!),
            )
          : const SizedBox(
              height: 250,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
