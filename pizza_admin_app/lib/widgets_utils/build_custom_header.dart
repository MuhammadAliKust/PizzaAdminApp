import 'package:flutter/material.dart';

Widget buildAuthHeading(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 38.0),
    child: Text(title.toUpperCase(),
        style: Theme.of(context).textTheme.headline4.merge(TextStyle(
            fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold))),
  );
}
