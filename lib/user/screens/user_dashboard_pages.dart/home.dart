import 'package:buddy/chat/screens/user_chat_list.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/searchbar.dart';
import 'package:buddy/components/social_icons.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/screens/connection%20screen/search_connection_screen.dart';
import 'package:buddy/user/widgets/activity_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // final _nameController = TextEditingController();
  Query _refAct = FirebaseDatabase.instance.reference().child('Activity');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.01),
            padding: EdgeInsets.all(10),
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: size.height * 0.02,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Buddy",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 24),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(SearchConnectionScreen.routeName);
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(UserChatList.routeName);
                          },
                          icon: Icon(
                            Icons.message,
                            color: Colors.black87,
                          )),
                    ],
                  )),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: FirebaseAnimatedList(
              query: _refAct,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map data = snapshot.value;
                return ActivityItem(
                  dataModel: ActivityModel.fromMap(data),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
