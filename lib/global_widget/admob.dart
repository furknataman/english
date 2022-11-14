import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
   String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8345811531238514/9950718730';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8345811531238514/3942353745';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

final AdManagerBannerAd myBanner = AdManagerBannerAd(
  adUnitId: interstitialAdUnitId,
  sizes: [AdSize.largeBanner],
  request: const AdManagerAdRequest(),
  listener: AdManagerBannerAdListener(),
);

final AdManagerBannerAdListener listener = AdManagerBannerAdListener(
  onAdLoaded: (Ad ad) => print('Ad loaded.'),
  onAdFailedToLoad: (Ad ad, LoadAdError error) {
    ad.dispose();
    print('Ad failed to load: $error');
  },
  onAdOpened: (Ad ad) => print('Ad opened.'),
  onAdClosed: (Ad ad) => print('Ad closed.'),
  onAdImpression: (Ad ad) => print('Ad impression.'),
);