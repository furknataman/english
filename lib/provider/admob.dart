import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//android: ca-app-pub-8345811531238514/9950718730
//example ad mob: ca-app-pub-3940256099942544/6300978111
//IOS Ad mob : ca-app-pub-8345811531238514/3942353745

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

final configAdmob = FutureProvider<Container>((ref) {
  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: interstitialAdUnitId,
    sizes: [AdSize.mediumRectangle],
    request: const AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );

  myBanner.load();
  final AdWidget adWidget = AdWidget(ad: myBanner);
  Container adContainer = Container(
    alignment: Alignment.center,
    width: 300,
    height: 250,
    child: adWidget,
  );

  return adContainer;
});
