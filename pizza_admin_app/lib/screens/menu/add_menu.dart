import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pizza_admin_app/app_config/constant.dart';
import 'package:pizza_admin_app/controller/menu_controller/add_menu_controller.dart';
import 'package:pizza_admin_app/controller/shop_controller/add_shop.dart';
import 'package:pizza_admin_app/services/main_model.dart';
import 'package:pizza_admin_app/widgets_utils/app_bar.dart';
import 'package:pizza_admin_app/widgets_utils/dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

class AddMenu extends StatefulWidget {
  final shopID;
  AddMenu(this.shopID);

  @override
  _AddMenuState createState() => _AddMenuState();
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class _AddMenuState extends State<AddMenu> {
  TextEditingController pizzaName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<File> _files = [];
  ProgressDialog pr;
  var thumbnailUrl;

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Widget _buildScreenUI(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _buildFormNumbersField(
              labelText: 'Pizza Name',
              controller: pizzaName,
              validator: (val) =>
                  val.isEmpty ? 'Pizza Name cannot be empty.' : null),
          _buildFormNumbersField(
              maxLines: 3,
              labelText: 'Description',
              controller: description,
              validator: (val) =>
                  val.isEmpty ? 'Description cannot be empty.' : null),
          _buildFormNumbersField(
              labelText: 'Price',
              type: TextInputType.number,
              controller: price,
              validator: (val) =>
                  val.isEmpty ? 'Price cannot be empty.' : null),
          _getFileButton(),
          ScopedModelDescendant(builder: (context, child, MainModel model) {
            return _buildAddButton(
                label: 'Add Menu',
                onPressed: () async {
                  if (!_formKey.currentState.validate() ||
                      _files[0].path.isEmpty) {
                    print(!_formKey.currentState.validate());
                    showDialog(
                        barrierDismissible: false,
                        context: (context),
                        builder: (context) => displayDialog(
                            'Kindly fix all above issues befor form submission.',
                            context,
                            () => Navigator.pop(context)));
                    await pr.hide();
                    return;
                  }

                  await pr.show();
                  uploadPic()
                      .then((downloadUrl) => addMenuController(
                          model,
                          {
                            'name': pizzaName.text,
                            'description': description.text,
                            'price': price.text,
                            'menuPic': downloadUrl
                          },
                          widget.shopID,
                          context))
                      .then((_) async => await pr.hide());
                });
          })
        ],
      ),
    );
  }

  Future uploadPic() async {
    String fileImage = _files[0].path.split('/').last;
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
                      : _files[0].path.split('/').last,
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
                    allowedExtensions: ['jpg', 'pdf', 'png'],
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
    Function(String) onSaved,
    Function(String) onSubmit,
    VoidCallback onTap,
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
        onSaved: onSaved,
        style: text_field_text_style,
        cursorColor: base_color,
        decoration: textFieldDecoration(labelText),
        onTap: () => onTap(),
        onFieldSubmitted: onSubmit,
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
        color: base_color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, isDismissible: false);
    return Scaffold(
      appBar: appBar(context, 'Add Menu'),
      body: _buildScreenUI(context),
    );
  }
}
