import 'package:english/global_widget/app_bar.dart';
import 'package:english/pages/list.dart';
import 'package:english/pages/multiple_choice.dart';
import 'package:english/pages/words_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  String version = "";
  void packageInfoInit() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo!.version;
    });
  }
  //IOS Ad mob : ca-app-pub-8345811531238514/8104574622
  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: 'ca-app-pub-8345811531238514/8104574622',
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

  @override
  void initState() {
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
      drawer: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          color: Colors.white,
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 80,
                ),
                const Text(
                  "İstediğini Öğren",
                  style: TextStyle(fontFamily: "Carter", fontSize: 16),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: const Divider(
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, right: 8, left: 8),
                  child: const Text(
                    "Bu uygulama 2022 yılında Furkan ATAMAN tarafından ingilizce kelime öğrenmek isteyenler için geliştirildi.",
                    style: TextStyle(fontFamily: "RobotoLight", fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                /*InkWell(
                  onTap: () {},
                  child: const Text(
                    "Tıkla",
                    style: TextStyle(
                        fontFamily: "RobotoLight", fontSize: 16, color: Color(0xff0A588D)),
                  ),
                )*/
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("v$version\nfurknataman@gmail.com",
                  style: const TextStyle(
                      fontFamily: "RobotoLight", fontSize: 12, color: Color(0xff0A588D)),
                  textAlign: TextAlign.center),
            ),
          ]),
        ),
      ),
      appBar: appbar(context,
          left: const FaIcon(
            FontAwesomeIcons.bars,
            color: Colors.black,
            size: 24,
          ),
          center: const Text(
            "VOCAPP",
            style: TextStyle(
                fontFamily: "mainn",
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w700),
          ),
          leftWidgetOnClik: () => {_scaffoldKey.currentState!.openDrawer()}),
      body: SafeArea(
        child: Container(
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
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
                            MaterialPageRoute(builder: (context) => const ListPage()));
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
                        child: const Text("LİSTELERİM",
                            style: TextStyle(
                                fontSize: 28,
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
                                      builder: (context) => const WordCardspage()));
                            },
                            child: card(
                              context,
                              title: "Kelime Kartlarım",
                              startColor: 0xff01dacc9,
                              endColor: 0xff0c33b2,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MultipleChoicePage()));
                            },
                            child: card(
                              context,
                              startColor: 0xffff3384,
                              endColor: 0xffb029b9,
                              title: "Çoktan\n Seçmeli",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                adContainer!
              ],
            ))),
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
                fontSize: 28,
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
