import 'package:buddy/chat/models/group_channel_model.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class GroupDetailProvider with ChangeNotifier {
  var groupChannelModel;
  Map<String, String> _users = {};
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  final _chDB = FirebaseDatabase.instance.reference().child('Chats');

  void fetchGroupDetail(String chatRoomId) async {
    groupChannelModel = null;
    await _chDB.child(chatRoomId).once().then((value) {
      Map map = Map<String, dynamic>.from(value.value);
      final model = GroupChannel.fromMap(map);
      groupChannelModel = model;
      final userList = model.users.split("+");
      userList.forEach((element) {
        _userDB.child(element).once().then((value) {
          final _userModel =
              UserModel.fromMap(Map<String, dynamic>.from(value.value));
          _users[element] = _userModel.firstName + ' ' + _userModel.lastName;
        });
      });
      notifyListeners();
    });
  }

  Map<String, String> get allNames => _users;
  GroupChannel get groupDetail => groupChannelModel;
}
