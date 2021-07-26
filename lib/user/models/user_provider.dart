import 'dart:async';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel _userModel = new UserModel(profile: true);
  final _auth = FirebaseAuth.instance;
  final _userDB = FirebaseDatabase.instance.reference();
  late StreamSubscription<Event> _userStream;

  UserProvider() {
    _fetchUser();
  }

  void _fetchUser() {
    _userStream = _userDB
        .child('Users')
        .child(_auth.currentUser!.uid)
        .onValue
        .listen((event) {
      _userModel =
          UserModel.fromMap(Map<String, dynamic>.from(event.snapshot.value));
      notifyListeners();
    });
  }

  String getUserName() {
    return _userModel.firstName + ' ' + _userModel.lastName;
  }

  String getFirstName() {
    return _userModel.firstName;
  }

  String getLastName() {
    return _userModel.lastName;
  }

  String getUserCollege() {
    return _userModel.collegeName;
  }

  @override
  void dispose() {
    _userStream.cancel();
    super.dispose();
  }
}
