import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class TestNativeAdWidget extends StatefulWidget {
  const TestNativeAdWidget({Key? key}) : super(key: key);

  @override
  State<TestNativeAdWidget> createState() => _TestNativeAdWidgetState();
}

class _TestNativeAdWidgetState extends State<TestNativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  // ✅ Google Test Native Ad Unit ID
  static const String _testAdUnitId = "ca-app-pub-3940256099942544/2247696110";

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: _testAdUnitId,
      factoryId: 'listTile', // Must match your Kotlin factory
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Native Test Ad Loaded");
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("❌ Failed to load test ad: $error");
          ad.dispose();
        },
      ),
    );
    _nativeAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdLoaded && _nativeAd != null) {
      return SizedBox(
        height: 300,
        child: AdWidget(ad: _nativeAd!),
      );
    } else {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
