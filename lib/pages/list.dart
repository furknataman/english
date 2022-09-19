import 'package:english/global_widget/app_bar.dart';
import 'package:english/pages/addlist.dart';
import 'package:english/pages/words.dart';
import 'package:flutter/material.dart';

import '../db/db/db.dart';
import '../global_widget/toast_message.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

bool pressController = false;
List<bool> deleteIndexList = [];

class _ListPageState extends State<ListPage> {
  List<Map<String, Object?>> _lists = [];
  @override
  void initState() {
    super.initState();
    getLists();
  }

  void delete() async {
    List<int> removeIndexList = [];

    for (int i = 0; i < _lists.length; i++) {
      if (deleteIndexList[i] == true) removeIndexList.add(i);
    }
    for (int i = removeIndexList.length - 1; i >= 0; i--) {
      DB.instance.deleteListsAndWordByList(_lists[removeIndexList[i]]['list_id'] as int);
      _lists.removeAt(removeIndexList[i]);
      deleteIndexList.removeAt(removeIndexList[i]);
    }
    for (int i = 0; i < deleteIndexList.length; i++) {
      deleteIndexList[i] = false;
    }

    setState(() {
      _lists;
      deleteIndexList;
      pressController = false;
    });
    toastMessage("Seçili listeler silindi.");
  }

  void getLists() async {
    _lists = await DB.instance.readListAll();
    for (int i = 0; i < _lists.length; i++) {
      deleteIndexList.add(false);
    }
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
          center: const Text("Listelerim", style:TextStyle(fontFamily: "Carter", color: Colors.black, fontSize: 22,fontWeight:FontWeight.w700 ),),
      
          leftWidgetOnClik: () => {Navigator.pop(context)}),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => const AddList()))).then((value) {
            getLists();
          });
        },
        backgroundColor: Colors.purple.withOpacity(0.5),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return listItem(_lists[index]['list_id'] as int, index,
              listname: _lists[index]['name'].toString(),
              sumWords: _lists[index]['sum_word'].toString(),
              sumUnloearned: _lists[index]['sum_unlearned'].toString());
        },
        itemCount: _lists.length,
      )),
    );
  }

  InkWell listItem(int id, int index,
      {@required String? listname,
      @required String? sumWords,
      @required String? sumUnloearned}) {
    return InkWell(
      onTap: () {
        debugPrint(id.toString());
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => WordsPage(id, listname)))
            .then((value) {
          getLists();
        });
      },
      onLongPress: () {
        setState(() {
          pressController = true;
          deleteIndexList[index] = true;
        });
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: const Color(0xffDCD2FF),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 5),
                      child: Text(
                        listname!,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16, fontFamily: "RobotoMedium"),
                      ),
                    ),
                    Container(
                      margin:const EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        "${sumWords!} terim",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "RobotoRegular"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        "${int.parse(sumWords) - int.parse(sumUnloearned!)} öğrenildi",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "RobotoRegular"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30, bottom: 5),
                      child: Text(
                        "$sumUnloearned öğrenilmedi",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: "RobotoRegular"),
                      ),
                    )
                  ],
                ),
                pressController == true
                    ? Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.deepPurpleAccent,
                        hoverColor: Colors.blueAccent,
                        value: deleteIndexList[index],
                        onChanged: (bool? value) {
                          setState(() {
                            deleteIndexList[index] = value!;

                            bool deleteProcessController = false;
                            for (var element in deleteIndexList) {
                              if (element == true) deleteProcessController = true;
                            }
                            if (!deleteProcessController) pressController = false;
                          });
                        },
                      )
                    : Container()
              ]),
        ),
      ),
    );
  }
}
