import 'dart:io';
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