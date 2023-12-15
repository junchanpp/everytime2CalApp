import 'package:everytime_to_calendar/page/process_page.dart';
import 'package:flutter/material.dart';

import '../Component/common_text_field.dart';
import '../Component/common_text_style.dart';
import '../component/introduction_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String everyTimeUrl="";

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
            IntroductionContainer.introductionContainer(),
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
                  height: 70,
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: TextField(
                      maxLines: 1,
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
}
