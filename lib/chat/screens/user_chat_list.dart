import 'package:buddy/chat/group/screens/create_community_screen.dart';
import 'package:buddy/chat/models/chat_list_provider.dart';
import 'package:buddy/chat/models/chat_search_provider.dart';
import 'package:buddy/chat/models/choice.dart';
import 'package:buddy/chat/models/dm_channel_model.dart';
import 'package:buddy/chat/screens/dm_chat_screen.dart';
import 'package:buddy/chat/screens/group_chat_screen.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/notification/model/friends_model.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class UserChatList extends StatefulWidget {
  static const routeName = "/user-message";
  const UserChatList({Key? key}) : super(key: key);

  @override
  _UserChatListState createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() async {
    List<FriendsModel> myFriendList = [];
    final user = _auth.currentUser;
    final _friendsDB =
        FirebaseDatabase.instance.reference().child('Friends').child(user!.uid);
    await _friendsDB.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          final model = FriendsModel.fromMap(element);
          final _userDb = FirebaseDatabase.instance.reference().child('Users');
          _userDb.orderByChild('id').equalTo(model.uid).once().then((value) {
            Map map = value.value;
            map.values.forEach((element) {
              final user = UserModel.fromMap(element);
              model.name = user.firstName + " " + user.lastName;
            });
          });
          myFriendList.add(model);
        });
      }
    });
    Provider.of<ChatSearchProvider>(context, listen: false)
        .setFriendsList(myFriendList);
  }

  void _createNewDmChannel(FriendsModel model) async {
    //---( Checking if Channel Already Exist )---//
    bool _isNewChannel = true;
    String chidPrev = '';
    final _checkDb = FirebaseDatabase.instance
        .reference()
        .child('Channels')
        .child(_auth.currentUser!.uid);
    await _checkDb
        .orderByChild('user')
        .equalTo(model.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        _isNewChannel = false;
        print(_isNewChannel);
        Map map = snapshot.value;
        map.values.forEach((element) {
          chidPrev = element['chid'];
        });
      }
    });
    if (_isNewChannel) {
      final tempNameProvider =
          Provider.of<UserProvider>(context, listen: false);
      //---( Creating New Channel )---//
      final _channelDb = FirebaseDatabase.instance.reference().child('Chats');
      final _chid = _channelDb.push().key;
      final newChannel = DmChannel(
        chid: _chid,
        type: 'DM',
        users: _auth.currentUser!.uid + "+" + model.uid,
      );
      _channelDb.child(_chid).set(newChannel.toMap());

      //---( Creating Channel History )---//
      final _chRecord = FirebaseDatabase.instance
          .reference()
          .child('Channels')
          .child(_auth.currentUser!.uid)
          .child(_chid);
      _chRecord.child('chid').set(_chid);
      _chRecord.child('user').set(model.uid);
      _chRecord.child('name').set(model.name);

      final _chRecord1 = FirebaseDatabase.instance
          .reference()
          .child('Channels')
          .child(model.uid)
          .child(_chid);
      _chRecord1.child('chid').set(_chid);
      _chRecord1.child('user').set(_auth.currentUser!.uid);
      _chRecord1.child('name').set(tempNameProvider.getUserName);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => DmChatScreen(
                chatRoomId: _chid,
                userId: model.uid,
              )));
    } else {
      //---( Opening Previous Channel )---//
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) =>
              DmChatScreen(chatRoomId: chidPrev, userId: model.uid)));
    }
  }

  List<Choice> choices = [
    Choice(
        'Chats',
        Container(
          child: Center(child: Text("DMS")),
        )),
    Choice(
        'Communities',
        Container(
          child: Center(
            child: Text("Groups"),
          ),
        )),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          tooltip: 'Create Community',
          backgroundColor: Colors.black87,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(CreateCommunityScreen.routeName);
          },
        ),
        appBar: new TabBar(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: choices.map((Choice choice) {
            return Container(
              margin: EdgeInsets.only(top: 50),
              child: Tab(
                text: choice.title,
              ),
            );
          }).toList(),
        ),
        body: Column(children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TypeAheadField<FriendsModel>(
              debounceDuration: Duration(microseconds: 500),
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  focusColor: Colors.black87,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search User name',
                ),
              ),
              suggestionsCallback: UserAPI.getUserSuggestion,
              itemBuilder: (context, FriendsModel? suggestions) {
                final friend = suggestions!;
                return ListTile(
                  onTap: () => _createNewDmChannel(friend),
                  title: Text(friend.name),
                );
              },
              noItemsFoundBuilder: (context) => Container(
                height: 100,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No User found",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              onSuggestionSelected: (FriendsModel? suggestions) {
                final friend = suggestions;

                Text(friend!.name);
              },
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Consumer<ChatListProvider>(
                builder: (context, value, child) {
                  if (value.allChatList.isEmpty) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/nonewnot.png",
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              'No Messages Yet !',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      height: 600,
                      child: ListView.builder(
                        itemCount: value.allChatList.length,
                        itemBuilder: (context, index) {
                          final _chatTile = value.allChatList[index];
                          return Container(
                            margin:
                                EdgeInsets.only(left: 5, right: 5, bottom: 5),
                            child: ListTile(
                              onTap: () {
                                if (_chatTile.user != _auth.currentUser!.uid) {
                                  //---( Opening Previous Channel )---//
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => DmChatScreen(
                                          chatRoomId: _chatTile.chid,
                                          userId: _chatTile.user),
                                    ),
                                  );
                                } else {
                                  //---( starting group chat )---//
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => GroupChatScreen(
                                          chatRoomId: _chatTile.chid),
                                    ),
                                  );
                                }
                              },
                              tileColor: kPrimaryLightColor,
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                                radius: 20,
                              ),
                              title: Text(
                                _chatTile.name,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
