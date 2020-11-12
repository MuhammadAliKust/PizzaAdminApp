import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pizza_admin_app/app_config/constant.dart';
import 'package:pizza_admin_app/helper/url_launcher.dart';
import 'package:pizza_admin_app/screens/menu/add_menu.dart';
import 'package:pizza_admin_app/screens/menu/menu_details.dart';
import 'package:pizza_admin_app/widgets_utils/app_bar.dart';
import 'package:pizza_admin_app/widgets_utils/build_custom_header.dart';
import 'package:pizza_admin_app/widgets_utils/build_description.dart';
import 'package:pizza_admin_app/widgets_utils/build_heading.dart';
import 'package:pizza_admin_app/widgets_utils/display_rating.dart';
import 'package:pizza_admin_app/widgets_utils/horizontal_space.dart';
import 'package:pizza_admin_app/widgets_utils/navigation.dart';
import 'package:pizza_admin_app/widgets_utils/shop_heder.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DisplayShop extends StatefulWidget {
  var shopID;
  DisplayShop(this.shopID);
  @override
  _DisplayShopState createState() => _DisplayShopState();
}

const kExpandedHeight = 220.0;

class _DisplayShopState extends State<DisplayShop> {
  getSelectedShopData(String id) {
    return Firestore.instance.collection('shopDetails').document(id).get();
  }

  getMenu() async {
    return Firestore.instance
        .collection('menuDetails')
        .where('shopID', isEqualTo: widget.shopID)
        .getDocuments();
  }

  List menuDetails = [];
  List shopDetails = [];
  ScrollController _scrollController;

  @override
  void initState() {
    getMenu().then((val) {
      val.documents.forEach((val) {
        menuDetails.add(val.data);
        setState(() {});
      });
    });

    getSelectedShopData(widget.shopID).then((val) {
      shopDetails.add(val.data);
      setState(() {});
    });
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  Widget _buildMenuCard(Map<String, dynamic> data, int index) {
    return InkWell(
      onTap: () {
        NavigationUitls.push(
            context, MenuDetails(data['rating'], menuDetails[index]));
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Color(0xfff2f2f2))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              height: 70,
              imageUrl: data['image'],
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'],
                          style: TextStyle(color: Color(0xff979797))),
                      displayRating(data['rating'].toDouble() == 'NaN'
                          ? 0
                          : data['rating'].toDouble())
                    ],
                  ),
                  Text("\$${data['price']}",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .merge(TextStyle(fontWeight: FontWeight.w500)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHours() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildHeading(context, 'Opening Hours'),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                shopDetails[0]['openHour'] +
                    " -- " +
                    shopDetails[0]['closeHour'],
                style: TextStyle(
                  color: Color(0xff979797),
                ))),
      ],
    );
  }

  Widget _buildSocialMediaLinks() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildHeading(context, 'Social Media Links'),
          Row(children: [
            IconButton(
                icon: Icon(FontAwesomeIcons.facebook),
                onPressed: () {
                  launchUrl(shopDetails[0]['fb']);
                }),
            horizontalSpace(10),
            IconButton(
                icon: Icon(FontAwesomeIcons.instagram),
                onPressed: () {
                  launchUrl(shopDetails[0]['insta']);
                }),
          ]),
        ],
      ),
    );
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: shopDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: kExpandedHeight,
                  floating: false,
                  pinned: true,
                  elevation: 50,
                  backgroundColor: base_color,
                  flexibleSpace: FlexibleSpaceBar(
                      title: _showTitle ? Text('Shop Name') : null,
                      background: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:  shopDetails[0]['thumbnail'],
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )),
                ),
                new SliverList(
                    delegate: new SliverChildListDelegate([
                  buildShopName(context,
                      shopName: shopDetails[0]['pizzaShopName'],
                      rating: shopDetails[0]['rating'].toDouble()),
                  Divider(
                    thickness: 1.2,
                    color: Color(0xffe6e6e6),
                  ),
                  buildHeading(context, 'Description'),
                  buildDescription(shopDetails[0]['description'], context),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1.2,
                    color: Color(0xffe6e6e6),
                  ),
                  _buildOpeningHours(),
                  Divider(
                    thickness: 1.2,
                    color: Color(0xffe6e6e6),
                  ),
                  _buildSocialMediaLinks(),
                  Divider(
                    thickness: 1.2,
                    color: Color(0xffe6e6e6),
                  ),
                  buildHeading(context, 'Our Products')
                ])),
                SliverPadding(
                  padding: const EdgeInsets.all(2.0),
                  sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _getSliverGrid(index);
                        },
                        childCount: menuDetails.length,
                      )),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: base_color,
        onPressed: () {
          NavigationUitls.push(context, AddMenu(widget.shopID));
        },
        label: Row(
          children: [
            Icon(Icons.restaurant_menu),
            horizontalSpace(10),
            Text("Add Menu"),
          ],
        ),
      ),
    ));
  }

  _getSliverGrid(var index) {
    var menuRating = 0;
    var ratingCounter = 0;
    menuDetails[index]['rating'].map((val) {
      print("Rating Value");
      print(val);
      menuRating = val['rating'] + menuRating;
      ratingCounter++;
    }).toList();
    ratingCounter == 0 ? ratingCounter = 1 : ratingCounter;
    return _buildMenuCard({
      'image': menuDetails[index]['menuPic'],
      'name': menuDetails[index]['name'],
      'rating': double.parse((menuDetails[index]['starRating']).toStringAsFixed(1)),
      'price': menuDetails[index]['price'],
    }, index);
  }
}
