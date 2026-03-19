import 'package:flutter/material.dart';

import '../core/app_icons.dart';
import '../global_widget/app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(
        context,
        left: AppIcons.svg(AppIcons.arrowLeft, size: 22, color: Colors.black),
        right: AppIcons.svg(AppIcons.gear, size: 40, color: Colors.black),
        center: const Text(
          "Ayarlar",
          style: TextStyle(
              fontFamily: "Carter",
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w700),
        ),
        leftWidgetOnClik: () => Navigator.pop(context),
      ),
      body: const SafeArea(child: Text("data")),
    );
  }
}
