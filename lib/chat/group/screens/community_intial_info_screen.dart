import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/group_channel_model.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CommunityIntialInfoCreateScreen extends StatefulWidget {
  final List<FriendsModel> users;
  CommunityIntialInfoCreateScreen({required this.users});

  @override
  _CommunityIntialInfoCreateScreenState createState() =>
      _CommunityIntialInfoCreateScreenState();
}

class _CommunityIntialInfoCreateScreenState
    extends State<CommunityIntialInfoCreateScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _chNameController = new TextEditingController();

  void _createCommunity() {
    final String chName = _chNameController.text;

    if (_chNameController.text.isEmpty) {
      //---( Null Check )---//

      return;
    }
    var users = _auth.currentUser!.uid;
    final admins = _auth.currentUser!.uid;

    widget.users.forEach((element) {
      users = users + '+' + element.uid;
    });

    //---( Creating Basic Channel )---//
    final _comDb = FirebaseDatabase.instance.reference().child('Chats');
    final _chid =
        FirebaseDatabase.instance.reference().child('Chats').push().key;
    final _newGroupChannel = GroupChannel(
      chid: _chid,
      type: 'COM',
      users: users,
      admins: admins,
      chName: chName,
      chImg: '',
      createdAt: DateTime.now().toString(),
    );
    _comDb.child(_chid).set(_newGroupChannel.toMap());

    //---( Setting Channel Values Checks )---//
    List<String> usersAll = users.split('+');
    final _chDb = FirebaseDatabase.instance.reference().child('Channels');

    usersAll.forEach((element) {
      final _chOne = _chDb.child(element).child(_chid);
      final _chPayload = ChatListModel(
        chid: _chid,
        name: chName,
        nameImg: '',
        user: element,
      );
      _chOne.set(_chPayload.toMap());
    });

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "New Community",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                //---( Create Community )---//
                _createCommunity();
              },
              icon: Icon(
                Icons.done,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    radius: 30,
                    backgroundImage: AssetImage(
                      'assets/icons/camera.png',
                    ),
                  ),
                  SizedBox(width: size.width * 0.01),
                  Expanded(
                    child: TextField(
                      controller: _chNameController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Provide a community name and optional community avatar",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1.8 / 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 5,
                          ),
                          shrinkWrap: true,
                          itemCount: widget.users.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 5,
                                              color: Colors.grey,
                                              spreadRadius: 1)
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          child: widget.users[index].userImg ==
                                                  ''
                                              ? NamedProfileAvatar()
                                                  .profileAvatar(
                                                      widget.users[index].name
                                                          .substring(0, 1),
                                                      60.0)
                                              : Image.network(
                                                  widget.users[index].userImg,
                                                  height: 60.0,
                                                  width: 60.0,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(widget.users[index].name
                                        .split(" ")
                                        .first)
                                  ],
                                ));
                          }),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
