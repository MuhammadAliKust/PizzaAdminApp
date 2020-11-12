import 'package:flutter/material.dart';
import 'package:pizza_admin_app/app_config/constant.dart';

Widget buildDatePicker(
    {String subTitle, DateTime date, VoidCallback onPressed}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: base_color),
          borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        subtitle: Text(
          subTitle,
          style: TextStyle(color: base_color),
        ),
        title: Text(
          "${date.year} / ${date.month} / ${date.day}",
          style: TextStyle(color: base_color, fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.date_range,
            color: base_color,
          ),
          onPressed: onPressed,
        ),
      ),
    ),
  );
}
