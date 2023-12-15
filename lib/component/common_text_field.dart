import 'package:flutter/material.dart';

class CommonTextField {
  static InputDecoration defaultTextFieldDecoration(String labelText) {
    return InputDecoration(
      hintText: labelText,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 10.0,
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }
}
