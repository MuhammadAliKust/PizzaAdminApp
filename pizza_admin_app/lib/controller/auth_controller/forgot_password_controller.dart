import 'package:flutter/material.dart';
import 'package:pizza_admin_app/authentication/auth_screens.dart/login.dart';
import 'package:pizza_admin_app/services/main_model.dart';
import 'package:pizza_admin_app/widgets_utils/dialog.dart';

forgotPassowrdController({
  MainModel model,
  String email,
  BuildContext context,
}) async {
  var message;
  message = await model.resetPass(email);
  if (message == true) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return displayDialog(
              'An email with password reset link has been send to your provided email id.',
              context,
              () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false),
              'Information!');
        });
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
