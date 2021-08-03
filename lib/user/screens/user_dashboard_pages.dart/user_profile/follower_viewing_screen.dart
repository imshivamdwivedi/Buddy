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

class UserFollowerViewScreen extends StatefulWidget {
  const UserFollowerViewScreen({Key? key}) : super(key: key);

  @override
  _UserFollowerViewScreenState createState() => _UserFollowerViewScreenState();
}

class _UserFollowerViewScreenState extends State<UserFollowerViewScreen> {
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
                                    roundButton(
                                        model.isFollowing
                                            ? 'Following'
                                            : 'Follow',
                                        model),
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
        } else if (text == 'Following') {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Are you sure you want to unfollow ${model.name} !'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    _unFollowUser(model);
                  },
                  child: Text('Yes'),
                ),
              ],
              elevation: 16.0,
            ),
          );
        } else if (text == 'Follow') {
          _followUser(model);
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

  void _unFollowUser(FriendsModel model) {
    //---( Unfollowing from Following tree )---//
    final _unfollowDB =
        FirebaseDatabase.instance.reference().child('Following');
    _unfollowDB
        .child(_auth.currentUser!.uid)
        .orderByChild('uid')
        .equalTo(model.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          final followModel = FollowerModel.fromMap(element);
          _unfollowDB
              .child(_auth.currentUser!.uid)
              .child(followModel.foid)
              .set(null);
        });
      }
    });
    //---( Unfollowing from Followers tree )---//
    final _unfollowFDB =
        FirebaseDatabase.instance.reference().child('Followers');
    _unfollowFDB
        .child(model.uid)
        .orderByChild('uid')
        .equalTo(_auth.currentUser!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          final followModel = FollowerModel.fromMap(element);
          _unfollowFDB.child(model.uid).child(followModel.foid).set(null);
        });
      }
    });
    //---( Unfollowing from Friends Tree )---//
    final _unfollowConnection = FirebaseDatabase.instance
        .reference()
        .child('Friends')
        .child(_auth.currentUser!.uid);
    _unfollowConnection.child(model.fid).child('isFollowing').set(false);
    Navigator.of(context).pop();
  }

  void _followUser(FriendsModel model) {
    //---( Following from Following tree )---//
    final _followDB = FirebaseDatabase.instance
        .reference()
        .child('Following')
        .child(_auth.currentUser!.uid);
    final _foid = _followDB.push().key;
    final followModel = FollowerModel(
      name: model.name,
      foid: _foid,
      uid: model.uid,
      userImg: model.userImg,
    );
    _followDB.child(_foid).set(followModel.toMap());
    //---( Following from Followers tree )---//
    final userCurrent = Provider.of<UserProvider>(context, listen: false);
    final _followFDB = FirebaseDatabase.instance
        .reference()
        .child('Followers')
        .child(model.uid);
    final _ffoid = _followFDB.push().key;
    final followFModel = FollowerModel(
      name: userCurrent.getUserName,
      foid: _ffoid,
      uid: userCurrent.getUserId,
      userImg: userCurrent.getUserImg,
    );
    _followFDB.child(_ffoid).set(followFModel.toMap());
    //---( Following from Friends Tree )---//
    final _unfollowConnection = FirebaseDatabase.instance
        .reference()
        .child('Friends')
        .child(_auth.currentUser!.uid);
    _unfollowConnection.child(model.fid).child('isFollowing').set(true);
  }
}
