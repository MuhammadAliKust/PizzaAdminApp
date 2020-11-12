import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizza_admin_app/widgets_utils/build_description.dart';
import 'package:pizza_admin_app/widgets_utils/build_heading.dart';
import 'package:pizza_admin_app/widgets_utils/display_rating.dart';
import 'package:pizza_admin_app/widgets_utils/shop_heder.dart';

class MenuDetails extends StatefulWidget {
  final rating;
  var data;

  MenuDetails(this.rating, this.data);

  @override
  _MenuDetailsState createState() => _MenuDetailsState();
}

const kExpandedHeight = 220.0;

class _MenuDetailsState extends State<MenuDetails> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: kExpandedHeight,
            floating: false,
            pinned: true,
            elevation: 50,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: _showTitle ? Text('Shop Name') : null,
              background: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.data['menuPic'],
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
//                background: Image.network(
//                  widget.data['menuPic'],
//                  fit: BoxFit.cover,
//                )
            ),
          ),
          new SliverList(
              delegate: new SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildShopName(context,
                      shopName: widget.data['name'],
                      rating: widget.rating.toDouble()),
                  Text("\$${widget.data['price']}",
                      style: Theme.of(context).textTheme.headline6)
                ],
              ),
            ),
            Divider(
              thickness: 1.2,
              color: Color(0xffe6e6e6),
            ),
            buildHeading(context, 'Description'),
            buildDescription(widget.data['description'], context),
            Divider(
              thickness: 1.2,
              color: Color(0xffe6e6e6),
            ),
            buildHeading(context, 'Reviews Rating'),
            Divider(),
            ...widget.data['rating'].map((val) {
              return Column(
                children: [
                  ListTile(
                      leading: CircleAvatar(
                        child: Text(val['name'].toString().substring(0, 1)),
                      ),
                      title: Text(val['name']),
                      trailing: displayRating(val['rating'].toDouble() == 'NaN'
                          ? 0
                          : val['rating'].toDouble())),
                  Divider()
                ],
              );
            }).toList()
          ])),
        ],
      ),
    ));
  }
}
