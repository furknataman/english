import 'package:flutter/material.dart';

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
              child: Image.asset("assets/images/logo_text.png")),
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
            )
          ]),
        ),
      ),
    );
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
