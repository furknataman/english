import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

enum Lang { eng, tr }

class _MainPageState extends State<MainPage> {
  Lang? _chooeseLang = Lang.eng;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Icon(
                Icons.drag_handle,
                size: 40,
                color: Colors.black,
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
                    tittleWidget: Text("Türkçe"), group: _chooeseLang, value: Lang.tr),
                langRadioButton(
                    tittleWidget: Text("İngilizce"), group: _chooeseLang, value: Lang.eng),
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
                          fontSize: 24, fontFamily: "Carter", color: Colors.white)),
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
            style: TextStyle(fontSize: 24, fontFamily: "Carter", color: Colors.white),
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
      {@required Widget? tittleWidget, @required Lang? value, @required Lang? group}) {
    return SizedBox(
      width: 150,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: tittleWidget,
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
