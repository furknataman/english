import 'package:english/global_widget/alert_dialog.dart';
import 'package:english/global_widget/app_bar.dart';
import 'package:english/pages/addlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';
import '../db/db/db.dart';
import '../global_variable.dart';
import '../global_widget/toast_message.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'edit_word.dart';

final getListWord = ChangeNotifierProvider((ref) => ListWord());

final editProvider = ChangeNotifierProvider((ref) => EditController());

class ListPage extends ConsumerStatefulWidget {
  const ListPage({super.key});

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final editController = ref.watch<EditController>(editProvider);
    final wordList = ref.watch<ListWord>(getListWord);
    wordList.getLists();
    return Scaffold(
      appBar: appbar(context,
          left: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xffF3FBF8),
            size: 22,
          ),
          center: const Text(
            "Listelerim",
            style: TextStyle(
                color: Color(0xffF3FBF8), fontSize: 22, fontWeight: FontWeight.w600),
          ),
          right: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: svgLogoIcon,
          ),
          leftWidgetOnClik: () => {Navigator.pop(context)}),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff3574C3),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: !editController.value
                    ? Row(children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => const AddList())));
                          },
                          child: card(
                              icon: Icons.add_circle_outline,
                              iconColor: 0xff6FCF97,
                              cardColor: 0xffF3FBF8),
                        ),
                        InkWell(
                          onTap: () {
                            editController.editchange();
                          },
                          child: card(
                              icon: Icons.create_outlined,
                              iconColor: 0xffF2C94C,
                              cardColor: 0xffF3FBF8),
                        ),
                      ])
                    : Row(children: [
                        InkWell(
                          onTap: () {},
                          child: card(
                              icon: Icons.add_circle_outline,
                              iconColor: 0xff6FCF97,
                              cardColor: 0xffF3FBF8),
                        ),
                        card(
                            icon: Icons.create_outlined,
                            iconColor: 0xff828282,
                            cardColor: 0xffE0E0E0),
                        InkWell(
                          onTap: () {
                            editController.editchange();
                          },
                          child: card(
                              icon: Icons.close,
                              iconColor: 0xff4F4F4F,
                              cardColor: 0xffF3FBF8),
                        ),
                        InkWell(
                          onTap: () {
                            alertDialog(context, () => Navigator.pop(context), () {
                              wordList.delete();
                              editController.editchange();
                              Navigator.pop(context);
                            }, "Dikakt!", "Seçili listeler silinecek");
                          },
                          child: card(
                              icon: Icons.delete_outlined,
                              iconColor: 0xffEB5757,
                              cardColor: 0xffF3FBF8),
                        ),
                      ]),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xffF3FBF8),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    context;
                    return listItem(wordList._lists[index]['list_id'] as int, index,
                        listname: wordList._lists[index]['name'].toString(),
                        sumWords: wordList._lists[index]['sum_word'].toString(),
                        sumUnloearned: wordList._lists[index]['sum_unlearned'].toString());
                  },
                  itemCount: wordList._lists.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell listItem(int id, int index,
      {@required String? listname,
      @required String? sumWords,
      @required String? sumUnloearned}) {
    final editController = ref.watch<EditController>(editProvider);
    final wordList = ref.watch<ListWord>(getListWord);
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditWordPage(id, listname)));
      },
      child: Container(
        width: 370,
        height: 75,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            )),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    margin: const EdgeInsets.only(top: 12, bottom: 12, left: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xff3574C3),
                          width: 4.0,
                        )),
                    child: PieChart(
                      colorList: const [
                        Color(0xff3574C3),
                      ],
                      dataMap: {
                        "Learn": double.parse(sumWords!) - double.parse(sumUnloearned!),
                      },
                      ringStrokeWidth: 1,
                      chartLegendSpacing: 90,
                      initialAngleInDegree: 270,
                      animationDuration: const Duration(milliseconds: 1600),
                      chartRadius: MediaQuery.of(context).size.width / 11.2,
                      chartType: ChartType.disc,
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValues: false,
                        showChartValuesOutside: false,
                        showChartValueBackground: false,
                      ),
                      legendOptions: const LegendOptions(
                          showLegends: false,
                          showLegendsInRow: false,
                          legendShape: BoxShape.rectangle),
                      totalValue: double.parse(sumWords),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          listname!,
                          style: const TextStyle(
                            color: Color(0xff4F4F4F),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 5),
                            child: const FaIcon(
                              FontAwesomeIcons.grip,
                              color: Color(0xff3574C3),
                              size: 15,
                            ),
                          ),
                          Text(
                            "$sumWords ",
                            style: const TextStyle(
                                color: Color(0xff828282),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 5),
                            child: const FaIcon(
                              FontAwesomeIcons.circleCheck,
                              color: Color(0xff3574C3),
                              size: 15,
                            ),
                          ),
                          Text(
                            "${int.parse(sumWords) - int.parse(sumUnloearned)} ",
                            style: const TextStyle(
                                color: Color(0xff828282),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              editController.value
                  ? Checkbox(
                      side: const BorderSide(color: Color(0xff3574C3)),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      checkColor: Colors.white,
                      activeColor: const Color(0xff3574C3),
                      hoverColor: Colors.blueAccent,
                      value: wordList.deleteIndexList[index],
                      onChanged: (bool? value) {
                        wordList.deleteIndexList[index] = value!;
                        bool deleteProcessController = false;
                        for (var element in wordList.deleteIndexList) {
                          if (element == true) deleteProcessController = true;
                        }
                        if (!deleteProcessController) {
                          editController._editCont = false;
                        }
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xff3574C3),
                        size: 22,
                      ),
                    ),
            ]),
      ),
    );
  }

  Container card(
      {@required IconData? icon, @required int? iconColor, @required int? cardColor}) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
      ),
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
}

class EditController extends ChangeNotifier {
  bool _editCont = false;
  bool get value => _editCont;

  void editchange() {
    if (_editCont) {
      _editCont = false;
    } else {
      _editCont = true;
    }
    notifyListeners();
  }
}

class ListWord extends ChangeNotifier {
  List<Map<String, Object?>> _lists = [];
  List<bool> deleteIndexList = [];

  void getLists() async {
    _lists = await DB.instance.readListAll();
    for (int i = 0; i < _lists.length; i++) {
      deleteIndexList.add(false);
      notifyListeners();
    }
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

    toastMessage("Seçili listeler silindi.");
  }
}
