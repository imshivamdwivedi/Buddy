import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/choice.dart';
import 'package:buddy/chat/models/dm_channel_model.dart';
import 'package:buddy/chat/screens/dm_chat_screen.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/home_search_provider.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/user_profile_other.dart';
import 'package:buddy/user/users_connections/connection_handler.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SearchConnectionScreen extends StatefulWidget {
  static const routeName = '/search-connection-screen';
  const SearchConnectionScreen({Key? key}) : super(key: key);

  @override
  _SearchConnectionScreenState createState() => _SearchConnectionScreenState();
}

class _SearchConnectionScreenState extends State<SearchConnectionScreen> {
  final _auth = FirebaseAuth.instance;

  List<Choice> choices = [
    Choice(
        'Buddies',
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
    Choice(
        'Events',
        Container(
          child: Center(
            child: Text("Groups"),
          ),
        )),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<HomeSearchProvider>(context, listen: false).updateQuery('');
    });
  }

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;
    final userData = Provider.of<HomeSearchProvider>(context);
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: TextField(
            onChanged: (value) =>
                Provider.of<HomeSearchProvider>(context, listen: false)
                    .updateQuery(value),
            autofocus: true,
            decoration: InputDecoration(
              focusColor: Colors.black87,
              hintText: 'Search Buddy',
            ),
          ),
          backgroundColor: kPrimaryColor,
          // centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.grey,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: choices.map((Choice choice) {
              return Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Tab(
                  text: choice.title,
                ),
              );
            }).toList(),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: userData.suggestedUsers.length,
                  itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                    value: userData.suggestedUsers[index],
                    child: Consumer<HomeSearchHelper>(
                      builder: (_, user, child) =>
                          userCard(user.userModel, user),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget userCard(UserModel userModel, HomeSearchHelper user) {
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
                  child: userModel.userImg == ''
                      ? NamedProfileAvatar().profileAvatar(
                          userModel.firstName.substring(0, 1), 80.0)
                      : CachedNetworkImage(
                          width: 80.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                          imageUrl: userModel.userImg,
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
                                  userModel.firstName.substring(0, 1), 80.0),
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
                                builder: (context) => OtherUserProfileScreen(
                                  userId: userModel.id,
                                ),
                              ));
                        },
                        child: Text(
                          userModel.firstName + " " + userModel.lastName,
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
                      Text(userModel.collegeName),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 2,
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildSkillChip('Chess'),
                      SizedBox(
                        width: 10,
                      ),
                      _buildChip("4.5"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      roundButton(
                          user.isFriend ? 'Message' : 'Request',
                          user,
                          Provider.of<UserProvider>(context, listen: false)
                              .getUserName)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildSkillChip(
    String label,
  ) {
    return Container(
      width: label.length * 8,
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
          ],
        ),
      ),
    );
  }

  Widget roundButton(String text, HomeSearchHelper user, String userName) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: user.isPending
          ? null
          : () {
              if (user.isFriend) {
                //H://---( Opening Messages )----//
                _createNewDmChannel(user.userModel);
              } else {
                //H://---( Creating Request )----//
                ConnectionHandler().createRequest(_auth.currentUser!.uid,
                    user.userModel.id, context, userName, user);
              }
            },
    );
  }

  void _createNewDmChannel(UserModel model) async {
    //---( Checking if Channel Already Exist )---//
    bool _isNewChannel = true;
    String chidPrev = '';
    final _checkDb = FirebaseDatabase.instance
        .reference()
        .child('Channels')
        .child(_auth.currentUser!.uid);
    await _checkDb
        .orderByChild('user')
        .equalTo(model.id)
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
        users: _auth.currentUser!.uid + "+" + model.id,
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
        name: model.firstName + ' ' + model.lastName,
        nameImg: model.userImg,
        user: model.id,
        msgPen: 0,
        lastMsg: '',
      );
      await _chRecord.set(_channel.toMap());

      final _chRecord1 = FirebaseDatabase.instance
          .reference()
          .child('Channels')
          .child(model.id)
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
                userId: model.id,
              )));
    } else {
      //---( Opening Previous Channel )---//
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) =>
              DmChatScreen(chatRoomId: chidPrev, userId: model.id)));
    }
  }
}
