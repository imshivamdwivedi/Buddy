import 'dart:async';
import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class ChatListProvider with ChangeNotifier {
  List<ChatListModel> _chatList = [];
  int _msgCount = 0;
  var isFirstTime = true;
  final _auth = FirebaseAuth.instance;
  final _chatListDB = FirebaseDatabase.instance.reference().child('Channels');
  final _communityDB = FirebaseDatabase.instance.reference().child('Chats');
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  late StreamSubscription<Event> _chatListStream;

  List<ChatListModel> get allChatList {
    return _chatList;
  }

  ChatListProvider() {
    _fetchChatList();
  }

  void flushFirstTime() {
    isFirstTime = true;
  }

  int get totalMsgCount {
    return _msgCount;
  }

  _fetchChatList() {
    _chatListStream =
        _chatListDB.child(_auth.currentUser!.uid).onValue.listen((event) {
      if (event.snapshot.value == null) {
        _msgCount = 0;
        _chatList.clear();
        notifyListeners();
      } else {
        _msgCount = 0;
        final _allChatListMap = Map<String, dynamic>.from(event.snapshot.value);
        _chatList = _allChatListMap.values.map((e) {
          //---( Updating Name and Images )---//
          final _chatData = ChatListModel.fromMap(Map<String, dynamic>.from(e));
          if (isFirstTime) {
            if (_chatData.user == _auth.currentUser!.uid) {
              //---( Chats are of Community )---//\
              _communityDB
                  .child(_chatData.chid)
                  .once()
                  .then((DataSnapshot snapshot) {
                final map = Map<String, dynamic>.from(snapshot.value);
                if (_chatData.name != map['chName']) {
                  _chatListDB
                      .child(_auth.currentUser!.uid)
                      .child(_chatData.chid)
                      .child('name')
                      .set(map['chName']);
                }
                if (_chatData.nameImg != map['chImg']) {
                  _chatListDB
                      .child(_auth.currentUser!.uid)
                      .child(_chatData.chid)
                      .child('nameImg')
                      .set(map['chImg']);
                }
              });
            } else {
              //---( Chats are of Direct Messages )---//
              _userDB
                  .child(_chatData.user)
                  .once()
                  .then((DataSnapshot snapshot) {
                final userModel = UserModel.fromMap(snapshot.value);
                if (userModel.firstName + " " + userModel.lastName !=
                    _chatData.name) {
                  _chatListDB
                      .child(_auth.currentUser!.uid)
                      .child(_chatData.chid)
                      .child('name')
                      .set(userModel.firstName + " " + userModel.lastName);
                }
                if (userModel.userImg != _chatData.nameImg) {
                  _chatListDB
                      .child(_auth.currentUser!.uid)
                      .child(_chatData.chid)
                      .child('nameImg')
                      .set(userModel.userImg);
                }
              });
            }
            isFirstTime = false;
          }
          _msgCount += _chatData.msgPen;
          return _chatData;
        }).toList();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _chatListStream.cancel();
    super.dispose();
  }
}
