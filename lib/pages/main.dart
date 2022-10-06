import 'package:english/global_widget/app_bar.dart';
import 'package:english/pages/about.dart';
import 'package:english/pages/addlist.dart';
import 'package:english/pages/list.dart';
import 'package:english/pages/multiple_choice.dart';
import 'package:english/pages/settings.dart';
import 'package:english/pages/words.dart';
import 'package:english/pages/words_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
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

  bool isSwitched = false;

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
      appBar: appbar(
        context,
        left: const InkWell(
          child: FaIcon(
            FontAwesomeIcons.circleInfo,
            color: Colors.white,
            size: 24,
          ),
        ),
        center: const Text(
          "VOCAPP",
          style: TextStyle(
              fontFamily: "mainn",
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700),
        ),
        right: const FaIcon(
          FontAwesomeIcons.circleHalfStroke,
          color: Colors.white,
          size: 24,
        ),
        leftWidgetOnClik: (() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AbaoutPage()));
        }),
      ),
      body: Container(
        color: const Color(0xffF3FBF8),
        child: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    color: const Color(0xff00b2ca),
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Türkçe",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Switcher(
                          value: false,
                          size: SwitcherSize.medium,
                          switcherButtonRadius: 50,
                          enabledSwitcherButtonRotate: true,
                          iconOff: Icons.chevron_left,
                          iconOn: Icons.chevron_right,
                          switcherButtonColor: const Color(0xffF3FBF8),
                          colorOff: const Color(0xffCC3366),
                          colorOn: const Color.fromARGB(255, 83, 27, 46),
                          onChanged: (bool state) {
                            if (state == true) {
                              chooeseLang = Lang.tr;
                              SP.write("lang", false);
                            } else {
                              chooeseLang = Lang.eng;
                              SP.write("lang", true);
                            }
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "İngilizce",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        card(
                          context,
                          text: "Kelimelerim",
                          icon: FontAwesomeIcons.book,
                          page: const ListPage(),
                          iconColor: 0xffFFFFFF,
                          mainColor: 0xffFFFFFF,
                          cardColor: 0xff00b2ca,
                          textColor: 0xff00b2ca,
                          x: 3,
                          y: 3,
                          z: 3,
                        ),
                        card(
                          context,
                          text: "Kartlarım",
                          icon: FontAwesomeIcons.creditCard,
                          page: const WordCardspage(),
                          iconColor: 0xffFFFFFF,
                          mainColor: 0xffFFFFFF,
                          cardColor: 0xff00b2ca,
                          textColor: 0xff00b2ca,
                          x: 3,
                          y: 3,
                          z: 3,
                        ),
                        card(
                          context,
                          text: "Test",
                          icon: FontAwesomeIcons.clockRotateLeft,
                          page: const MultipleChoicePage(),
                          iconColor: 0xffFFFFFF,
                          mainColor: 0xffFFFFFF,
                          cardColor: 0xff00b2ca,
                          textColor: 0xff00b2ca,
                          x: 3,
                          y: 3,
                          z: 3,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: card2(
                      context,
                    ),
                  ),
                ],
              ),
              adContainer!
            ],
          )),
        ),
      ),
    );
  }

  InkWell card(
    BuildContext context, {
    @required String? text,
    @required IconData? icon,
    @required Widget? page,
    @required int? iconColor,
    @required int? mainColor,
    @required int? cardColor,
    @required int? textColor,
    @required double? x,
    @required double? y,
    @required double? z,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page!))
            .then((value) => getCount());
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
                color: Color(mainColor!),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: x!, left: y!, right: z!),
                  child: Container(
                    alignment: Alignment.center,
                    height: 90,
                    decoration: BoxDecoration(
                        color: Color(cardColor!),
                        borderRadius: const BorderRadius.all(Radius.circular(5))),
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FaIcon(
                          icon,
                          color: Color(iconColor!),
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(text!, style: TextStyle(color: Color(textColor!))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row card2(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    color: Color(0xffCC3366),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: 235,
                height: 50,
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 18),
                      width: 185,
                      height: 50,
                      child: const Text(
                        "Toplam",
                        style: TextStyle(color: Color(0xff00b2ca), fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        totalWord.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 83, 27, 46),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: 235,
              height: 50,
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 18),
                    width: 185,
                    height: 50,
                    child: const Text(
                      "Öğrenilen",
                      style: TextStyle(color: Color(0xff00b2ca), fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      learnedWord.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        card(
          context,
          text: "Liste Oluştur",
          icon: FontAwesomeIcons.add,
          page: const AddList(),
          iconColor: 0xff00b2ca,
          mainColor: 0xff00b2ca,
          cardColor: 0xffFFFFFF,
          textColor: 0xffFFFFFF,
          x: 0,
          y: 0,
          z: 0,
        )
        /*card(context,
            // ignore: deprecated_member_use
            text: "Liste Oluştur",
            icon: FontAwesomeIcons.add,
            page: const AddList())*/
      ],
    );
  }
}
