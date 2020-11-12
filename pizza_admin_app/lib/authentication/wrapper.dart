import 'package:flutter/material.dart';
import 'package:pizza_admin_app/authentication/auth_screens.dart/login.dart';

import 'package:pizza_admin_app/screens/shops/manage_shops.dart';
import 'package:pizza_admin_app/services/main_model.dart';

class Wrapper extends StatelessWidget {
  final bool userIsLoggedIn;
  final MainModel model;
  Wrapper(this.userIsLoggedIn, this.model);
  @override
  Widget build(BuildContext context) {
    return userIsLoggedIn != null
        ? userIsLoggedIn ? ManageShops(model) : Login()
        : Login();
  }
}
