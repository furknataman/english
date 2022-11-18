import 'package:english/admob/admob_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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