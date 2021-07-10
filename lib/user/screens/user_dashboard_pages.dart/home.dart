import 'package:buddy/chat/screens/user_chat_list.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/searchbar.dart';
import 'package:buddy/components/social_icons.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/widgets/activity_item.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.01),
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SearchBar(
                  icon: Icons.search,
                  text: "Find Buddy ",
                  val: false,
                  controller: _nameController,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(UserChatList.routeName);
                    },
                    icon: Icon(
                      Icons.message,
                      color: Colors.brown,
                    )),
              ],
            ),
          ),
          ActivityItem(),
        ],
      ),
    ));
  }
}
