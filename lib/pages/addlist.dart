import 'package:english/db/models/lists.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/db/db.dart';
import '../db/models/words.dart';
import '../global_widget/text_filed.dart';
import '../provider/add_list.dart';



final addListConfig = ChangeNotifierProvider((ref) => AddListProvider());

class AddList extends ConsumerStatefulWidget {
  const AddList({Key? key}) : super(key: key);

  @override
  ConsumerState<AddList> createState() => _AddListState();
}

class _AddListState extends ConsumerState<AddList> {
  @override
  void initState() {
    ref.read<AddListProvider>(addListConfig).getField();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final addList = ref.watch<AddListProvider>(addListConfig);
    return Scaffold(
      appBar: appbar(
        context,
        left: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xffF3FBF8),
          size: 22,
        ),
        center: const Text("Liste Oluştur",
            style: TextStyle(
                color: Color(0xffF3FBF8), fontSize: 22, fontWeight: FontWeight.w600)),
        leftWidgetOnClik: () => {Navigator.pop(context)},
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xffF3FBF8),
          child: Column(children: [
            textFieldBuilder(
                padding: const EdgeInsets.only(left: 4, right: 4),
                icon: const Icon(
                  Icons.list,
                  size: 18,
                ),
                hindText: "Liste Adı",
                textEditingController: addList.listName,
                textAlign: TextAlign.left),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "İngilizce",
                    style: TextStyle(
                        color: Color(0xff4F4F4F),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Türkçe",
                    style: TextStyle(
                        color: Color(0xff4F4F4F),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: addList.wordListField,
              )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                actionsbutons(addList.addRow, Icons.add, 0xffF2C94C),
                actionsbutons(addList.save, Icons.save, 0xff6FCF97),
                actionsbutons(addList.deleteRow, Icons.remove, 0xffEB5757)
              ],
            )
          ]),
        ),
      ),
    );
  }

  InkWell actionsbutons(Function() click, IconData icon, int? color) {
    return InkWell(
      onTap: () => click(),
      child: Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(color: Color(color!), shape: BoxShape.circle),
        child: Icon(
          icon,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }
}
