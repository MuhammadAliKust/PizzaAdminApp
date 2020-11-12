import 'package:flutter/material.dart';
import 'package:pizza_admin_app/app_config/constant.dart';

Widget emptyDropDownWidget(String title, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: base_color),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .merge(TextStyle(color: base_color))),
      )),
    ),
  );
}
