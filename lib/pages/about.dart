import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global_variable.dart';
import '../global_widget/app_bar.dart';

class AbaoutPage extends StatefulWidget {
  const AbaoutPage({super.key});

  @override
  State<AbaoutPage> createState() => _AbaoutPageState();
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

class _AbaoutPageState extends State<AbaoutPage> {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'furknataman@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'VOCAPP HK.',
    }),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context,
          left: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 22,
          ),
          center: const Text(
            "Hakkında",
            style: TextStyle(
                fontFamily: "Carter",
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
          right: Image.asset(
            "assets/images/logo.png",
            height: 50,
            width: 50,
          ),
          leftWidgetOnClik: () => {Navigator.pop(context)}),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 110,
                ),
                const Text(
                  "İstediğini Öğren",
                  style: TextStyle(fontFamily: "Carter", fontSize: 20),
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
                    style: TextStyle(fontFamily: "RobotoLight", fontSize: 18),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text("v$version",
                      style: const TextStyle(
                          fontFamily: "RobotoLight",
                          fontSize: 14,
                          color: Color(0xff0A588D)),
                      textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: InkWell(
                    onTap: () async {
                      launchUrl(emailLaunchUri);
                    },
                    child: const Text("furknataman@gmail.com",
                        style: TextStyle(
                            fontFamily: "RobotoLight",
                            fontSize: 14,
                            color: Color(0xff0A588D)),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
