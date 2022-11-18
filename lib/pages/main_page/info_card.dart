import 'package:flutter/material.dart';

Container infoWord(String text, String wordInfo, Color color) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    width: 235,
    height: 50,
    child: Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: Colors.white,
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 18),
          width: 185,
          height: 50,
          child: Text(
            text,
            style: const TextStyle(
                color: Color(0xff3574C3), fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: (Text(
            wordInfo,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          )),
        )
      ],
    ),
  );
}
