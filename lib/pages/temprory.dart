import 'package:english/global_variable.dart';
import 'package:english/pages/main.dart';
import 'package:flutter/material.dart';

import '../db/db/sharedPreferences.dart';

class TemproryPage extends StatefulWidget {
  const TemproryPage({Key? key}) : super(key: key);

  @override
  State<TemproryPage> createState() => _TemproryPageState();
}

class _TemproryPageState extends State<TemproryPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    });

    SPRead();
  }

  void SPRead() async {
    if (await SP.read('lang') == true) {
      chooeseLang = Lang.eng;
    } else {
      chooeseLang = Lang.tr;
    }
    switch (await SP.read("which")) {
      case 0:
        chooseQuwstionType = Which.learned;
        break;
      case 1:
        chooseQuwstionType = Which.unlearned;
        break;
      case 2:
        chooseQuwstionType = Which.all;
        break;
    }
    if (await SP.read('mix') == false) {
      listMixed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset("assets/images/logo.png",width: 110,height: 130,),
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Learn",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: "Luck",
                          fontSize: 40),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Learn What You Want",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: "Carter",
                      fontSize: 25),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
