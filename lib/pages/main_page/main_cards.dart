import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

InkWell card(
    BuildContext context, {
    @required String? text,
    @required String? icon,
    @required Widget? page,
    @required bool? cardInfo,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page!));
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
                color:
                    cardInfo != true ? const Color(0xffFFFFFF) : const Color(0xff3574C3),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Padding(
                  padding: cardInfo == true
                      ? const EdgeInsets.only(top: 0, left: 0, right: 0)
                      : const EdgeInsets.only(top: 3, left: 3, right: 3),
                  child: Container(
                    alignment: Alignment.center,
                    height: 90,
                    decoration: BoxDecoration(
                        color: cardInfo != true
                            ? const Color(0xff3574C3)
                            : const Color(0xffFFFFFF),
                        borderRadius: cardInfo == false
                            ? const BorderRadius.all(Radius.circular(5))
                            : const BorderRadius.all(Radius.circular(0))),
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          icon!,
                          width: 40,
                          height: 40,
                          colorFilter: ColorFilter.mode(
                            cardInfo != true
                                ? const Color(0xffFFFFFF)
                                : const Color(0xff3574C3),
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(text!,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: cardInfo != true
                              ? const Color(0xff3574C3)
                              : const Color(0xffFFFFFF))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }