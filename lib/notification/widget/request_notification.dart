import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/notification/model/friends_model.dart';
import 'package:buddy/notification/model/notification_model.dart';
import 'package:buddy/notification/model/notification_provider.dart';
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
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                  ),
                  title: Text(
                    widget.notificationModel.title,
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
          //---( Accepting Request )---//
          final _acceptDB =
              FirebaseDatabase.instance.reference().child('Friends');
          //---( Generating Friendsid key )---//
          final _fid =
              _acceptDB.child(widget.notificationModel.nameId).push().key;
          //---( Accepting Request at Target Side )---//
          final friendPayload = FriendsModel(
            fid: _fid,
            uid: _auth.currentUser!.uid,
          );
          _acceptDB
              .child(widget.notificationModel.nameId)
              .child(_fid)
              .set(friendPayload.toMap());
          //---( Accepting Request at Sender Side )---//
          final myPayload = FriendsModel(
            fid: _fid,
            uid: widget.notificationModel.nameId,
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
            title: '#NAME started following you !',
            nameId: widget.notificationModel.nameId,
            uid: '',
            eventId: '',
            createdAt: DateTime.now().toString(),
          );
          _textNotDB.child(_tid).set(newTextNot.toMap());
        }
        //---( Updating Providers )---//
        Provider.of<NotificationProvider>(context, listen: false)
            .removeNotification(widget.notificationModel);
        CustomSnackbar().showFloatingFlushbar(
          context: context,
          message: 'Connection request accepted successfully!',
          color: Colors.green,
        );
      },
    );
  }
}
