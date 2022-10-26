import 'package:english/global_widget/app_bar.dart';
import 'package:english/pages/about.dart';
import 'package:english/pages/addlist.dart';
import 'package:english/pages/list.dart';
import 'package:english/pages/multiple_choice.dart';
import 'package:english/pages/words_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';
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
      backgroundColor: const Color(0xff3574C3),
      key: _scaffoldKey,
      appBar: appbar(
        context,
        left: svgLogoIcon,
        right: InkWell(
            onTap: () {
              Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const AbaoutPage()))
                  .then((value) => getCount());
            },
            child: const Icon(
              Icons.info_outline,
              size: 24,
              color: Color(0xffF3FBF8),
            )),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Türkçe",
                      style: TextStyle(
                          fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Switcher(
                  value: false,
                  size: SwitcherSize.medium,
                  switcherButtonRadius: 50,
                  enabledSwitcherButtonRotate: true,
                  iconOff: Icons.chevron_left,
                  iconOn: Icons.chevron_right,
                  switcherButtonColor: const Color(0xffF3FBF8),
                  colorOff: const Color.fromARGB(255, 167, 41, 83),
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
                        fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Color(0xffF3FBF8),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            card(context,
                                text: "Kelimelerim",
                                icon: FontAwesomeIcons.book,
                                page: const ListPage(),
                                cardInfo: false),
                            card(context,
                                text: "Kartlarım",
                                icon: FontAwesomeIcons.creditCard,
                                page: const WordCardspage(),
                                cardInfo: false),
                            card(
                              context,
                              text: "Test",
                              icon: FontAwesomeIcons.clockRotateLeft,
                              page: const MultipleChoicePage(),
                              cardInfo: false,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Color(0xffCC3366),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
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
                                            style: TextStyle(
                                                color: Color(0xff3574C3), fontSize: 20),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12),
                                          child: Text(
                                            totalWord.toString(),
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          ),
                                        ),
                                      ],
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
                                            style: TextStyle(
                                                color: Color(0xff3574C3), fontSize: 20),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12),
                                          child: Text(
                                            learnedWord.toString(),
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            card(
                              context,
                              text: "Liste Oluştur",
                              icon: FontAwesomeIcons.add,
                              page: const AddList(),
                              cardInfo: true,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  adContainer!
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell card(
    BuildContext context, {
    @required String? text,
    @required IconData? icon,
    @required Widget? page,
    @required bool? cardInfo,
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
                color:
                    cardInfo != true ? const Color(0xffFFFFFF) : const Color(0xff3574C3),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Padding(
                  padding: cardInfo == true
                      ? const EdgeInsets.only(top: 0, left: 0, right: 0)
                      : const EdgeInsets.only(top: 3, left: 3, right: 3),
                  child: Container(
                    alignment: Alignment.center,
                    height: 90,
                    decoration: BoxDecoration(
                        color: cardInfo != true
                            ? const Color(0xff3574C3)
                            : const Color(0xffFFFFFF),
                        borderRadius: cardInfo == false
                            ? const BorderRadius.all(Radius.circular(5))
                            : const BorderRadius.all(Radius.circular(0))),
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FaIcon(
                          icon,
                          color: cardInfo != true
                              ? const Color(0xffFFFFFF)
                              : const Color(0xff3574C3),
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(text!,
                      style: TextStyle(
                          color: cardInfo != true
                              ? const Color(0xff3574C3)
                              : const Color(0xffFFFFFF))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
