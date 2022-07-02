import 'package:flutter/material.dart';

class TemproryPage extends StatefulWidget {
  const TemproryPage({Key? key}) : super(key: key);

  @override
  _TemproryPageState createState() => _TemproryPageState();
}

class _TemproryPageState extends State<TemproryPage> {
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
                  Image.asset("assets/images/logo.png"),
                  Padding(
                    padding: const EdgeInsets.all(15),
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
              Padding(
                padding: const EdgeInsets.all(15),
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
