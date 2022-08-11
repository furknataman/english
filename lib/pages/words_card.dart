import 'package:english/global_widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../db/db/db.dart';

class WordCardspage extends StatefulWidget {
  const WordCardspage({Key? key}) : super(key: key);

  @override
  State<WordCardspage> createState() => _WordCardspageState();
}

enum Which { learn, unlearned, all }

enum forWhat { fortList, fortListMixed }

class _WordCardspageState extends State<WordCardspage> {
  Which? _chooseQuwstionType = Which.learn;
  bool listMixed = true;
  List<Map<String, Object?>> _lists = [];
  List<bool> selectedListIndex = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
  }

  void getLists() async {
    _lists = await DB.instance.readListAll();
    for (int i = 0; i < _lists.length; i++);
    selectedListIndex.add(false);
    setState(() {
      _lists;
    });
  }

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
        center: const Text(
          "Kelime Kartları",
          style: TextStyle(fontFamily: 'carter', color: Colors.black, fontSize: 22),
        ),
        leftWidgetOnClik: () => Navigator.pop(context),
      ),
      body: SafeArea(
          child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
        padding: const EdgeInsets.only(left: 4, top: 15, right: 4),
        decoration: const BoxDecoration(
            color: Color(0xffDCD2FF), borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          whichRadioButton(text: "Öğrendinlerimi sor", value: Which.learn),
          whichRadioButton(text: "Öğrenmediklerimi sor", value: Which.unlearned),
          whichRadioButton(text: "Hepsini sor", value: Which.all),
          checkBox(text: "Listeyi karıştır", fwhat: forWhat.fortListMixed),
          const SizedBox(height: 20),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text("Listeler",
                style: TextStyle(
                    fontFamily: 'RobotoRegular', fontSize: 18, color: Colors.black)),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
            height: 200,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
            child: Scrollbar(
              thickness: 5,
              isAlwaysShown: true,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return checkBox(index: index, text: _lists[index]['name'].toString());
                },
                itemCount: _lists.length,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {},
              child: Text(
                "Başla",
                style: TextStyle(
                    fontFamily: "RobotoRegular", fontSize: 18, color: Colors.black),
              ),
            ),
          )
        ]),
      )),
    );
  }

  SizedBox whichRadioButton({@required String? text, @required Which? value}) {
    return SizedBox(
      width: 275,
      height: 32,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: 'RobotoRegular', fontSize: 18),
        ),
        leading: Radio<Which>(
          value: value!,
          groupValue: _chooseQuwstionType,
          onChanged: (Which? value) {
            setState(() {
              _chooseQuwstionType = value;
            });
          },
        ),
      ),
    );
  }

  SizedBox checkBox({int index = 0, String? text, forWhat fwhat = forWhat.fortList}) {
    return SizedBox(
      width: 270,
      height: 35,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: 'RobotoRegular', fontSize: 18),
        ),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.deepPurpleAccent,
          hoverColor: Colors.blueAccent,
          value: fwhat == forWhat.fortList ? selectedListIndex[index] : listMixed,
          onChanged: (bool? value) {
            setState(() {
              if (fwhat == forWhat.fortList) {
                selectedListIndex[index] = value!;
              } else {
                listMixed = value!;
              }
            });
          },
        ),
      ),
    );
  }
}
