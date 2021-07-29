import 'package:buddy/chat/group/screens/create_community_screen.dart';
import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/chat_list_provider.dart';
import 'package:buddy/chat/models/chat_search_provider.dart';
import 'package:buddy/chat/models/choice.dart';
import 'package:buddy/chat/models/dm_channel_model.dart';
import 'package:buddy/chat/screens/dm_chat_screen.dart';
import 'package:buddy/chat/screens/group_chat_screen.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
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
      await _channelDb.child(_chid).set(newChannel.toMap());

      //---( Creating Channel History )---//
      final _chRecord = FirebaseDatabase.instance
          .reference()
          .child('Channels')
          .child(_auth.currentUser!.uid)
          .child(_chid);
      final _channel = ChatListModel(
        chid: _chid,
        name: model.name,
        nameImg: model.userImg,
        user: model.uid,
        msgPen: 0,
        lastMsg: '',
      );
      await _chRecord.set(_channel.toMap());

      final _chRecord1 = FirebaseDatabase.instance
          .reference()
          .child('Channels')
          .child(model.uid)
          .child(_chid);
      final _channel1 = ChatListModel(
        chid: _chid,
        name: tempNameProvider.getUserName,
        nameImg: tempNameProvider.getUserImg,
        user: _auth.currentUser!.uid,
        msgPen: 0,
        lastMsg: '',
      );
      await _chRecord1.set(_channel1.toMap());

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
                height: 80,
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
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  child: _chatTile.nameImg == ''
                                      ? NamedProfileAvatar().profileAvatar(
                                          _chatTile.name.substring(0, 1), 40.0)
                                      : Image.network(
                                          _chatTile.nameImg,
                                          height: 40.0,
                                          width: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              title: Text(
                                _chatTile.name,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                              subtitle: _chatTile.lastMsg != ''
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          _chatTile.lastMsg,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                              fontWeight: _chatTile.msgPen > 0
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                      ],
                                    )
                                  : null,
                              trailing: _chatTile.msgPen > 0
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      padding: EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.red,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 20,
                                        minHeight: 20,
                                      ),
                                      child: Center(
                                        child: Text(
                                          _chatTile.msgPen.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
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
