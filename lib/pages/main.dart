import 'package:english/global_widget/app_bar.dart';
import 'package:english/pages/about.dart';
import 'package:english/pages/list.dart';
import 'package:english/pages/multiple_choice.dart';
import 'package:english/pages/settings.dart';
import 'package:english/pages/words_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../db/db/db.dart';
import '../db/db/sharedPreferences.dart';
import '../global_variable.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PackageInfo? packageInfo;
  void packageInfoInit() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo!.version;
    });
  }

  //example ad mob: ca-app-pub-3940256099942544/6300978111
  //IOS Ad mob : ca-app-pub-8345811531238514/8104574622
  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    sizes: [AdSize.banner],
    request: AdManagerAdRequest(),
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

  Container? adContainer;
  int? totalWord;
  int? learnedWord;
  void getCount() async {
    totalWord = await DB.instance.getCount();
    learnedWord = await DB.instance.getLearnCount();
    setState(() {
      totalWord;
      learnedWord;
    });
  }


  @override
  void initState() {
    getCount();
    super.initState();
    MobileAds.instance.initialize();
    packageInfoInit();
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    adContainer = Container(
      alignment: Alignment.center,
      width: 320,
      height: 100,
      child: adWidget,
    );
    setState(() {
      adContainer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appbar(context,
          left:  const InkWell(
            child: FaIcon(
              FontAwesomeIcons.circleInfo,
              color: Colors.black,
              size: 24,
            ),
          ),
          center: const Text(
            "VOCAPP",
            style: TextStyle(
                fontFamily: "mainn",
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w700),
          ),
          right: const FaIcon(
            FontAwesomeIcons.circleHalfStroke,
            color: Colors.black,
            size: 24,
          ),
          leftWidgetOnClik: (() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const AbaoutPage()));
                  }),),
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                /*Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Color(0xff7D20A6),
                            Color(0xff481183),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Text(
                        "Toplam Kelime: $totalWord Öğrenilen Kelime: $learnedWord",
                        style: const TextStyle(
                            fontSize: 26,
                            fontFamily: "Arial",
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),*/
                langRadioButton(
                    text: "İngilizce-Türkçe", group: chooeseLang, value: Lang.eng),
                langRadioButton(
                    text: "Türkçe-İngilizce", group: chooeseLang, value: Lang.tr),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: (() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ListPage())).then((value) => { getCount()});
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Color(0xff7D20A6),
                            Color(0xff481183),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: const Text("Kelimelerim",
                        style: TextStyle(
                            fontSize: 26,
                            fontFamily: "Arial",
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WordCardspage())).then((value) => getCount());
                        },
                        child: card(
                          context,
                          title: "Kartlarım",
                          startColor: 0xff01dacc9,
                          endColor: 0xff0c33b2,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MultipleChoicePage())).then((value) => getCount());
                        },
                        child: card(
                          context,
                          startColor: 0xffff3384,
                          endColor: 0xffb029b9,
                          title: "Test",
                        ),
                      ),
                    ],
                  ),
                ),
               /* Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Color(0xff7D20A6),
                            Color(0xff481183),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: const Text("Ayarlar",
                        style: TextStyle(
                            fontSize: 26,
                            fontFamily: "Arial",
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),*/
                
              ],
            ),
            adContainer!
          ],
        )),
      ),
    );
  }

  Container card(BuildContext context,
      {@required int? startColor, @required int? endColor, @required String? title}) {
    return Container(
      alignment: Alignment.center,
      height: 200,
      width: MediaQuery.of(context).size.width * 0.37,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(startColor!),
              Color(endColor!),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title!,
            style: const TextStyle(
                fontSize: 24,
                fontFamily: "Arial",
                fontWeight: FontWeight.bold,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  SizedBox langRadioButton(
      {@required String? text, @required Lang? value, @required Lang? group}) {
    return SizedBox(
      width: 250,
      height: 30,
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          text!,
          style: const TextStyle(
              fontFamily: "Arial", fontWeight: FontWeight.bold, fontSize: 19),
        ),
        leading: Radio<Lang>(
            value: value!,
            groupValue: chooeseLang,
            onChanged: (Lang? value) {
              setState(() {
                chooeseLang = value;
              });

              //True TR to ING
              //Flase ING to TR
              if (value == Lang.eng) {
                SP.write("lang", true);
              } else {
                SP.write("lang", false);
              }
            }),
      ),
    );
  }
}
