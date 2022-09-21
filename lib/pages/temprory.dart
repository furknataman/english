import 'dart:async';
import 'package:english/global_variable.dart';
import 'package:english/pages/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../db/db/sharedPreferences.dart';

class TemproryPage extends StatefulWidget {
  const TemproryPage({Key? key}) : super(key: key);

  @override
  State<TemproryPage> createState() => _TemproryPageState();
}

class _TemproryPageState extends State<TemproryPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    });

    sPRead();
    setFiravase();
   // setMeesage();
  }


  void setFiravase() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await FirebaseMessaging.instance.getToken();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
        
    //print('fcmToken ${fcmToken}');
    //print('User granted permission ${settings.authorizationStatus}');
  }

  void sPRead() async {
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
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 140,
                    ),
                  ),
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
                padding: EdgeInsets.only(bottom: 50, left: 15, right: 15),
                child: Text(
                  " What You Want",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: "Luck",
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
