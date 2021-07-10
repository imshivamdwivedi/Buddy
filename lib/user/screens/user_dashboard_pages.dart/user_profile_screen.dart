import 'package:buddy/components/profile_floating_button.dart';
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

  static const kListHeight = 150.0;

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
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Color(0xFFE2DFC5),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10,
        children: <Widget>[
          InkWell(
            child: Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          Padding(padding: const EdgeInsets.all(5.0)),
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
      body: Center(
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              color: kPrimaryColor,
              elevation: 5,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<UserProvider>(
                          builder: (_, userModel, ch) => ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                            ),
                            title: Text(
                              userModel.getUserName(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            subtitle: Text(userModel.getUserCollege()),
                          ),
                        ),
                      ),
                      Container(
                        child: _buildChip("4.5"),
                        margin: EdgeInsets.all(4),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
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
                    ],
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
                              itemCount: 50,
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
                                          height: 10,
                                        ),
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage(
                                              'assets/images/google.png'),
                                        ),
                                        SizedBox(
                                          height: 10,
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
