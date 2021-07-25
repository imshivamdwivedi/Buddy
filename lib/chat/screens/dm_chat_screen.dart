import 'package:buddy/chat/models/dm_message_model.dart';
import 'package:buddy/chat/widgets/chat_message_widget.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/utils/date_time_stamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DmChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String userId;
  DmChatScreen({required this.chatRoomId, required this.userId});
  @override
  _DmChatScreenState createState() => _DmChatScreenState();
}

class _DmChatScreenState extends State<DmChatScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _textEditingController = new TextEditingController();
  DatabaseReference _chats = FirebaseDatabase.instance.reference();
  String userName = '';

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
    final _userDb = FirebaseDatabase.instance.reference().child('Users');
    _userDb.orderByChild('id').equalTo(widget.userId).once().then((value) {
      Map map = value.value;
      map.values.forEach((element) {
        final user = UserModel.fromMap(element);
        setState(() {
          userName = user.firstName + " " + user.lastName;
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
          userName,
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
                  IconButton(
                      onPressed: () {
                        _addMessage();
                      },
                      icon: Icon(Icons.send))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.send,
            ),
            iconSize: 25,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
