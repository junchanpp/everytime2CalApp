import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Component/common_text_style.dart';

class IntroductionContainer{
  static Widget introductionContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E1DD),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  height: 30,
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '사용법',
                      style: CommonTextStyle.defaultBoldTextStyle(),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Text(
                      '1. everyTime -> 시간표 -> 설정 버튼 -> URL 공유하기를 누릅니다.\n이때, 공개 범위는 "전체 공개"로 설정합니다.',
                      style: CommonTextStyle.defaultTextStyle(),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Text(
                      '2. 공유받은 url을 위의 필드에 넣고, 시간표 가져오기를 누릅니다.',
                      style: CommonTextStyle.defaultTextStyle(),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Text(
                      '3. 개강날짜와 종강 날짜를 선택한 후, 적용하기를 누릅니다.',
                      style: CommonTextStyle.defaultTextStyle(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}