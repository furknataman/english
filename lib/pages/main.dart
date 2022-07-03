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
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            child: Column(
              children: [
                ListTile(
                  title: Text('Türkçe'),
                  leading: Radio<Lang>(
                      value: Lang.tr,
                      groupValue: _chooeseLang,
                      onChanged: (Lang? value) {
                        setState(() {
                          _chooeseLang = value;
                        });
                      }),
                ),
                ListTile(
                  title: Text('İngilizce'),
                  leading: Radio<Lang>(
                      value: Lang.eng,
                      groupValue: _chooeseLang,
                      onChanged: (Lang? value) {
                        setState(() {
                          _chooeseLang = value;
                        });
                      }),
                )
              ],
            )),
      ),
    );
  }
}
