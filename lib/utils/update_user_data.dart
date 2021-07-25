import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class RefreshUserData {
  void refreshUser(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _firebaseDatabase = FirebaseDatabase.instance;
    final _refUser = _firebaseDatabase.reference().child('Users');
    _refUser
        .orderByChild('id')
        .equalTo(_auth.currentUser!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      Map map = snapshot.value;
      map.values.forEach((element) {
        Provider.of<UserProvider>(context, listen: false)
            .updateUserData(UserModel.fromMap(element));
      });
    });
  }
}
