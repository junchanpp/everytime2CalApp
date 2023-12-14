import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;

import '../Component/common_text_style.dart';

class ProcessPage extends StatefulWidget {
  final String everyTimeUrl;

  const ProcessPage({Key? key, required this.everyTimeUrl}) : super(key: key);

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  bool isLoading = false;
  String beginDate = "";
  String endDate = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFE0E1DD),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'EveryTime To  Calendar',
              style: CommonTextStyle.defaultBoldTextStyle(),
            ),
            centerTitle: true,
            elevation: 2,
          ),
          body: Stack(children: [
            SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                inputKeyContainer(),
                introductionContainer(),
              ],
            )),
            if (isLoading)
              const Stack(
                children: [
                  Opacity(
                    opacity: 0.3,
                    child: ModalBarrier(
                      dismissible: false,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
          ])),
    );
  }

  onPressed() async {
    setState(() {
      isLoading = true;
    });

    // await Future.delayed(const Duration(seconds: 3));
    const String everyTimeParseUrl =
        "https://hp19ylqy1a.execute-api.ap-northeast-2.amazonaws.com/default/getIcsFromEveryTime";
    //everyTimeParseUrl, @이후 파싱
    // final String everyTimeKey = widget.everyTimeUrl.split("@")[1];
    // final String everyTimeUrl = "$everyTimeParseUrl?id=$everyTimeKey&begin=${widget.beginDate}&end=${widget.endDate}";
    const String everyTimeUrl =
        "https://hp19ylqy1a.execute-api.ap-northeast-2.amazonaws.com/default/getIcsFromEveryTime?id=9iYT60bfIV9KxKWLzUL4&begin=2023-10-01&end=2023-10-30";
    final everyTimeResult = await http.get(Uri.parse(everyTimeUrl),
        headers: {"Content-Type": "application/json;charset=UTF-8"});
    String icalString = utf8.decode(everyTimeResult.bodyBytes);

    final NaverLoginResult _result = await FlutterNaverLogin.logIn();
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    String token = res.accessToken;
    String header = "Bearer " + token;
    String url = "https://openapi.naver.com/calendar/createSchedule.json";
    Map<String, String> headers = {
      "Authorization": header,
      "Content-Type": "application/x-www-form-urlencoded"
    };

    List<String> vEventBlocks = extractVEventBlocks(icalString);

    for (var vEvent in vEventBlocks) {
      var scheduleIcalString = '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:Naver Calendar
$vEvent
END:VCALENDAR
      ''';
      var body = {
        "calendarId": "defaultCalendarId",
        "scheduleIcalString": scheduleIcalString
      };

      await http.post(Uri.parse(url), headers: headers, body: body);
    }
    setState(() {
      isLoading = false;
    });
  }

  List<String> extractVEventBlocks(String icalString) {
    RegExp regex = RegExp(r'BEGIN:VEVENT(.*?)END:VEVENT', dotAll: true);
    List<RegExpMatch> matches = regex.allMatches(icalString).toList();
    List<String> veventBlocks = [];

    for (RegExpMatch match in matches) {
      veventBlocks.add(match.group(0)!);
    }

    return veventBlocks;
  }

  String parseDateToStr(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString();
    String day = date.day.toString();

    if (month.length == 1) {
      month = "0$month";
    }

    if (day.length == 1) {
      day = "0$day";
    }

    return "$year-$month-$day";
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
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                      widthFactor: 0.9,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
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
                            child: TextButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: beginDate == ""
                                      ? DateTime.now()
                                      : DateTime.parse(beginDate),
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                  setState(() {
                                    beginDate = parseDateToStr(picked);
                                  });
                                }
                              },
                              child: Text(
                                beginDate == "" ? '개강 날짜' : beginDate,
                                style: CommonTextStyle.defaultTextStyle(),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
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
                            child: TextButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: endDate == ""
                                      ? DateTime.now()
                                      : DateTime.parse(endDate),
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                  setState(() {
                                    endDate = parseDateToStr(picked);
                                  });
                                }
                              },
                              child: Text(
                                endDate == "" ? '종강 날짜' : endDate,
                                style: CommonTextStyle.defaultTextStyle(),
                              ),
                            ),
                          )
                        ],
                      )),
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
                    onPressed: onPressed,
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
