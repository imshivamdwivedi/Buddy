import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class GroupMessageProviderName with ChangeNotifier {
  Map<String, String> _names = {};
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  final _chDB = FirebaseDatabase.instance.reference().child('Chats');

  Map<String, String> get allNames => _names;

  void fetchGroupName(String chatRoomId) async {
    String _users = '';
    await _chDB.child(chatRoomId).once().then((value) {
      Map map = Map<String, dynamic>.from(value.value);
      _users = map['users'];
      final _allUsers = _users.split('+');
      _allUsers.forEach((element) {
        _userDB.child(element).once().then((value) {
          final _userModel =
              UserModel.fromMap(Map<String, dynamic>.from(value.value));
          _names[element] = _userModel.firstName + ' ' + _userModel.lastName;
        });
      });
      notifyListeners();
    });
  }
}
