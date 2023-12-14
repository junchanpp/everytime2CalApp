
//const TextField(
//                               decoration: InputDecoration(
//                                 labelText: 'everyTime 시간표',
//                                 labelStyle: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 12.0,
//                                 ),
//                                 alignLabelWithHint: false,
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ),

import 'package:flutter/material.dart';

class CommonTextField {
  static InputDecoration defaultTextFieldDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 12.0,
      ),
      alignLabelWithHint: false,
      //no borderlline
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }
}