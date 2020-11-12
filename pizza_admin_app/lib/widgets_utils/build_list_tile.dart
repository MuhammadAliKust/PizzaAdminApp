import 'package:flutter/material.dart';
import 'package:pizza_admin_app/app_config/constant.dart';
import 'package:pizza_admin_app/services/main_model.dart';

enum TrailingIconStateSwitcher { Display, Edit, Delete, Details }
Widget buildListTile(
    {MainModel model,
    BuildContext context,
    var snapshot,
    var i,
    var key,
    VoidCallback onPressed,
    TrailingIconStateSwitcher state,
    IconData icon = Icons.ac_unit}) {
  return ListTile(
    leading: _buildLeading(icon),
    trailing: _buildTrailing(state, () => onPressed()),
    title: _buildTitle(snapshot, i, context),
    subtitle: snapshot.data.documents[i].data['section'] != ''
        ? _buildSubTitle(snapshot, i)
        : null,
  );
}

Widget _buildLeading(IconData icon) {
  return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: base_color),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ));
}

Widget _buildTrailing(var state, VoidCallback onPressed) {
  return trailingStateSwitcher(state, () => onPressed());
}

Widget _buildTitle(var snapshot, var i, BuildContext context) {
  return Text(
    '${snapshot.data.documents[i].data['name']}'.toUpperCase(),
    style: Theme.of(context)
        .textTheme
        .subtitle1
        .merge(TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget _buildSubTitle(var snapshot, var i) {
  return Text(
    'Section: ${snapshot.data.documents[i].data['section']}'.toUpperCase(),
  );
}

trailingStateSwitcher(state, VoidCallback onPressed) {
  switch (state) {
    case TrailingIconStateSwitcher.Display:
      return null;
    case TrailingIconStateSwitcher.Delete:
      return IconButton(
        icon: Icon(
          Icons.delete,
          size: 20,
          color: Colors.red,
        ),
        onPressed: () => onPressed(),
      );
    case TrailingIconStateSwitcher.Edit:
      return IconButton(
        icon: Icon(
          Icons.edit,
          size: 20,
          color: base_color,
        ),
        onPressed: () => onPressed(),
      );
    case TrailingIconStateSwitcher.Details:
      return IconButton(
        icon: Icon(
          Icons.arrow_forward_ios,
          size: 17,
          color: base_color,
        ),
        onPressed: () => onPressed(),
      );
  }
}
