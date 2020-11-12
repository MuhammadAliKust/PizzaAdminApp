import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pizza_admin_app/app_config/constant.dart';
import 'package:pizza_admin_app/authentication/wrapper.dart';
import 'package:pizza_admin_app/helper/auth_state.dart';
import 'package:pizza_admin_app/screens/shops/add_shop.dart';
import 'package:pizza_admin_app/screens/shops/display_shop.dart';
import 'package:pizza_admin_app/services/main_model.dart';
import 'package:pizza_admin_app/widgets_utils/app_bar.dart';
import 'package:pizza_admin_app/widgets_utils/display_rating.dart';
import 'package:pizza_admin_app/widgets_utils/horizontal_space.dart';
import 'package:pizza_admin_app/widgets_utils/navigation.dart';

class ManageShops extends StatefulWidget {
  MainModel model;
  ManageShops(this.model);
  @override
  _ManageShopsState createState() => _ManageShopsState();
}

class _ManageShopsState extends State<ManageShops> {
  Stream shops;

  @override
  void initState() {
    super.initState();
    widget.model.displayShopDetails().then((val) {
      shops = val;
      setState(() {});
    });
  }

  Widget _buildScreenUI(BuildContext context) {
    return StreamBuilder(
      stream: shops,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? snapshot.data.documents.length >= 1
                ? _buildListView(snapshot)
                : Text("No Shops")
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildListView(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListTile(snapshot, index);
      },
    );
  }

  Widget _buildListTile(AsyncSnapshot snapshot, var i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 3,
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DisplayShop(snapshot.data.documents[i].documentID)));
          },
          leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  snapshot.data.documents[i].data['thumbnail'] ?? 'N/A')),
          title: Text(
            snapshot.data.documents[i].data['pizzaShopName'] ?? 'N/A',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: displayRating(
              snapshot.data.documents[i].data['rating'].toDouble()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Do you want to exit?"),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("No")),
            FlatButton(
                onPressed: () {
                  exit(0);
                },
                child: Text("Yes"))
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: _appBar(context, 'Manage Your Shops'),
        body: _buildScreenUI(context),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: base_color,
          onPressed: () {
            NavigationUitls.push(context, AddShop());
          },
          label: Row(
            children: [
              Icon(Icons.add),
              horizontalSpace(5),
              Text("Creat New Shop")
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context, String title) {
    return AppBar(
      leading: Container(),
      elevation: 0,
      backgroundColor: appBarColor,
      title: Text(title),
      actions: [
        IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              NavigationUitls.push(context, Wrapper(false, widget.model));
            })
      ],
    );
  }
}
