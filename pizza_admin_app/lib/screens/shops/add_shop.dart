import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:pizza_admin_app/app_config/constant.dart';
import 'package:pizza_admin_app/controller/shop_controller/add_shop.dart';
import 'package:pizza_admin_app/services/main_model.dart';
import 'package:pizza_admin_app/widgets_utils/app_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pizza_admin_app/widgets_utils/dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

class AddShop extends StatefulWidget {
  @override
  _AddShopState createState() => _AddShopState();
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class _AddShopState extends State<AddShop> {
  TextEditingController pizzaShopName = TextEditingController();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController openHour = TextEditingController();
  TextEditingController closeHour = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController insta = TextEditingController();
  TextEditingController fb = TextEditingController();
  TextEditingController phone = TextEditingController();
  var thumbnailUrl;
  List<File> _files = [];
  ProgressDialog pr;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  String apiKey = "AIzaSyDBmMM2hg9tVOVdP87ihxFxfaaqOWlzo8w";
  var shopAddress = null;
  var lat;
  var lng;
  final _formKey = GlobalKey<FormState>();
  Random _rnd = Random();

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Widget _buildScreenUI(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildFormNumbersField(
                labelText: 'Shop Name',
                controller: pizzaShopName,
                validator: (val) =>
                val.isEmpty ? 'Shop Name cannot be empty.' : null),
            _buildFormNumbersField(
                labelText: 'Owner First Name',
                controller: fName,
                validator: (val) =>
                val.isEmpty ? 'Owner First Name cannot be empty.' : null),
            _buildFormNumbersField(
                labelText: 'Owner Last Name',
                controller: lName,
                validator: (val) =>
                val.isEmpty ? 'Owner Last Name cannot be empty.' : null),
            _buildFormNumbersField(
                labelText: 'Description',
                controller: description,
                maxLines: 3,
                validator: (val) =>
                val.isEmpty ? 'Description cannot be empty.' : null),
            _buildFormNumbersField(
                labelText: 'Opening Hours',
                type: TextInputType.number,
                controller: openHour,
                validator: (val) =>
                val.isEmpty ? 'Opening Hours cannot be empty.' : null),
            _buildFormNumbersField(
                type: TextInputType.number,
                labelText: 'Closing Hours',
                controller: closeHour,
                validator: (val) =>
                val.isEmpty ? 'Closing Hours cannot be empty.' : null),
            _buildFormNumbersField(
                type: TextInputType.emailAddress,
                labelText: 'Email',
                controller: email,
                validator: (val) =>
                val.isEmpty ? 'Email cannot be empty.' : null),
            _buildFormNumbersField(
                type: TextInputType.emailAddress,
                labelText: 'Phone Number',
                controller: phone,
                validator: (val) =>
                val.isEmpty ? 'Phone Number cannot be empty.' : null),
            _buildFormNumbersField(
              type: TextInputType.url,
              labelText: 'Insta Link',
              controller: insta,
            ),
            _buildFormNumbersField(
              type: TextInputType.url,
              labelText: 'Facebook Name',
              controller: fb,
            ),
            _getFileButton(),
            _buildAddressField(),
            ScopedModelDescendant(builder: (context, child, MainModel model) {
              return _buildAddButton(
                  label: 'Add Shop',
                  onPressed: () async {
                    if (!_formKey.currentState.validate() ||
                        _files[0].path.isEmpty) {
                      await pr.hide();
                      print(!_formKey.currentState.validate());
                      showDialog(
                          barrierDismissible: false,
                          context: (context),
                          builder: (context) =>
                              displayDialog(
                                  'Kindly fix all above issues befor form submission.',
                                  context,
                                      () => Navigator.pop(context)));

                      return;
                    }
                    await pr.show();
                    uploadPic()
                        .then((downloadUrl) =>
                        addShopController(
                            model,
                            {
                              'pizzaShopName': pizzaShopName.text,
                              'thumbnail': downloadUrl,
                              'fName': fName.text,
                              'lName': lName.text,
                              'address': shopAddress,
                              'description': description.text,
                              'openHour': openHour.text,
                              'closeHour': closeHour.text,
                              'email': email.text,
                              'insta': insta.text,
                              'phone': phone.text,
                              'fb': fb.text,
                              'location': {'lat': lat, 'long': lng}
                            },
                            context))
                        .then((value) async => await pr.hide());
                  });
            })
          ],
        ),
      ),
    );
  }

  Widget _getFileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: base_color),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _files.isEmpty
                      ? 'Selected File'
                      : _files[0].path
                      .split('/')
                      .last,
                  style: TextStyle(color: base_color),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.attach_file,
                  color: base_color,
                ),
                onPressed: () async {
                  List<File> files = await FilePicker.getMultiFile(
                    type: FileType.custom,
                  );
                  if (files != null && files.isNotEmpty)
                    setState(() {
                      _files = files;
                    });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future uploadPic() async {
    String fileImage = _files[0].path
        .split('/')
        .last;
    print(fileImage);
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('images/' + getRandomString(10));
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_files[0]);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");
      // Scaffold.of(context)
      //     .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
    thumbnailUrl = await taskSnapshot.ref.getDownloadURL();
    return thumbnailUrl;
  }

  Widget _buildFormNumbersField({
    Function(String) validator,
    var initialValue,
    var controller,
    var labelText,
    bool enable = true,
    FocusNode focusNode,
    bool cursor = true,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        validator: validator,
        initialValue: initialValue,
        controller: controller,
        focusNode: focusNode,
        keyboardType: type,
        showCursor: cursor,
        enabled: enable,
        maxLines: maxLines,
        style: text_field_text_style,
        cursorColor: base_color,
        decoration: textFieldDecoration(labelText),
      ),
    );
  }

  Widget _buildAddButton({String label, VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () => onPressed(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 48),
          child: Text(label, style: button_text_style),
        ),
        shape: button_border,
        color: button_color,
      ),
    );
  }

  Widget _buildAddressField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: base_color),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  shopAddress == null ? 'Address' : shopAddress,
                  style: TextStyle(color: base_color),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.location_on,
                  color: base_color,
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                            apiKey: apiKey,
                            initialPosition: kInitialPosition,
                            useCurrentLocation: true,
                            //usePlaceDetailSearch: true,
                            onPlacePicked: (result) {
                              setState(() {
                                shopAddress = result.formattedAddress;
                                lat = result.geometry.location.lat;
                                lng = result.geometry.location.lng;
                              });

                              Navigator.of(context).pop();
                            });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          color: Colors.transparent,
          elevation: 0,
          shape: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffc79035))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.edit_location,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text('sdf', style: label_style),
            ],
          ),
          onPressed: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, isDismissible: false);
    return Scaffold(
      appBar: appBar(context, 'Add Shops'),
      body: _buildScreenUI(context),
    );
  }
}
