import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../global_widget/app_bar.dart';
import '../global_widget/text_filed.dart';
import '../provider/edit_word.dart';

final editList = ChangeNotifierProvider((ref) => EditListWord());

class EditWordPage extends ConsumerStatefulWidget {
  final int? listID;
  final String? listName;
  const EditWordPage(this.listID, this.listName, {Key? key}) : super(key: key);

  @override
  ConsumerState<EditWordPage> createState() =>
      _EditWordPageState(listID: listID, listName: listName);
}

class _EditWordPageState extends ConsumerState<EditWordPage> {
  int? listID;
  String? listName;
  _EditWordPageState({@required this.listID, @required this.listName});

  @override
  void initState() {
    super.initState();
    ref.read<EditListWord>(editList).getWordByList(listID);
  }

  @override
  Widget build(BuildContext context) {
    final editListProvider = ref.watch<EditListWord>(editList);
    return Scaffold(
      backgroundColor: const Color(0xff3574C3),
      appBar: appbar(context,
          left: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xffF3FBF8),
            size: 22,
          ),
          center: Text(
            listName!,
            style: const TextStyle(
                color: Color(0xffF3FBF8), fontSize: 20, fontWeight: FontWeight.w600),
          ),
          leftWidgetOnClik: () => {Navigator.pop(context), editListProvider.close()}),
      body: Column(
        children: [
          SizedBox(
            height: 70,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: editListProvider.editController == false
                  ? Row(children: [
                      InkWell(
                        onTap: () {
                          editListProvider.editchange();
                        },
                        child: card(
                            icon: Icons.create_outlined,
                            iconColor: 0xffF2C94C,
                            cardColor: 0xffF3FBF8),
                      ),
                    ])
                  : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        alignment: Alignment.centerLeft,
                        child: Row(children: [
                          card(
                              icon: Icons.create_outlined,
                              iconColor: 0xff828282,
                              cardColor: 0xffE0E0E0),
                          InkWell(
                            onTap: () {
                              editListProvider.editchange();
                              for (int i = 0;
                                  i < editListProvider.selectIndexList.length;
                                  i++) {
                                editListProvider.selectIndexList[i] = false;
                              }

                              editListProvider.selectIndexList;
                            },
                            child: card(
                                icon: Icons.close,
                                iconColor: 0xff4F4F4F,
                                cardColor: 0xffF3FBF8),
                          ),
                          InkWell(
                            onTap: () {
                              editListProvider.addRow(listID);
                            },
                            child: card(
                                icon: Icons.add_circle_outline,
                                iconColor: 0xff6FCF97,
                                cardColor: 0xffF3FBF8),
                          ),
                        ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            editListProvider.save(listID);
                          },
                          child: card(
                              icon: Icons.save_rounded,
                              iconColor: 0xff6FCF97,
                              cardColor: 0xffF3FBF8),
                        ),
                      ),
                    ]),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Color(0xff002250),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: Column(children: [
                if (editListProvider.editController == true)
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 70,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "Seçilen Kelimeleri...",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            editingButton(
                                text: "Öğren", width: 71, click: editListProvider.learn),
                            editingButton(
                                text: "Unut", width: 64, click: editListProvider.unlearn),
                            editingButton(
                                text: "Sil", width: 48, click: editListProvider.delete),
                          ],
                        )
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xffF3FBF8),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.only(right: 30),
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Color(0xffF3FBF8),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
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
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: const Color(0xffF3FBF8),
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                                return list(index,
                                    wordTr: editListProvider.wordlist[index].word_tr,
                                    wordEng: editListProvider.wordlist[index].word_eng,
                                    learn: editListProvider.wordlist[index].status);
                              },
                              itemCount: editListProvider.wordlist.length),
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Row list(
    int index, {
    @required String? wordTr,
    @required String? wordEng,
    @required bool? learn,
  }) {
    final editListProvider = ref.watch<EditListWord>(editList);
    editListProvider.wordTextEditingList[2 * index + 1].text = wordTr!;
    editListProvider.wordTextEditingList[2 * index].text = wordEng!;

    return Row(
      children: [
        Expanded(
            child: textFieldBuilder(
                borderColor: learn!
                    ? const Color.fromARGB(255, 102, 210, 147)
                    : const Color(0xff3574C3),
                editting: editListProvider.editController,
                padding: const EdgeInsets.only(left: 4),
                textEditingController: editListProvider.wordTextEditingList[2 * index])),
        Expanded(
            child: textFieldBuilder(
                borderColor: learn
                    ? const Color.fromARGB(255, 102, 210, 147)
                    : const Color(0xff3574C3),
                editting: editListProvider.editController,
                padding: const EdgeInsets.only(right: 4),
                textEditingController:
                    editListProvider.wordTextEditingList[2 * index + 1])),
        editListProvider.editController
            ? Container(
                padding: const EdgeInsets.only(top: 10),
                margin: const EdgeInsets.only(
                  right: 10,
                ),
                width: 20,
                height: 30,
                child: Checkbox(
                  side: const BorderSide(color: Colors.black),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  checkColor: Colors.white,
                  activeColor: const Color(0xff3574C3),
                  hoverColor: Colors.blueAccent,
                  value: editListProvider.selectIndexList[index],
                  onChanged: (bool? value) {
                    editListProvider.selectIndexEdit(index);
                  },
                ),
              )
            : Container(),
      ],
    );
  }

  Container card({IconData? icon, @required int? iconColor, @required int? cardColor}) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(cardColor!),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      width: 38,
      height: 38,
      child: Icon(
        icon,
        color: Color(iconColor!),
        size: 32,
      ),
    );
  }

  InkWell editingButton(
      {@required Function()? click, @required String? text, @required double? width}) {
    return InkWell(
      onTap: () => click!(),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        alignment: Alignment.center,
        width: width,
        height: 38,
        decoration: const BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          text!,
          style: const TextStyle(
              color: Color(0xff4F4F4F), fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}




