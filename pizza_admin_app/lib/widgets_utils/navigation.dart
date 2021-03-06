import 'package:flutter/material.dart';

class NavigationUitls {
  static pushReplacement(BuildContext context, Object targetClass) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return targetClass;
    }));
  }

  static push(BuildContext context, Object targetClass) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return targetClass;
    }));
  }
}
