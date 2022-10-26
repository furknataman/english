import 'package:english/global_widget/app_bar.dart';
import 'package:english/pages/addlist.dart';
import 'package:english/pages/words.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../db/db/db.dart';
import '../global_variable.dart';
import '../global_widget/toast_message.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

bool editController = false;
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
      editController = false;
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
                child: editController == false
                    ? Row(children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => const AddList())))
                                .then((value) {
                              getLists();
                            });
                          },
                          child: card(
                              icon: Icons.add_circle_outline,
                              iconColor: 0xff6FCF97,
                              cardColor: 0xffF3FBF8),
                        ),
                        InkWell(
                          onTap: () {
                            editController = true;
                            setState(() {
                              editController;
                            });
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
                            editController = false;
                            setState(() {
                              editController;
                            });
                          },
                          child: card(
                              icon: Icons.close,
                              iconColor: 0xff4F4F4F,
                              cardColor: 0xffF3FBF8),
                        ),
                        InkWell(
                          onTap: () {
                            delete();
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
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return listItem(_lists[index]['list_id'] as int, index,
                        listname: _lists[index]['name'].toString(),
                        sumWords: _lists[index]['sum_word'].toString(),
                        sumUnloearned: _lists[index]['sum_unlearned'].toString());
                  },
                  itemCount: _lists.length,
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
    return InkWell(
      onTap: () {
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => WordsPage(id, listname)))
            .then((value) {
          getLists();
        });
      },
      onLongPress: () {
        setState(() {
          editController = true;
          deleteIndexList[index] = true;
        });
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
                            fontWeight: FontWeight.w700,
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
                                fontFamily: "RobotoRegular"),
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
                                fontFamily: "RobotoRegular"),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              editController == true
                  ? Checkbox(
                      side: const BorderSide(color: Colors.white),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      checkColor: Colors.white,
                      activeColor: const Color(0xff3574C3),
                      hoverColor: Colors.blueAccent,
                      value: deleteIndexList[index],
                   
                      onChanged: (bool? value) {
                        setState(() {
                          deleteIndexList[index] = value!;

                          bool deleteProcessController = false;
                          for (var element in deleteIndexList) {
                            if (element == true) deleteProcessController = true;
                          }
                          if (!deleteProcessController) editController = false;
                        });
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
