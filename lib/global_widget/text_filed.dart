import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25),
              borderRadius: BorderRadius.circular(4)),
          margin: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
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
        )
      ],
    );
  }
