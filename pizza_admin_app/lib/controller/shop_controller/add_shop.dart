import 'package:flutter/cupertino.dart';
import 'package:pizza_admin_app/screens/shops/manage_shops.dart';
import 'package:pizza_admin_app/services/main_model.dart';
import 'package:pizza_admin_app/widgets_utils/navigation.dart';

addShopController(
    MainModel model, Map<String, dynamic> data, BuildContext context) async {
  model.addShopDetails(data).then((val) {
    NavigationUitls.push(context, ManageShops(model));
  });
}
