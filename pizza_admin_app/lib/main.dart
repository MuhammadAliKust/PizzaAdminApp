import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:pizza_admin_app/app_config/constant.dart';
import 'package:pizza_admin_app/authentication/wrapper.dart';
import 'package:pizza_admin_app/services/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:characters/characters.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  //*will store logged in status of user
  bool userIsLoggedIn;

  @override
  void initState() {
    super.initState();
    _model.getLoggedInStatus().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    FlutterStatusbarcolor.setStatusBarColor(Color(0xff205897));
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
          theme: theme_data,
          home: Wrapper(userIsLoggedIn, _model)),
    );
  }
}
