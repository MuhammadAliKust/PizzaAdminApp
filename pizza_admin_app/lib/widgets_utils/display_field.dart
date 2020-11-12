import 'package:flutter/material.dart';
import 'package:pizza_admin_app/app_config/constant.dart';

Widget displayField(var data, var label,
    {maxLines = 1,
    double leftPadding = 10.0,
    double rightPadding = 10.0,
    double topPadding = 5.0,
    double bottomPadding = 5.0}) {
  return Padding(
    padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding),
    child: TextFormField(
        enabled: false,
        initialValue: data.toString(),
        maxLines: maxLines,
        style: text_field_text_style,
        decoration: textFieldDecoration(label)),
  );
}
