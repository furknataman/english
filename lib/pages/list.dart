import 'package:english/pages/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.2,
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 22,
                )),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset("assets/images/lists.png")),
          Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Image.asset(
              "assets/images/logo.png",
              height: 45,
              width: 45,
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: Colors.purple.withOpacity(0.5),
      ),
      body: SafeArea(
        child: Column(children: [
          Center(
            child: Container(
              width: double.infinity,
              child: Card(
                color: Color(0xffDCD2FF),
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 5),
                      child: Text(
                        "Liste Adı",
                        style: TextStyle(
                            color: Colors.black, fontSize: 16, fontFamily: "RobotoMedium"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        "305 Terim",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "RobotoRegular"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        "5 Öğrenildi",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "RobotoRegular"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, bottom: 5),
                      child: Text(
                        "3 Öğrenilmedi",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "RobotoRegular"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
