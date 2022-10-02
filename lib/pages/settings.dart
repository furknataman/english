import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
        left: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 22,
        ),
        right: const Icon(Icons.settings, size: 40, color: Colors.black),
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
      body: SafeArea(child: const Text("data")),
    );
  }
}
