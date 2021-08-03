import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/notification/model/notification_model.dart';
import 'package:buddy/user/models/follower_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/utils/date_time_stamp.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestNotification extends StatefulWidget {
  final NotificationModel notificationModel;
  RequestNotification({required this.notificationModel});
  @override
  _RequestNotificationState createState() => _RequestNotificationState();
}

class _RequestNotificationState extends State<RequestNotification> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
          color: kPrimaryLightColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      child: widget.notificationModel.nameImg == ''
                          ? NamedProfileAvatar().profileAvatar(
                              widget.notificationModel.name.substring(0, 1),
                              40.0)
                          : Image.network(
                              widget.notificationModel.nameImg,
                              height: 40.0,
                              width: 40.0,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  title: Text(
                    widget.notificationModel.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              roundButton("Confirm"),
              SizedBox(
                width: 10,
              ),
              roundButton("Delete"),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roundButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      onPressed: () {
        if (text == 'Delete') {
          //---( Deleting Request )---//
          //---( From Target Side )---//
          final _deleteDB = FirebaseDatabase.instance
              .reference()
              .child('Notification')
              .child(_auth.currentUser!.uid);
          _deleteDB.child(widget.notificationModel.id).set(null);

          final _deleteReqDB = FirebaseDatabase.instance
              .reference()
              .child('Requests')
              .child(_auth.currentUser!.uid);
          _deleteReqDB.child(widget.notificationModel.id).set(null);

          //---( From Sender Side )---//
          final _clearDB = FirebaseDatabase.instance
              .reference()
              .child('Requests')
              .child(widget.notificationModel.nameId);
          _clearDB.child(widget.notificationModel.id).set(null);

          CustomSnackbar().showFloatingFlushbar(
            context: context,
            message: 'Connection request deleted successfully!',
            color: Colors.red,
          );
        } else if (text == 'Confirm') {
          final userCurrent = Provider.of<UserProvider>(context, listen: false);
          final _followingDB =
              FirebaseDatabase.instance.reference().child('Following');
          final _followerDB =
              FirebaseDatabase.instance.reference().child('Followers');

          //---( Making Follower Model Also --> For Acceptor after Checking )---//
          _followingDB
              .child(_auth.currentUser!.uid)
              .orderByChild('uid')
              .equalTo(widget.notificationModel.nameId)
              .once()
              .then((DataSnapshot snapshot) {
            if (snapshot.value == null) {
              final _foid1 =
                  _followingDB.child(_auth.currentUser!.uid).push().key;
              final _followModel1 = FollowerModel(
                name: widget.notificationModel.name,
                foid: _foid1,
                collegeName: widget.notificationModel.collegeName,
                uid: widget.notificationModel.nameId,
                userImg: widget.notificationModel.nameImg,
              );
              _followingDB
                  .child(_auth.currentUser!.uid)
                  .child(_foid1)
                  .set(_followModel1.toMap());

              //---( Follower Added )---//
              final _foid2 =
                  _followerDB.child(widget.notificationModel.nameId).push().key;
              final _followModel2 = FollowerModel(
                name: userCurrent.getUserName,
                foid: _foid2,
                collegeName: userCurrent.getUserCollege,
                uid: userCurrent.getUserId,
                userImg: userCurrent.getUserImg,
              );
              _followerDB
                  .child(widget.notificationModel.nameId)
                  .child(_foid2)
                  .set(_followModel2.toMap());
            }
          });

          //---( Making Follower Model Also --> For Sender after Checking )---//
          _followingDB
              .child(widget.notificationModel.nameId)
              .orderByChild('uid')
              .equalTo(_auth.currentUser!.uid)
              .once()
              .then((DataSnapshot snapshot) {
            if (snapshot.value == null) {
              final _foid2 = _followingDB
                  .child(widget.notificationModel.nameId)
                  .push()
                  .key;
              final _followModel2 = FollowerModel(
                name: userCurrent.getUserName,
                foid: _foid2,
                collegeName: userCurrent.getUserCollege,
                uid: userCurrent.getUserId,
                userImg: userCurrent.getUserImg,
              );
              _followingDB
                  .child(widget.notificationModel.nameId)
                  .child(_foid2)
                  .set(_followModel2.toMap());

              //---( Follower Added )---//
              final _foid1 =
                  _followerDB.child(_auth.currentUser!.uid).push().key;
              final _followModel1 = FollowerModel(
                collegeName: userCurrent.getUserCollege,
                name: widget.notificationModel.name,
                foid: _foid1,
                uid: widget.notificationModel.nameId,
                userImg: widget.notificationModel.nameImg,
              );
              _followerDB
                  .child(_auth.currentUser!.uid)
                  .child(_foid1)
                  .set(_followModel1.toMap());
            }
          });

          //---( Accepting Request )---//
          final _acceptDB =
              FirebaseDatabase.instance.reference().child('Friends');
          //---( Generating Friendsid key )---//
          final _fid =
              _acceptDB.child(widget.notificationModel.nameId).push().key;
          //---( Accepting Request at Target Side )---//
          final friendPayload = FriendsModel(
            fid: _fid,
            collegeName: userCurrent.getUserCollege,
            uid: _auth.currentUser!.uid,
            name: userCurrent.getUserName,
            userImg: userCurrent.getUserImg,
          );
          _acceptDB
              .child(widget.notificationModel.nameId)
              .child(_fid)
              .set(friendPayload.toMap());
          //---( Accepting Request at Sender Side )---//
          final myPayload = FriendsModel(
            fid: _fid,
            collegeName: widget.notificationModel.collegeName,
            uid: widget.notificationModel.nameId,
            name: widget.notificationModel.name,
            userImg: widget.notificationModel.nameImg,
          );
          _acceptDB
              .child(_auth.currentUser!.uid)
              .child(_fid)
              .set(myPayload.toMap());
          //---( From Target Side )---//
          final _deleteDB = FirebaseDatabase.instance
              .reference()
              .child('Notification')
              .child(_auth.currentUser!.uid);
          _deleteDB.child(widget.notificationModel.id).set(null);

          final _deleteReqDB = FirebaseDatabase.instance
              .reference()
              .child('Requests')
              .child(_auth.currentUser!.uid);
          _deleteReqDB.child(widget.notificationModel.id).set(null);

          //---( From Sender Side )---//
          final _clearDB = FirebaseDatabase.instance
              .reference()
              .child('Requests')
              .child(widget.notificationModel.nameId);
          _clearDB.child(widget.notificationModel.id).set(null);

          //---( Creating Text Notification Acceptor Side )---//
          final _textNotDB = FirebaseDatabase.instance
              .reference()
              .child('Notification')
              .child(_auth.currentUser!.uid);
          final _tid = _textNotDB.push().key;
          final newTextNot = NotificationModel(
            id: _tid,
            type: 'REQT',
            name: widget.notificationModel.name,
            title: '#NAME started following you !',
            nameId: widget.notificationModel.nameId,
            collegeName: widget.notificationModel.collegeName,
            nameImg: '',
            uid: '',
            eventId: '',
            createdAt: DateTimeStamp().getDate(),
          );
          _textNotDB.child(_tid).set(newTextNot.toMap());
        }
        //---( Updating Providers )---//
        CustomSnackbar().showFloatingFlushbar(
          context: context,
          message: 'Connection request accepted successfully!',
          color: Colors.green,
        );
      },
    );
  }
}
