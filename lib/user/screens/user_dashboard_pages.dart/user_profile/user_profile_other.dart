import 'dart:ui';

import 'package:buddy/components/profile_floating_button.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/setting_modal_bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileOtherScreen extends StatefulWidget {
  static const routeName = "/user-profile-other";
  const UserProfileOtherScreen({Key? key}) : super(key: key);

  @override
  _UserProfileOtherScreenState createState() => _UserProfileOtherScreenState();
}

class _UserProfileOtherScreenState extends State<UserProfileOtherScreen> {
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
                      return SettingBottomSheet();
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
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Consumer<UserProvider>(
                          builder: (_, userModel, ch) => ListTile(
                            leading: InkWell(
                              onTap: () {
                                print("hello");
                              },
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                              ),
                            ),

                            // subtitle: Text(userModel.getUserCollege()),
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(right: 5),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            ProfileFloatingButton(
                              color: kPrimaryLightColor,
                              icon: Icons.email,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            ProfileFloatingButton(
                              color: kPrimaryLightColor,
                              icon: Icons.person_add,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            ProfileFloatingButton(
                              color: kPrimaryLightColor,
                              icon: Icons.person_add_disabled,
                            ),
                          ],
                        ),
                      ),

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
                            print("name Upadte");
                          },
                          child: Text(
                            "Shivam Dwivedi from other universe",
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
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 2),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "Wait to watch me fall, Cause I'am not going down easily ",
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
                        InkWell(
                          onTap: () {
                            print("Show Connections");
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
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
                          child: Row(
                            children: [
                              Text(
                                "10",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Community", style: TextStyle(fontSize: 16))
                            ],
                          ),
                        ),
                        // Container(
                        //   child: _buildChip("4.5"),
                        //   margin: EdgeInsets.all(4),
                        // ),
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width * 0.05,
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
                                return InkWell(
                                  onTap: () {
                                    print(index);
                                  },
                                  child: Container(
                                      width: 50,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage(
                                                'assets/images/elon.jpg'),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("Java")
                                        ],
                                      )),
                                );
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
