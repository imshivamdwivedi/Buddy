import 'dart:async';
import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class ChatListProvider with ChangeNotifier {
  List<ChatListModel> _chatList = [];
  final _auth = FirebaseAuth.instance;
  final _chatListDB = FirebaseDatabase.instance.reference();
  late StreamSubscription<Event> _chatListStream;

  List<ChatListModel> get allChatList {
    return _chatList;
  }

  ChatListProvider() {
    _fetchChatList();
  }

  _fetchChatList() {
    _chatListStream = _chatListDB
        .child('Channels')
        .child(_auth.currentUser!.uid)
        .onValue
        .listen((event) {
      if (event.snapshot.value == null) {
        _chatList.clear();
        notifyListeners();
      } else {
        final _allChatListMap = Map<String, dynamic>.from(event.snapshot.value);
        _chatList = _allChatListMap.values
            .map((e) => ChatListModel.fromMap(Map<String, dynamic>.from(e)))
            .toList();
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
