import 'package:flutter/material.dart';

showSnackBar(String text, var key) {
  return key.currentState.showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: 3),
  ));
}
