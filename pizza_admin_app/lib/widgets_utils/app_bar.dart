import 'package:flutter/material.dart';
import 'package:pizza_admin_app/app_config/constant.dart';

Widget appBar(BuildContext context, String title) {
  return AppBar(
    elevation: 0,
    backgroundColor: appBarColor,
    title: Text(title),
  );
}
