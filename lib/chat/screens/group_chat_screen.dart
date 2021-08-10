import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/dm_message_model.dart';
import 'package:buddy/chat/models/group_message_name_provider.dart';
import 'package:buddy/chat/screens/group_detail_screen.dart';
import 'package:buddy/chat/widgets/group_chat_message_widget.dart';
import 'package:buddy/chat/widgets/group_share_message_widget.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/utils/date_time_stamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

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
    final userNames = Provider.of<GroupMessageProviderName>(context).allNames;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: FirebaseAnimatedList(
        sort: (a, b) {
          return a.value['createdAt'] > b.value['createdAt'] ? -1 : 1;
        },
        query: _chats,
        reverse: true,
        defaultChild: Container(
          width: 60,
          height: 60,
          child: new SpinKitWave(
            type: SpinKitWaveType.start,
            size: 40,
            color: Colors.black87,
          ),
        ),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          final msg = NewDmMessage.fromMap(snapshot.value);
          if (msg.text.startsWith(splitCode + 'sharepost=')) {
            //---( Share Post Message )---//
            return GroupShareMessageTile(
              sendBy: userNames[msg.senderId].toString().split(' ').first,
              message: msg.text.substring(14),
              sendByMe: (msg.senderId == _auth.currentUser!.uid),
            );
          } else {
            //---( Simple Text Message )---//
            return GroupMessageTile(
              sendBy: userNames[msg.senderId].toString().split(' ').first,
              message: msg.text,
              sendByMe: (msg.senderId == _auth.currentUser!.uid),
            );
          }
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
    setState(() {
      _chats = _chats.child('Chats').child(widget.chatRoomId).child('ChatRoom');
    });
    final _chDb = FirebaseDatabase.instance
        .reference()
        .child('Channels')
        .child(_auth.currentUser!.uid);
    _chDb.child(widget.chatRoomId).once().then((value) {
      Map map = Map<String, dynamic>.from(value.value);
      final chNameBody = ChatListModel.fromMap(map);
      setState(() {
        _chName = chNameBody.name;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<GroupMessageProviderName>(context, listen: false)
        .fetchGroupName(widget.chatRoomId);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        foregroundColor: Colors.black87,
        backgroundColor: kPrimaryColor,
        title: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  GroupDetailScreen(chatRoomId: widget.chatRoomId),
            ));
          },
          child: Text(
            _chName,
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  )),
              child: chatMessages(),
            )),
            Container(
              color: kPrimaryColor,
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _textEditingController,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        hintText: 'Send message',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0),
                          gapPadding: 10,
                          borderRadius: BorderRadius.circular(25),
                        )),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _addMessage();
                      print("Debugger");
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
