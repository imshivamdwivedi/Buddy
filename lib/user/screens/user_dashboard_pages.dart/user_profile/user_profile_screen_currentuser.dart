import 'dart:ui';

import 'package:buddy/chat/screens/group_detail_screen.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/update_screens/avatar_bottom_sheet.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/connection_view_screen.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/update_screens/community_view_screen.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/update_screens/update_bio.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/update_screens/update_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = "/user-profile-current";
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
    Size size = MediaQuery.of(context).size;
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
          margin: EdgeInsets.only(top: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              color: kPrimaryColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Consumer<UserProvider>(
                          builder: (_, userModel, ch) => InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        child: AvatarBottomSheet());
                                  });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: Container(
                                height: 110.0,
                                width: 110.0,
                                child: Image.asset(
                                  'assets/images/elon.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // subtitle: Text(userModel.getUserCollege()),
                            ),
                          ),
                        ),
                      ),
                      //  Container(
                      //   margin: EdgeInsets.only(right: 5),
                      //   padding: EdgeInsets.symmetric(horizontal: 5),
                      //   child: Row(
                      //     children: [
                      //       ProfileFloatingButton(
                      //         color: kPrimaryLightColor,
                      //         icon: Icons.email,
                      //       ),
                      //       SizedBox(
                      //         width: MediaQuery.of(context).size.width * 0.05,
                      //       ),
                      //       ProfileFloatingButton(
                      //         color: kPrimaryLightColor,
                      //         icon: Icons.person_add,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   height: 40.0,
                      //   margin: EdgeInsets.symmetric(horizontal: 5),
                      //   child: FloatingActionButton.extended(
                      //     backgroundColor: kPrimaryLightColor,
                      //     onPressed: () {},
                      //     label: Text(
                      //       "Edit Profile",
                      //       style: TextStyle(color: Colors.black87),
                      //     ),
                      //   ),
                      // ),

                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 5),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         "21K",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold, fontSize: 18),
                      //       ),
                      //       Text("Connections")
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 5),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         "21",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold, fontSize: 18),
                      //       ),
                      //       Text("Event")
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 5),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         "10",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold, fontSize: 18),
                      //       ),
                      //       Text("Community")
                      //     ],
                      //   ),
                      // ),
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateName()),
                            );
                          },
                          child: Text(
                            Provider.of<UserProvider>(context).getUserName(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.lens,
                          color: Colors.green,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.01),
                      child: Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => updateBioScreen()),
                                );
                              },
                              child: Text(
                                "Wait to watch me fall, Cause I'am not going down easily ",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width * 0.05,
                        // ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserConnectionViewScreen()),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "21",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Connections",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                          ),
                        ),

                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CommunityViewScreen()),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  "10",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Community",
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   child: _buildChip("4.5"),
                        //   margin: EdgeInsets.all(4),
                        // ),
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width * 0.05,
                        // ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              _buildChip("4.5"),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.calendar_today_rounded),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Joined Nov 2013",
                                  style: TextStyle(fontSize: 16))
                            ],
                          ),
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
                                "Member of Communities",
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
                  Row(
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.8,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 2,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    width: 50,
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GroupDetailScreen()),
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage(
                                                'assets/images/elon.jpg'),
                                          ),
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
