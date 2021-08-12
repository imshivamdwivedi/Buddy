import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/group_channel_model.dart';
import 'package:buddy/chat/screens/group_request_screen.dart';
import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GroupRequesttile extends StatefulWidget {
  final UserModel userModel;
  final String chId;
  GroupRequesttile({required this.userModel, required this.chId});
  @override
  _GroupRequesttileState createState() => _GroupRequesttileState();
}

class _GroupRequesttileState extends State<GroupRequesttile> {
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
                      child: widget.userModel.userImg == ''
                          ? NamedProfileAvatar().profileAvatar(
                              widget.userModel.firstName.substring(0, 1), 40.0)
                          : Image.network(
                              widget.userModel.userImg,
                              height: 40.0,
                              width: 40.0,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  title: Text(
                    widget.userModel.firstName +
                        ' ' +
                        widget.userModel.lastName,
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
      onPressed: () async {
        if (text == 'Delete') {
          //---( Deleting Group Join Request )---//
          final _comDB = FirebaseDatabase.instance
              .reference()
              .child('Chats')
              .child(widget.chId);
          await _comDB.child('requests').once().then((value) {
            String oldStr = value.value;
            _comDB
                .child('requests')
                .set(oldStr.replaceAll('+${widget.userModel.id}', ''));
            myState!.removeItem(widget.userModel);
          });
          CustomSnackbar().showFloatingFlushbar(
            context: context,
            message: 'Join request deleted successfully!',
            color: Colors.red,
          );
        } else if (text == 'Confirm') {
          //---( Deleting Group Join Request before Accepting )---//
          final _comDB = FirebaseDatabase.instance
              .reference()
              .child('Chats')
              .child(widget.chId);
          await _comDB.child('requests').once().then((value) {
            String oldStr = value.value;
            _comDB
                .child('requests')
                .set(oldStr.replaceAll('+${widget.userModel.id}', ''));
            myState!.removeItem(widget.userModel);
          });
          //---( Accepting Join Request )---//
          _comDB.once().then((DataSnapshot snapshot) {
            final chModel = GroupChannel.fromMap(snapshot.value);
            //---( Adding New User to Main User List )---//
            String oldUsers = chModel.users;
            oldUsers += '+${widget.userModel.id}';
            _comDB.child('users').set(oldUsers);
            //---( Add Channel History to the User Channel Schema )---//
            final _chDb = FirebaseDatabase.instance
                .reference()
                .child('Channels')
                .child(widget.userModel.id)
                .child(chModel.chid);
            final _chPayload = ChatListModel(
              chid: chModel.chid,
              name: chModel.chName,
              nameImg: chModel.chImg,
              user: widget.userModel.id,
              msgPen: 0,
              lastMsg: '',
            );
            _chDb.set(_chPayload.toMap());
          });
          CustomSnackbar().showFloatingFlushbar(
            context: context,
            message: 'Connection request accepted successfully !',
            color: Colors.green,
          );
        }
      },
    );
  }
}
