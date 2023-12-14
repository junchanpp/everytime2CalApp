import 'package:everytime_to_calendar/page/process_page.dart';
import 'package:flutter/material.dart';

import '../Component/common_text_field.dart';
import '../Component/common_text_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String everyTimeUrl;

  onChanged(String url) {
    setState(() {
      everyTimeUrl = url;
    });
  }

  onSubmitted() {
    RegExp regExp = RegExp(r"^https:\/\/everytime\.kr\/@.*$");
    if (regExp.hasMatch(everyTimeUrl) == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("에러"),
              content: const Text("everyTime url을 넣어주세요."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("확인"))
              ],
            );
          });
      return;
    }

    //processPage 클래스로 이동 및 이동할 때 everyTimeUrl 전달
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProcessPage(everyTimeUrl: everyTimeUrl)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E1DD),
        automaticallyImplyLeading: false,
        title: Text(
          'EveryTime To  Calendar',
          style: CommonTextStyle.defaultBoldTextStyle(),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            inputKeyContainer(),
            introductionContainer(),
          ],
        )),
      ),
    );
  }

  //------------------------Widget------------------------
  Widget inputKeyContainer() {
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
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'everyTime 시간표를 넣어주세요.',
                      style: CommonTextStyle.defaultBoldTextStyle(),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 40,
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: TextField(
                      onChanged: onChanged,
                      obscureText: false,
                      decoration: CommonTextField.defaultTextFieldDecoration(
                          "https://everytime.kr/@.."),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFAA785D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: onSubmitted,
                    child: Text(
                      '시간표 가져오기',
                      style: CommonTextStyle.defaultBoldTextStyle(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget introductionContainer() {
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
