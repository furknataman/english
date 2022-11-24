import 'package:flutter/material.dart';

void alertDialog(BuildContext context, Function functionLeft, Function functionRight,
    String titleText, String bodyText) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Container(
          height: 233,
          decoration: const BoxDecoration(
              color: Color(0xffF3FBF8),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.25,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                    child: Container(
                      height: 5.0,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2.5)),
                          color: Color(0xff828282)),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(titleText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Color(0xff828282))),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(bodyText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xff4F4F4F))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: const Color(0xffE0E0E0),
                      onPressed: () {
                        functionLeft();
                      },
                      label: const Text(
                        "İptal ",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Color(0xff4F4F4F)),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: const Color(0xffEB5757),
                      onPressed: () {
                        functionRight();
                      },
                      label: const Text(
                        "Onayla",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      });
}
