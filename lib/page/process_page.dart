import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;

import '../Component/common_text_style.dart';
import '../Component/date_time_picker.dart';
import '../component/introduction_container.dart';

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
                IntroductionContainer.introductionContainer(),
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

    try{
      String icalString = await getIcsFromEveryTime();

      var result = await syncronizeWithNaverCalendar(icalString);

      if(!context.mounted) return;
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("성공"),
          content: const Text("네이버 캘린더에 성공적으로 추가되었습니다."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("확인"))
          ],
        );
      }
    } catch(e) {
      if(!context.mounted) return;

      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("에러"),
          content: const Text("에브리 타임 id가 존재하지 않거나, 비공개인 시간표입니다."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("확인"))
          ],
        );
      });
    }


    setState(() {
      isLoading = false;
    });
  }

  Future<String> getIcsFromEveryTime() async {
    const String everyTimeParseUrl =
        "https://hp19ylqy1a.execute-api.ap-northeast-2.amazonaws.com/default/getIcsFromEveryTime";
    final String everyTimeKey = widget.everyTimeUrl.split("@")[1];
    final String everyTimeUrl = "$everyTimeParseUrl?id=$everyTimeKey&begin=$beginDate&end=$endDate";

    final everyTimeResult = await http.get(Uri.parse(everyTimeUrl),
        headers: {"Content-Type": "application/json;charset=UTF-8"});
    return utf8.decode(everyTimeResult.bodyBytes);

  }


  Future<bool> syncronizeWithNaverCalendar(String icalString) async {

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
    return true;
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
                          DateTimePicker.datePicker(
                              context, beginDate, '개강 날짜', (String date) {
                            setState(() {
                              beginDate = date;
                            });
                          }),
                          DateTimePicker.datePicker(
                              context, endDate, '종강 날짜', (String date) {
                            setState(() {
                              endDate = date;
                            });
                          }),
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
                      '네이버 캘린더에 추가하기',
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
