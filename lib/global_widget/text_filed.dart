import 'package:flutter/material.dart';

Column textFieldBuilder(
    {int height = 40,
    Color borderColor = const Color(0xff3574C3),
    bool editting = true,
    EdgeInsets? padding,
    @required TextEditingController? textEditingController,
    Icon? icon,
    String? hindText,
    TextAlign textAlign = TextAlign.center}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15),
        child: Container(
          decoration: BoxDecoration(
              color: borderColor, borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: padding!,
            child: Container(
              height: double.parse(height.toString()),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: TextField(
                  enabled: editting,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  textAlign: textAlign,
                  textAlignVertical: TextAlignVertical.top,
                  controller: textEditingController,
                  style: const TextStyle(
                      color: Colors.black, decoration: TextDecoration.none, fontSize: 18),
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
