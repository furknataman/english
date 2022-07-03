import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

enum Lang { eng, tr }

class _MainPageState extends State<MainPage> {
  Lang? _chooeseLang = Lang.eng;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        color: Colors.white,
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: InkWell(
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                child: FaIcon(
                  FontAwesomeIcons.bars,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset("assets/images/logo_text.png")),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
            )
          ]),
        ),
      ),
      body: SafeArea(
        child: Container(
            color: Colors.white,
            child: Center(
                child: Column(
              children: [
                langRadioButton(
                    text: "İngilizce-Türkçe", group: _chooeseLang, value: Lang.tr),
                langRadioButton(
                    text: "Türkçe-İngilizce", group: _chooeseLang, value: Lang.eng),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0xff7D20A6),
                          Color(0xff481183),
                        ],
                        tileMode: TileMode.mirror,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text("LİSTERİM",
                      style: TextStyle(
                          fontSize: 28, fontFamily: "Carter", color: Colors.white)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      card(
                        context,
                        title: "Kelime Kartlarım",
                        startColor: 0xff01dacc9,
                        endColor: 0xff0c33b2,
                      ),
                      card(context,
                          title: "Çoktan\n Seçmeli",
                          startColor: 0xffff3384,
                          endColor: 0xffb029b9)
                    ],
                  ),
                )
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
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title!,
            style: TextStyle(fontSize: 28, fontFamily: "Carter", color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Icon(
            Icons.check_circle_outline,
            size: 32,
            color: Colors.white,
          )
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
        contentPadding: EdgeInsets.all(0),
        title: Text(
          text!,
          style: TextStyle(fontFamily: "Carter", fontSize: 15),
        ),
        leading: Radio<Lang>(
            value: Lang.tr,
            groupValue: _chooeseLang,
            onChanged: (Lang? value) {
              setState(() {
                _chooeseLang = value;
              });
            }),
      ),
    );
  }
}
