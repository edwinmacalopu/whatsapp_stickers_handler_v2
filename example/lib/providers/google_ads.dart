import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAds with ChangeNotifier {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  BannerAd? loadBannerAd(List<String>? keywords) {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(
        keywords: keywords,
      ),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          if (kDebugMode) print('Ad loaded.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          if (kDebugMode) print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {
          if (kDebugMode) print('Ad opened.');
        },
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          if (kDebugMode) print('Ad closed.');
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {
          if (kDebugMode) print('Ad impression.');
        },
      ),
    );
    return _bannerAd;
  }

  BannerAd? bannerAd() {
    return _bannerAd;
  }

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  InterstitialAd? interstitialAd() {
    return _interstitialAd;
  }
}
