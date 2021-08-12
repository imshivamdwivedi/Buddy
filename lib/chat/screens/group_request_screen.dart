import 'package:buddy/chat/widgets/group_request_tile.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

_GroupRequestScreenState? myState;

class GroupRequestScreen extends StatefulWidget {
  final String requestString;
  final String chId;
  GroupRequestScreen(
      {Key? key, required this.requestString, required this.chId})
      : super(key: key);

  @override
  _GroupRequestScreenState createState() {
    myState = _GroupRequestScreenState();
    return myState!;
  }
}

class _GroupRequestScreenState extends State<GroupRequestScreen> {
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    final _userRequests = widget.requestString.trim().split('+');
    _userRequests.forEach((element) {
      if (element != '') {
        _userDB.child(element).once().then((value) {
          setState(() {
            _users.add(UserModel.fromMap(value.value));
          });
        });
      }
    });
  }

  void removeItem(UserModel model) {
    setState(() {
      _users.remove(model);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          'Requests',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext context, int index) {
                return GroupRequesttile(
                    userModel: _users[index], chId: widget.chId);
              },
            ),
          )
        ],
      ),
    );
  }
}
