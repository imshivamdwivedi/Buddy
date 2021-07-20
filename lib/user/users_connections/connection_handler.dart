import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/notification/model/notification_model.dart';
import 'package:buddy/user/models/home_search_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectionHandler {
  final _auth = FirebaseAuth.instance;
  final _firebaseDatabase = FirebaseDatabase.instance;

  void createRequest(String userId, String targetId, BuildContext context,
      String myName, HomeSearchHelper user) async {
    final _refReq =
        _firebaseDatabase.reference().child('Notification').child(targetId);
    final _userDB = _firebaseDatabase
        .reference()
        .child('Users')
        .child(_auth.currentUser!.uid)
        .child('Request');
    final String _rid = _refReq.push().key;

    final notPayload = NotificationModel(
      id: _rid,
      type: 'REQ',
      title: '',
      name: myName,
      nameId: _auth.currentUser!.uid,
      uid: targetId,
      eventName: '',
      eventId: '',
      createdAt: DateTime.now().toString(),
    );

    await _refReq.child(_rid).set(notPayload.toMap());
    await _userDB.child(_rid).child('uid').set(targetId);
    await _userDB.child(_rid).child('rid').set(_rid);
    //---( Confirming )---//
    user.toggleFriend();
    CustomSnackbar().showFloatingFlushbar(
      context: context,
      message: 'Connection request sent successfully!',
      color: Colors.green,
    );
  }
}
