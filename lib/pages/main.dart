import 'package:english/db/models/info_state.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/pages/about.dart';
import 'package:english/pages/addlist.dart';
import 'package:english/pages/list.dart';
import 'package:english/pages/multiple_choice.dart';
import 'package:english/pages/words_card.dart';
import 'package:english/provider/word_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';
import '../admob/admob_main.dart';
import '../db/db/shared_preferences.dart';
import '../global_variable.dart';


class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}


class _MainPageState extends ConsumerState<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context,) {
    InfoState info = ref.watch(infoProvider);
    AsyncValue<Container> adMob = ref.watch(configAdmob);

    return Scaffold(
      backgroundColor: const Color(0xff3574C3),
      key: _scaffoldKey,
      appBar: appbar(
        context,
        left: svgLogoIcon,
        right: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>  AbaoutPage()));
            },
            child: const Icon(
              Icons.info_outline,
              size: 24,
              color: Color(0xffF3FBF8),
            )),
        leftWidgetOnClik: () {},
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
                          fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
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
                        fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                  color: Color(0xffF3FBF8),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              child: SafeArea(
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
                                  page:  const ListPage(),
                                  cardInfo: false),
                              card(context,
                                  text: "Kart Oluştur",
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
                                              "Toplam Kelime",
                                              style: TextStyle(
                                                  color: Color(0xff3574C3),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12),
                                            child: Text(
                                              info.total.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 83, 27, 46),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10)),
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
                                              "Öğrenilen Kelime",
                                              style: TextStyle(
                                                  color: Color(0xff3574C3),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12),
                                            child: (Text(
                                              info.learned.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              card(
                                context,
                                text: "Liste Oluştur",
                                icon: FontAwesomeIcons.plus,
                                page: const AddList(),
                                cardInfo: true,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    adMob.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) => Text('Error: $err'),
                      data: (adMob) {
                        return adMob;
                      },
                    )
                  ],
                ),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => page!));
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
                          fontWeight: FontWeight.w600,
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
