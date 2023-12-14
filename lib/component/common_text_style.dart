import 'package:flutter/material.dart';

class CommonTextStyle {
  static TextStyle defaultTextStyle({double size = 16}) {
    return TextStyle(
      fontSize: size,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle defaultBoldTextStyle({double size = 16}) {
    return TextStyle(
      fontSize: size,
      color: Colors.black,
      fontWeight: FontWeight.w900,
    );
  }
}