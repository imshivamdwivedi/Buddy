import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/chat_search_provider.dart';
import 'package:buddy/chat/models/dm_channel_model.dart';
import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/chat/screens/dm_chat_screen.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/follower_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/user_profile_other.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserConnectionViewScreen extends StatefulWidget {
  const UserConnectionViewScreen({Key? key}) : super(key: key);

  @override
  _UserConnectionViewScreenState createState() =>
      _UserConnectionViewScreenState();
}

class _UserConnectionViewScreenState extends State<UserConnectionViewScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final userConnections = Provider.of<ChatSearchProvider>(context).allFriends;
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.black,
          floating: false,
          pinned: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text('Connections',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                )),
          ),
        ),
        userConnections.length > 0
            ? SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final model = userConnections[index];
                  return Card(
                    color: kPrimaryColor,
                    elevation: 5,
                    margin: EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                child: model.userImg == ''
                                    ? NamedProfileAvatar().profileAvatar(
                                        model.name.substring(0, 1), 80.0)
                                    : CachedNetworkImage(
                                        width: 80.0,
                                        height: 80.0,
                                        fit: BoxFit.cover,
                                        imageUrl: model.userImg,
                                        placeholder: (context, url) {
                                          return Container(
                                            color: Colors.grey,
                                            child: Center(
                                                child: new SpinKitWave(
                                              type: SpinKitWaveType.start,
                                              size: 20,
                                              color: Colors.black87,
                                            )),
                                          );
                                        },
                                        errorWidget: (context, url, error) =>
                                            NamedProfileAvatar().profileAvatar(
                                                model.name.substring(0, 1),
                                                80.0),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OtherUserProfileScreen(
                                                userId: model.uid,
                                              ),
                                            ));
                                      },
                                      child: Text(
                                        model.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(model.collegeName),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  children: [
                                    _buildChip("4.5"),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1),
                                    roundButton('Message', model),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    roundButton('Remove', model),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }, childCount: userConnections.length),
              )
            : SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/Connections.png",
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      Center(
                        child: Text(
                          'You have no Connection !',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              )
      ]),
    );
  }

  Widget roundButton(String text, FriendsModel model) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: text == 'Following' ? kPrimaryLightColor : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
      child: Text(
        text,
        style:
            TextStyle(color: text == 'Following' ? Colors.black : Colors.white),
      ),
      onPressed: () {
        if (text == 'Message') {
          _createNewDmChannel(model);
        } else if (text == 'Remove') {
          _removeConnection(model);
        }
      },
    );
  }

  Widget _buildChip(
    String label,
  ) {
    return Container(
      width: label.length * 14,
      height: 20,
      decoration: BoxDecoration(
        color: Color(0xFFE2DFC5),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(fontSize: 12),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 1.0)),
            InkWell(
              child: Icon(
                Icons.star,
                color: Colors.amber,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
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

  _removeConnection(FriendsModel model) {
    //---( Removing Connection From Both Trees )---//
    final _rmFriendDB = FirebaseDatabase.instance.reference().child('Friends');
    _rmFriendDB.child(_auth.currentUser!.uid).child(model.fid).set(null);
    _rmFriendDB.child(model.uid).child(model.fid).set(null);

    //---( Removing Dm Chats Between Them )---//
    final _chatDB = FirebaseDatabase.instance.reference().child('Chats');
    final _chDB = FirebaseDatabase.instance.reference().child('Channels');
    _chDB
        .child(_auth.currentUser!.uid)
        .orderByChild('user')
        .equalTo(model.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          final _chatModel = ChatListModel.fromMap(element);
          final _chid = _chatModel.chid;
          _chDB.child(_auth.currentUser!.uid).child(_chid).set(null);
          _chDB.child(model.uid).child(_chid).set(null);
          _chatDB.child(_chid).set(null);
        });
      }
    });

    //---( Clearing Followings List )---//
    final _followingList =
        FirebaseDatabase.instance.reference().child('Following');
    _followingList
        .child(_auth.currentUser!.uid)
        .orderByChild('uid')
        .equalTo(model.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          final _tempModel = FollowerModel.fromMap(element);
          _followingList
              .child(_auth.currentUser!.uid)
              .child(_tempModel.foid)
              .set(null);
        });
      }
    });

    _followingList
        .child(model.uid)
        .orderByChild('uid')
        .equalTo(_auth.currentUser!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          final _tempModel = FollowerModel.fromMap(element);
          _followingList.child(model.uid).child(_tempModel.foid).set(null);
        });
      }
    });

    //---( Clearing Followers List )---//
    final _followerList =
        FirebaseDatabase.instance.reference().child('Followers');
    _followerList
        .child(_auth.currentUser!.uid)
        .orderByChild('uid')
        .equalTo(model.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          final _tempModel = FollowerModel.fromMap(element);
          _followerList
              .child(_auth.currentUser!.uid)
              .child(_tempModel.foid)
              .set(null);
        });
      }
    });

    _followerList
        .child(model.uid)
        .orderByChild('uid')
        .equalTo(_auth.currentUser!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          final _tempModel = FollowerModel.fromMap(element);
          _followerList.child(model.uid).child(_tempModel.foid).set(null);
        });
      }
    });
  }
}
