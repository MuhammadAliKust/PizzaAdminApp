//import 'package:flutter/material.dart';
//import 'package:pizza_admin_app/authentication/wrapper.dart';
//import 'package:pizza_admin_app/helper/auth_state.dart';
//import 'package:pizza_admin_app/screens/dashBoard.dart';
//import 'package:pizza_admin_app/services/main_model.dart';
//
//class AppDrawer extends StatelessWidget {
//  final MainModel model;
//  final String collectionPath;
//  AppDrawer(this.model, [this.collectionPath]);
//  @override
//  Widget build(BuildContext context) {
//    return Drawer(
//      child: ListView(
//        padding: EdgeInsets.zero,
//        children: <Widget>[
//          _createHeader(),
//
//          _createDrawerItem(
//              icon: Icons.home,
//              text: 'Home',
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => HomeView(model: model)));
//              }),
//          Divider(
//            color: Colors.grey,
//          ),
//          _createDrawerItem(
//              icon: Icons.person_add,
//              text: 'New Student',
//              onTap: () {
//                // Navigator.push(
//                //     context,
//                //     MaterialPageRoute(
//                //         builder: (context) => Home(model: model)));
//              }),
//          _createDrawerItem(
//              icon: Icons.edit,
//              text: 'Edit Student',
//              onTap: () {
//                // Navigator.push(
//                //   context,
//                //   MaterialPageRoute(
//                //     builder: (context) =>
//                //         ClassesList(model, DisplayMode.EditStudentDetailsMode),
//                //   ),
//                // );
//              }),
//
//          Divider(
//            color: Colors.grey,
//          ),
//          _createDrawerItem(
//              icon: Icons.add_circle,
//              text: 'Add Class',
//              onTap: () {
//                // Navigator.push(context,
//                //     MaterialPageRoute(builder: (context) => AddClass(model)));
//              }),
//          _createDrawerItem(
//              icon: Icons.edit,
//              text: 'Edit Class',
//              onTap: () {
//                // Navigator.push(
//                //     context,
//                //     MaterialPageRoute(
//                //         builder: (context) =>
//                //             ClassesList(model, DisplayMode.Edit)));
//              }),
//          Divider(
//            color: Colors.grey,
//          ),
//          // _createDeleteDrawerItem(
//          //     text: 'Delete User',
//          //     onTap: () {
//          //       Navigator.push(
//          //           context,
//          //           MaterialPageRoute(
//          //               builder: (context) => ClassTeachersList(
//          //                   model, DisplayClassTeachersMode.Delete)));
//          //     }),
//
//          _createDrawerItem(
//              icon: Icons.security,
//              text: 'Privacy Policy',
//              onTap: () {
//                // Navigator.push(
//                //     context,
//                //     MaterialPageRoute(
//                //         builder: (context) => PrivacyPolicy(model)));
//              }),
//
//          Divider(
//            color: Colors.grey,
//          ),
//          // _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
//          _createDrawerItem(
//              icon: Icons.exit_to_app,
//              text: 'Logout',
//              onTap: () {
//                HelperFunctions.saveUserLoggedInSharedPreference(false);
//                model.signOut();
//                Navigator.of(context).pushAndRemoveUntil(
//                    MaterialPageRoute(
//                        builder: (context) => Wrapper(false, model)),
//                    (Route<dynamic> route) => false);
//              }),
//
//          ListTile(
//            title: Text('0.0.1'),
//            onTap: () {},
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget _createHeader() {
//    // ignore: missing_required_param
//    return DrawerHeader(
//      margin: EdgeInsets.zero,
//      padding: EdgeInsets.zero,
//      decoration: BoxDecoration(
//          image: DecorationImage(
//              fit: BoxFit.fill, image: AssetImage("assets/img/card_bg.jpg"))),
//    );
//  }
//
//  Widget _createDrawerItem(
//      {IconData icon, String text, GestureTapCallback onTap}) {
//    return ListTile(
//      title: Row(
//        children: <Widget>[
//          Icon(icon),
//          Padding(
//            padding: EdgeInsets.only(left: 8.0),
//            child: Text(text),
//          )
//        ],
//      ),
//      onTap: onTap,
//    );
//  }
//
//  Widget _createDeleteDrawerItem({String text, GestureTapCallback onTap}) {
//    return ListTile(
//      title: Row(
//        children: <Widget>[
//          Icon(Icons.delete_forever, color: Color(0xffff0000)),
//          Padding(
//            padding: EdgeInsets.only(left: 8.0),
//            child: Text(
//              text,
//              style: TextStyle(color: Color(0xffff0000)),
//            ),
//          )
//        ],
//      ),
//      onTap: onTap,
//    );
//  }
//}
