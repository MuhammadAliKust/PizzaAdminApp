import 'package:flutter/material.dart';
import 'package:pizza_admin_app/screens/shops/manage_shops.dart';
import 'package:pizza_admin_app/services/main_model.dart';
import 'package:pizza_admin_app/widgets_utils/navigation.dart';

addMenuController(MainModel model, Map<String, dynamic> data, var shopID,
    BuildContext context) async {
  model.addMenuDetails(data, shopID).then((val) {
    NavigationUitls.push(context, ManageShops(model));
  });
}
