
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../admob/admob_settings.dart';



final AdManagerBannerAd myBanner = AdManagerBannerAd(
  adUnitId: interstitialAdUnitId,
  sizes: [AdSize.largeBanner],
  request: const AdManagerAdRequest(),
  listener: AdManagerBannerAdListener(),
);


