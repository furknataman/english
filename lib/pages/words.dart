import 'package:english/global_widget/app_bar.dart';
import 'package:english/global_widget/toast_message.dart';
import 'package:english/pages/add_word.dart';
import 'package:flutter/material.dart';
import '../db/db/db.dart';
import '../db/models/words.dart';

class WordsPage extends StatefulWidget {
  final int? listID;
  final String? listName;
  const WordsPage(this.listID, this.listName, {Key? key}) : super(key: key);

  @override
  State<WordsPage> createState() => WordsPageState(listID: listID, listName: listName);
}

class WordsPageState extends State<WordsPage> {
  int? listID;
  String? listName;
  WordsPageState({@required this.listID, @required this.listName});
  List<Word> _wordlist = [];
  bool pressController = false;
  List<bool> deleteIndexList = [];
  @override
  void initState() {
    super.initState();
    getWordByList();
  }

  void getWordByList() async {
    _wordlist = await DB.instance.readWordByList(listID);
    for (int i = 0; i < _wordlist.length; i++) {
      deleteIndexList.add(false);
    }

    setState(() => _wordlist);
  }

  void delete() async {
    List<int> removeIndexLits = [];
    for (int i = 0; i < deleteIndexList.length; i++) {
      if (deleteIndexList[i] == true) {
        removeIndexLits.add(i);
      }
    }

    for (int i = removeIndexLits.length - 1; i > 0; i--) {
      DB.instance.deleteWord(_wordlist[removeIndexLits[i]].id!);
      _wordlist.removeAt(removeIndexLits[i]);
      deleteIndexList.removeAt(removeIndexLits[i]);
    }
    setState(() {
      _wordlist;
      deleteIndexList;
      pressController = false;
    });
    toastMessage("Seçili kelimeler silindi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context,
          left: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
          center: Text(
            listName!,
            style:
                const TextStyle(fontFamily: "Carter", fontSize: 22, color: Colors.black),
          ),
          right: pressController != true
              ? Image.asset(
                  "assets/images/logo.png",
                  height: 60,
                  width: 60,
                )
              : InkWell(
                  onTap: delete,
                  child: const Icon(
                    Icons.delete,
                    color: Color.fromRGBO(157, 192, 198,0.9),
                    size: 24,
                  )),
          leftWidgetOnClik: () => Navigator.pop(context)),
      body: SafeArea(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return wordItem(_wordlist[index].id!, index,
              wotdTr: _wordlist[index].word_tr,
              wordEng: _wordlist[index].word_eng,
              status: _wordlist[index].status);
        },
        itemCount: _wordlist.length,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => AddWordPage(listID, listName))))
              .then((value) {
            getWordByList();
          });
        },
        backgroundColor:const Color.fromRGBO(157, 192, 198,0.9),
        child: const Icon(Icons.add),
      ),
    );
  }

  InkWell wordItem(int wordID, int index,
      {@required String? wotdTr, @required String? wordEng, @required bool? status}) {
    return InkWell(
      onLongPress: () {
        setState(() {
          pressController = true;
          deleteIndexList[index] = true;
        });
      },
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Card(
            color: pressController != true ?  const Color.fromRGBO(157, 192, 198,0.9) : const Color(0xffE3E7E5),
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
                          wotdTr!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "RobotoMedium"),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30, bottom: 10),
                        child: Text(
                          wordEng!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "RobotoRegular"),
                        ),
                      ),
                    ],
                  ),
                  pressController != true
                      ? Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.deepOrangeAccent,
                          hoverColor: Colors.blueAccent,
                          value: status,
                          onChanged: (bool? value) {
                            _wordlist[index] = _wordlist[index].copy(status: value);
                            if (value == true) {
                              toastMessage("Öğrenildi işaretlendi");
                              DB.instance.markAslearned(true, _wordlist[index].id as int);
                            } else {
                              toastMessage("Öğrenilmedi işaretlendi");
                              DB.instance.markAslearned(false, _wordlist[index].id as int);
                            }
                            setState(() {
                              _wordlist;
                            });
                          })
                      : Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.deepOrangeAccent,
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
                ]),
          ),
        ),
      ),
    );
  }

  

}
