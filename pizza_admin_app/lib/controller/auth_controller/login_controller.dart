import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizza_admin_app/helper/auth_state.dart';
import 'package:pizza_admin_app/screens/shops/manage_shops.dart';
import 'package:pizza_admin_app/services/main_model.dart';
import 'package:pizza_admin_app/widgets_utils/dialog.dart';

loginController(
  MainModel model,
  var message,
  String email,
  String password,
  BuildContext context,
) async {
  getCurrentUserID() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    var uid = _user.uid;

    return uid;
  }

  HelperFunctions.saveUserLoggedInSharedPreference(true);
  message = await model.signInWithEmailAndPassword(email, password);
  if (message == true) {
    HelperFunctions.saveUserLoggedInUidSharedPreference(
        await getCurrentUserID());
    HelperFunctions.saveCurrentUserEmail(email);
    HelperFunctions.saveCurrentUserPassword(password);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ManageShops(
              model,
            )));
  } else {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return displayDialog(
            message,
            context,
            () => Navigator.of(context).pop(),
          );
        });
  }
}
