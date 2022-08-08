import 'package:english/global_widget/app_bar.dart';
import 'package:english/pages/addlist.dart';
import 'package:english/pages/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../db/db/db.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}


class _ListPageState extends State<ListPage> {
  List<Map<String, Object?>> _lists = [];
@override
  void initState() {
    // TOO:implement initSatate
    super.initState();
    getLists();
  }

  void getLists() async {
    _lists = await DB.instance.readListAll();
    setState(() {
      _lists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context,
          left: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 22,
          ),
          center: Image.asset("assets/images/lists.png"),
          right: Image.asset("assets/images/lists.png"),
          leftWidgetOnClik: () => {Navigator.pop(context)}),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => const AddList())));
        },
        backgroundColor: Colors.purple.withOpacity(0.5),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return listItem(_lists[index]['list_id'] as int,
              listname: _lists[index]['name'].toString(),
              sumWords: _lists[index]['sum_word'].toString(),
              sumUnloearned: _lists[index]['sum_unlearned'].toString());
        },
        itemCount: _lists.length,
      )),
    );
  }

  InkWell listItem(int id,
      {@required String? listname,
      @required String? sumWords,
      @required String? sumUnloearned}) {
    return InkWell(
      onTap: () {
        debugPrint(id.toString());
      },
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
                 listname!,
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: "RobotoMedium"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 30,
                ),
                child: Text(
                  sumWords!+" terim",
                  style: TextStyle(
                      color: Colors.black, fontSize: 14, fontFamily: "RobotoRegular"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 30,
                ),
                child: Text(
                  (int.parse(sumWords)-int.parse(sumUnloearned!)).toString()+ " öğrenildi",
                  style: TextStyle(
                      color: Colors.black, fontSize: 14, fontFamily: "RobotoRegular"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, bottom: 5),
                child: Text(
                  sumUnloearned +" öğrenilmedi",
                  style: TextStyle(
                      color: Colors.black, fontSize: 14, fontFamily: "RobotoRegular"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
