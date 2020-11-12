import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizza_admin_app/helper/auth_state.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedModel extends Model {
  bool _isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage;
  String idToken;
  String selCId;
  String collectionPath;
  String selSId;
  //get currentUser ID
  getCurrentUserID() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    var uid = _user.uid;

    return uid;
  }

  //Admin Collection
  final CollectionReference _adminCollection =
      Firestore.instance.collection('adminDetails');
  //Shop Collection
  final CollectionReference _shopCollection =
      Firestore.instance.collection('shopDetails');
  //Menu Collection
  final CollectionReference _menuCollection =
      Firestore.instance.collection('menuDetails');
}

class AuthModel extends ConnectedModel {
  //Peform Signin Operation
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Invalid Password.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "Email not found.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          errorMessage = "Kindly! Check your Internet Connection.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }

    if (errorMessage != null) {
      return errorMessage;
    }
  }

  //Perform SignUp Operation
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "This email is already in use.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }

    if (errorMessage != null) {
      return errorMessage;
    }
  }

  //Perform Password Reset Operation
  Future resetPass(String email) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      switch (error.code) {
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "Your provided email not found.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    }
  }

  //Checking user logged in status
  getLoggedInStatus() async {
    return await HelperFunctions.getUserLoggedInSharedPreference();
  }

  //Perform SignOut Operation
  Future signOut() async {
    return await _auth.signOut();
  }
}

class AddShopModule extends ConnectedModel {
  //add shop details
  addShopDetails(Map<String, dynamic> data) async {
    try {
      var docID = await _shopCollection.document();
      docID.setData({
        'rating': 0,
        'docID': docID.documentID,
        'userID': await getCurrentUserID(),
        'pizzaShopName': data['pizzaShopName'],
        'thumbnail': data['thumbnail'],
        'fName': data['fName'],
        'lName': data['lName'],
        'description': data['description'],
        'address': data['address'],
        'openHour': data['openHour'],
        'closeHour': data['closeHour'],
        'email': data['email'],
        'insta': data['insta'],
        'phone':data['phone'],
        'fb': data['fb'],
        'location': {
          'lat': data['location']['lat'],
          'long': data['location']['long']
        }
      }).catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
  }

  //display shop details
  displayShopDetails() async {
    try {
      return _shopCollection
          .where('userID', isEqualTo: await getCurrentUserID())
          .snapshots();
    } catch (e) {
      print(e);
    }
  }
}

class AddMenuDetails extends ConnectedModel {
  //add shop details
  addMenuDetails(Map<String, dynamic> data, var shopID) async {
    try {
      var docID = await _menuCollection.document();
      docID.setData({
        'docID': docID.documentID,
        'shopID': shopID,
        'userID': await getCurrentUserID(),
        'name': data['name'],
        'description': data['description'],
        'price': data['price'],
        'menuPic': data['menuPic'],
        'starRating':0,
        'rating': []
      }).catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
  }

  //display shop details
  displayMenuDetails() async {
    try {
      return _menuCollection
          .where('userID', isEqualTo: await getCurrentUserID())
          .snapshots();
    } catch (e) {
      print(e);
    }
  }
}

class Utilities extends ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
}
