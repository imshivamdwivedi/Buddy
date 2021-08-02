import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/notification/model/notification_model.dart';
import 'package:buddy/user/models/home_search_provider.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/utils/date_time_stamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionHandler {
  final _auth = FirebaseAuth.instance;
  final _firebaseDatabase = FirebaseDatabase.instance;

  void createRequest(String userId, String targetId, BuildContext context,
      String myName, HomeSearchHelper user) async {
    final _refReq =
        _firebaseDatabase.reference().child('Notification').child(targetId);
    final _userDB = _firebaseDatabase
        .reference()
        .child('Requests')
        .child(_auth.currentUser!.uid);
    final String _rid = _refReq.push().key;
    final _otherDB =
        _firebaseDatabase.reference().child('Requests').child(targetId);

    final notPayload = NotificationModel(
      id: _rid,
      type: 'REQ',
      title: '',
      name: myName,
      nameImg: Provider.of<UserProvider>(context, listen: false).getUserImg,
      nameId: _auth.currentUser!.uid,
      collegeName:
          Provider.of<UserProvider>(context, listen: false).getUserCollege,
      uid: targetId,
      eventId: '',
      createdAt: DateTimeStamp().getDate(),
    );

    await _refReq.child(_rid).set(notPayload.toMap());

    //---( Saving Request at My Side )---//
    await _userDB.child(_rid).child('uid').set(targetId);
    await _userDB.child(_rid).child('rid').set(_rid);

    //---( Saving Request at Other Side )---//
    await _otherDB.child(_rid).child('uid').set(_auth.currentUser!.uid);
    await _otherDB.child(_rid).child('rid').set(_rid);

    //---( Confirming )---//
    user.toggleFriend();
    CustomSnackbar().showFloatingFlushbar(
      context: context,
      message: 'Connection request sent successfully!',
      color: Colors.green,
    );
  }
}
