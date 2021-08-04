import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/dm_channel_model.dart';
import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/chat/screens/dm_chat_screen.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/follower_model.dart';
import 'package:buddy/user/models/following_provider.dart';
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

class UserFollwingViewScreen extends StatefulWidget {
  const UserFollwingViewScreen({Key? key}) : super(key: key);

  @override
  _UserFollwingViewScreenState createState() => _UserFollwingViewScreenState();
}

class _UserFollwingViewScreenState extends State<UserFollwingViewScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final userFollowing = Provider.of<FollowingProvider>(context).allFollowings;
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
            title: Text('Following',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                )),
          ),
        ),
        userFollowing.length > 0
            ? SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final model = userFollowing[index];
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
                                    roundButton('Following', model),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }, childCount: userFollowing.length),
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
                          'You have no Following !',
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

  Widget roundButton(String text, FollowerModel model) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: kPrimaryLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
      child: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
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

  void _unFollowUser(FollowerModel model) {
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
    Navigator.of(context).pop();
  }
}
