import 'package:english/global_widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AddList extends StatefulWidget {
  const AddList({Key? key}) : super(key: key);

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final _litName = TextEditingController();
  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; ++i) wordTextEditingList.add(TextEditingController());

    for (int i = 0; i < 5; ++i) {
      wordListField.add(Row(
        children: [
          Expanded(
              child: textFieldBuilder(textEditingController: wordTextEditingList[2 * i])),
          Expanded(
              child:
                  textFieldBuilder(textEditingController: wordTextEditingList[2 * i + 1])),
        ],
      ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(
        context,
        left: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 22,
        ),
        center: Image.asset("assets/images/logo_text.png"),
        right: Image.asset(
          "assets/images/logo.png",
          height: 45,
          width: 45,
        ),
        leftWidgetOnClik: () => {Navigator.pop(context)},
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(children: [
            textFieldBuilder(
                icon: Icon(
                  Icons.list,
                  size: 18,
                ),
                hindText: "Liste Adı",
                textEditingController: _litName,
                textAlign: TextAlign.left),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "İngilizce",
                    style: TextStyle(fontSize: 18, fontFamily: "RobotoRegular"),
                  ),
                  Text(
                    "Türkçe",
                    style: TextStyle(fontSize: 18, fontFamily: "RobotoRegular"),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: wordListField,
              )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                actionsbutons(addRow, Icons.add),
                actionsbutons(save, Icons.save),
                actionsbutons(deleteRow, Icons.remove)
              ],
            )
          ]),
        ),
      ),
    );
  }

  InkWell actionsbutons(Function() click, IconData icon) {
    return InkWell(
      onTap: () => click(),
      child: Container(
        height: 40,
        width: 40,
        margin: EdgeInsets.only(bottom: 15),
        child: Icon(
          icon,
          size: 28,
        ),
        decoration: BoxDecoration(color: Color(0xffDCD2FF), shape: BoxShape.circle),
      ),
    );
  }

  void addRow() {
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());

    wordListField.add(Row(
      children: [
        Expanded(
            child: textFieldBuilder(
                textEditingController:
                    wordTextEditingList[wordTextEditingList.length - 2])),
        Expanded(
            child: textFieldBuilder(
                textEditingController:
                    wordTextEditingList[wordTextEditingList.length - 1])),
      ],
    ));
    setState((() => wordListField));
  }

  void save() {
    for (int i = 0; i < wordTextEditingList.length / 2; i++) {
      String eng = wordTextEditingList[2 * i].text;
      String tr = wordTextEditingList[2 * i + 1].text;

      if (!eng.isEmpty || !tr.isEmpty) {
        debugPrint(eng + "<<<<<<<" + tr);
      } else {
        debugPrint("Boş bırakılan alan");
      }
    }
  }

  void deleteRow() {
    if (wordListField.length != 1) {
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);

      wordListField.removeAt(wordListField.length - 1);

      setState(() => wordListField);
    } else {
      debugPrint("Son Eleman");
    }
  }

  Column textFieldBuilder(
      {int height = 40,
      @required TextEditingController? textEditingController,
      Icon? icon,
      String? hindText,
      TextAlign textAlign = TextAlign.center}) {
    return Column(
      children: [
        Container(
          height: double.parse(height.toString()),
          padding: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25),
              borderRadius: BorderRadius.circular(4)),
          margin: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
          child: TextField(
            keyboardType: TextInputType.name,
            maxLines: 1,
            textAlign: textAlign,
            controller: textEditingController,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "RobotoMedium",
                decoration: TextDecoration.none,
                fontSize: 18),
            decoration: InputDecoration(
                icon: icon,
                border: InputBorder.none,
                hintText: hindText,
                fillColor: Colors.transparent),
          ),
        )
      ],
    );
  }
}
