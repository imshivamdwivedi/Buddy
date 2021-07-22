import 'dart:ui';

import 'package:buddy/constants.dart';
import 'package:buddy/user/models/community.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = "/user-profile";
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<Community> communityList = [
    Community(id: "e1", name: "Love to Build"),
    Community(id: "e2", name: "Udemy"),
    Community(id: "e3", name: "JS lovers"),
    Community(id: "e4", name: "Java Guys"),
    Community(id: "e5", name: "Python"),
  ];

  //static const kListHeight = 150.0;

  // Widget _buildHorizontalList() => SizedBox(
  //       height: kListHeight,
  //       child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: 20,
  //         itemBuilder: (_, index) =>
  //             CTile(heading: 'Hip Hop', subheading: '623 Beats'),
  //       ),
  //     );

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
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            label,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              color: kPrimaryColor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Consumer<UserProvider>(
                          builder: (_, userModel, ch) => ListTile(
                            leading: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                  "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                            ),
                            // title: Text(
                            //   userModel.getUserName(),
                            //   style: Theme.of(context).textTheme.headline6,
                            // ),
                            // subtitle: Text(userModel.getUserCollege()),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Text(
                              "21K",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text("Connections")
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Text(
                              "21",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text("Event")
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Text(
                              "10",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text("Community")
                          ],
                        ),
                      ),
                      // Container(
                      //   child: _buildChip("4.5"),
                      //   margin: EdgeInsets.all(4),
                      // ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                    child: Row(
                      children: [
                        Text(
                          Provider.of<UserProvider>(context).getUserName(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Spacer(),
                        Container(
                          child: _buildChip("4.5"),
                          margin: EdgeInsets.all(4),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "chfhgvcgvcfvcbfcbfcbfhcbhjdbchjdbchjdbjcbdjhcbjhdbchjdbchbd",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width * 0.05,
                        // ),
                        Expanded(
                          child: SizedBox(
                            height: 40.0,
                            child: FloatingActionButton.extended(
                              backgroundColor: kPrimaryLightColor,
                              onPressed: () {},
                              label: Text(
                                "Edit Profile",
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width * 0.05,
                        // ),
                        // ProfileFloatingButton(
                        //   color: kPrimaryLightColor,
                        //   icon: Icons.email,
                        // ),
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width * 0.05,
                        // ),
                        // ProfileFloatingButton(
                        //   color: kPrimaryLightColor,
                        //   icon: Icons.person_add,
                        // ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.8,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    width: 85,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("projects"),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage: AssetImage(
                                              'assets/images/google.png'),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Java")
                                      ],
                                    ));
                              }),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
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
            leading: new Icon(Icons.settings),
            title: new Text('Setting'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.calendar_today),
            title: new Text('Events'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.videocam),
            title: new Text('Video'),
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
            leading: new Icon(Icons.share),
            title: new Text('Share'),
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
        ],
      ),
    );
  }
}
