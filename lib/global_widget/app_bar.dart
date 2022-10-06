import 'package:flutter/material.dart';

PreferredSize appbar(context,
    {@required Widget? left,
    @required Widget? center,
    Widget? right,
    Function? leftWidgetOnClik}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xff00b2ca),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.2,
            child: InkWell(
              onTap: () => leftWidgetOnClik!(),
              child: left,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.5,
            child: center,
          ),
          Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width * 0.2,
            child: right,
          ),
        ],
      ),
    ),
  );
}
