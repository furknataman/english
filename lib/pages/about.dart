import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global_widget/app_bar.dart';
import '../provider/version.dart';




String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

class AbaoutPage extends ConsumerWidget {
   AbaoutPage({super.key});
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'furknataman@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'VOCAPP HK.',
    }),
  );
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    String? version = ref.watch(versionProvider).value;
    return Scaffold(
      appBar: appbar(context,
          left: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 22,
          ),
          center: const Text(
            "Hakkında",
            style: TextStyle(
              
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600),
          ),
          
          leftWidgetOnClik: () => {Navigator.pop(context)}),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 110,
                  ),
                  const Text(
                    "İstediğini Öğren",
                    style: TextStyle( fontSize: 20,fontWeight: FontWeight.w600),
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
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("v$version",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
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
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xff0A588D)),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
