import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

import '../Component/common_text_style.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ProcessPage extends StatefulWidget {
  final String everyTimeUrl;
  final String beginDate = "";
  final String endDate = "";

  const ProcessPage({Key? key, required this.everyTimeUrl}) : super(key: key);

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(widget.everyTimeUrl),
              TextButton(onPressed: onPressed, child: const Text("네이버 캘린더에 넣기"))
            ],
          ),
        ),
      ),
    );
  }

  onPressed() async {
    const String everyTimeParseUrl = "https://hp19ylqy1a.execute-api.ap-northeast-2.amazonaws.com/default/getIcsFromEveryTime";
    //everyTimeParseUrl, @이후 파싱
    // final String everyTimeKey = widget.everyTimeUrl.split("@")[1];
    // final String everyTimeUrl = "$everyTimeParseUrl?id=$everyTimeKey&begin=${widget.beginDate}&end=${widget.endDate}";
    const String everyTimeUrl = "https://hp19ylqy1a.execute-api.ap-northeast-2.amazonaws.com/default/getIcsFromEveryTime?id=9iYT60bfIV9KxKWLzUL4&begin=2023-10-01&end=2023-10-30";
    final everyTimeResult = await http.get(Uri.parse(everyTimeUrl), headers: {"Content-Type": "application/json;charset=UTF-8"});
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
      var scheduleIcalString =
      '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:Naver Calendar
$vEvent
END:VCALENDAR
      '''
      ;
      var body = {
        "calendarId": "defaultCalendarId",
        "scheduleIcalString": scheduleIcalString
      };
      print(scheduleIcalString);

      var result = await http.post(Uri.parse(url), headers: headers, body: body);
      print(result.body);
    }
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
}
