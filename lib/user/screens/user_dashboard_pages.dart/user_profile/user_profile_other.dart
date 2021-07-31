import 'dart:ui';

import 'package:buddy/components/profile_floating_button.dart';
import 'package:buddy/components/social_icons.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final userId;
  const OtherUserProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _OtherUserProfileScreenState createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  static const kListHeight = 150.0;
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  UserModel _userModel = new UserModel(profile: true);

  Widget _buildChip(
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Color(0xFFE2DFC5),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        // runSpacing: 10,
        children: <Widget>[
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 18,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    await _userDB.child(widget.userId).once().then((DataSnapshot snapshot) {
      setState(() {
        _userModel = UserModel.fromMap(snapshot.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    context: context,
                    builder: (context) {
                      return BottomSheet();
                    });
              },
              icon: Icon(
                Icons.view_headline,
                color: Colors.black87,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 5, top: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.grey,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: _userModel.userImg == ''
                              ? NamedProfileAvatar().profileAvatar(
                                  _userModel.firstName.substring(0, 1), 80.0)
                              : CachedNetworkImage(
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                  imageUrl: _userModel.userImg,
                                  placeholder: (context, url) {
                                    return Center(
                                        child: new SpinKitWave(
                                      type: SpinKitWaveType.start,
                                      size: 20,
                                      color: Colors.black87,
                                    ));
                                  },
                                  errorWidget: (context, url, error) {
                                    return NamedProfileAvatar().profileAvatar(
                                        _userModel.firstName.substring(0, 1),
                                        80.0);
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                _userModel.firstName +
                                    ' ' +
                                    _userModel.lastName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.lens,
                                color: Colors.green,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                _userModel.collegeName,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [_buildChip('4.5')],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: size.height * 0.02,
                      horizontal: size.width * 0.01),
                  child: Row(
                    children: [
                      Flexible(
                          child: Text(
                        _userModel.userBio,
                      )),
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      height: 40.0,
                      width: MediaQuery.of(context).size.width * 0.6,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: FloatingActionButton.extended(
                        backgroundColor: kPrimaryLightColor,
                        onPressed: () {},
                        label: Text(
                          "Follow",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    ProfileFloatingButton(
                      color: kPrimaryLightColor,
                      icon: Icons.email,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    ProfileFloatingButton(
                      color: kPrimaryLightColor,
                      icon: Icons.person_add,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Communities",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.group,
                            color: Colors.green,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.3,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                width: 85,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 5,
                                              color: Colors.grey,
                                              spreadRadius: 1)
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            'assets/images/elon.jpg'),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('${index}')
                                  ],
                                ));
                          }),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SocalIcon(
                      iconSrc: 'assets/icons/coffee.svg', onPressed: () {}),
                  SocalIcon(iconSrc: 'assets/icons/beer.svg', onPressed: () {}),
                  SocalIcon(
                      iconSrc: 'assets/icons/burger.svg', onPressed: () {}),
                  SocalIcon(iconSrc: 'assets/icons/game.svg', onPressed: () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                height: 5.0,
                width: 40.0,
                color: Colors.black87,
              ),
            ),
          ),
          ListTile(
            leading: new Icon(Icons.block),
            title: new Text('Block'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.report),
            title: new Text('Report'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.copy),
            title: new Text('Copy Profile URL'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.share),
            title: new Text('Share this Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.share),
            title: new Text('Share'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.logout),
            title: new Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
