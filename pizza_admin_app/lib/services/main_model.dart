import 'package:pizza_admin_app/services/connected_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with ConnectedModel, AuthModel, AddShopModule, AddMenuDetails, Utilities {}
