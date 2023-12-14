import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Component/common_text_style.dart';

class DateTimePicker {
  static String parseDateToStr(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
  static Container datePicker(BuildContext context, String date, String placeHolder, Function(String) onSubmitted) {
    return Container(
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
            initialDate: date == ""
                ? DateTime.now()
                : DateTime.parse(date),
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101),
          );
          if (picked != null) {
            onSubmitted(parseDateToStr(picked));
          }
        },
        child: Text(
          date == "" ? placeHolder : date,
          style: CommonTextStyle.defaultTextStyle(),
        ),
      ),
    );
  }
}