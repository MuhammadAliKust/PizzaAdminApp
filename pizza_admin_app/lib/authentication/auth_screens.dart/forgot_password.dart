import 'package:flutter/material.dart';
import 'package:pizza_admin_app/app_config/constant.dart';
import 'package:pizza_admin_app/controller/auth_controller/forgot_password_controller.dart';
import 'package:pizza_admin_app/services/main_model.dart';
import 'package:pizza_admin_app/widgets_utils/auth_form_field.dart';
import 'package:pizza_admin_app/widgets_utils/build_custom_header.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  bool isObscured = true;
  var message;
  Map<String, dynamic> _formData = {'email': ''};

  Widget _buildScreenUI() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: imgDecoration("assets/img/login.png"),
          child: ListView(children: <Widget>[
            SizedBox(height: 0.23 * MediaQuery.of(context).size.height),
            buildAuthHeading(context, 'recover\npassword'),
            SizedBox(height: 30),
            Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38.0),
                  child: Column(
                    children: <Widget>[
                      buildFormField(
                        keyBoardType: TextInputType.emailAddress,
                        style: text_field_text_style,
                        onSaved: (val) {
                          _formData['email'] = val;
                        },
                        validator: (value) {
                          if (value.isEmpty ||
                              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(value)) {
                            return 'Please enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        icon: Icons.email,
                        label: 'Email',
                        hint: 'xyz@mail.com',
                      ),
                      SizedBox(height: 30),
                      _buildButton('get link'),
                      SizedBox(height: 30),
                    ],
                  ),
                )),
          ]),
        ),
      ],
    );
  }

  Widget _buildButton(String text) {
    return ScopedModelDescendant(builder: (context, child, MainModel model) {
      return model.isLoading
          ? CircularProgressIndicator()
          : FlatButton(
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  return;
                }

                _formKey.currentState.save();
                forgotPassowrdController(
                  model: model,
                  email: _formData['email'],
                  context: context,
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 58),
                child: Text(text.toUpperCase(), style: button_text_style),
              ),
              shape: button_border,
              color: button_color,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F4FD),
      body: SafeArea(child: _buildScreenUI()),
    );
  }
}
