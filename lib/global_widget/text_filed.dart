import 'package:flutter/material.dart';

enum textFieldType { main, lefet, rigt }

Column textFieldBuilder(
    {int height = 40,
    EdgeInsets? padding,
    @required TextEditingController? textEditingController,
    Icon? icon,
    String? hindText,
    TextAlign textAlign = TextAlign.center}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top:10.0,left: 20,right: 20),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xff00b2ca), borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: padding!,
            child: Container(
              height: double.parse(height.toString()),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.only(left:4.0),
                child: TextField(
                  
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  textAlign: textAlign,
                  textAlignVertical: TextAlignVertical.top,
                  controller: textEditingController,
                  style: const TextStyle(
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
              ),
            ),
          ),
        ),
      )
    ],
  );
}
