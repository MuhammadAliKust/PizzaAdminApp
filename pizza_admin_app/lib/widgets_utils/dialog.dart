import 'package:flutter/material.dart';
import 'package:pizza_admin_app/widgets_utils/alert_button.dart';

displayDialog(String message, BuildContext context, VoidCallback navigation,
    [String title = 'An Error Occured!!']) {
  return AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: <Widget>[buildAlertButton('Okay', () => navigation())],
  );
}
