import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/dm_message_model.dart';
import 'package:buddy/chat/widgets/chat_message_widget.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/utils/date_time_stamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class GroupChatScreen extends StatefulWidget {
  final String chatRoomId;
  GroupChatScreen({required this.chatRoomId});
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _textEditingController = new TextEditingController();
  DatabaseReference _chats = FirebaseDatabase.instance.reference();
  var _chName = '';

  Widget chatMessages() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: FirebaseAnimatedList(
        sort: (a, b) {
          return a.value['createdAt'] > b.value['createdAt'] ? -1 : 1;
        },
        query: _chats,
        reverse: true,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          final msg = NewDmMessage.fromMap(snapshot.value);
          return MessageTile(
            message: msg.text,
            sendByMe: (msg.senderId == _auth.currentUser!.uid),
          );
        },
      ),
    );
  }

  void _addMessage() {
    if (_textEditingController.text.isNotEmpty) {
      final _textMsg = _textEditingController.text;
      final _msgDb = FirebaseDatabase.instance
          .reference()
          .child('Chats')
          .child(widget.chatRoomId)
          .child('ChatRoom');
      final _msgKey = _msgDb.push().key;
      final _newMessage = NewDmMessage(
        msgId: _msgKey,
        senderId: _auth.currentUser!.uid,
        text: _textMsg,
        isRead: false,
        createdAt: DateTimeStamp().getDate(),
      );
      _msgDb.child(_msgKey).set(_newMessage.toMap());
      setState(() {
        _textEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _chats = _chats.child('Chats').child(widget.chatRoomId).child('ChatRoom');
    });
    final _chDb = FirebaseDatabase.instance
        .reference()
        .child('Channels')
        .child(_auth.currentUser!.uid);
    _chDb.orderByChild('chid').equalTo(widget.chatRoomId).once().then((value) {
      Map map = value.value;
      map.values.forEach((element) {
        final chNameBody = ChatListModel.fromMap(element);
        setState(() {
          _chName = chNameBody.name;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        foregroundColor: Colors.black87,
        backgroundColor: kPrimaryColor,
        title: Text(
          _chName,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: kPrimaryLightColor,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _textEditingController,
                      //style: simpleTextStyle(),
                      decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        //---( Send Some Messages )---//
                        _addMessage();
                        print('msg sent ============== ');
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              // gradient: LinearGradient(
                              //     colors: [
                              //       const Color(0x36FFFFFF),
                              //       const Color(0x0FFFFFFF)
                              //     ],
                              //     begin: FractionalOffset.topLeft,
                              //     end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/images/google.png",
                            height: 25,
                            width: 25,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
