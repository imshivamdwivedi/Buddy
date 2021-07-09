import 'package:buddy/chat/screens/user_chat_list.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/searchbar.dart';
import 'package:buddy/components/social_icons.dart';
import 'package:buddy/constants.dart';
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
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchBar(
              icon: Icons.search,
              text: "Find Buddy ",
              val: false,
              controller: _nameController,
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(UserChatList.routeName);
                },
                icon: Icon(
                  Icons.message,
                  color: Colors.brown,
                )),
          ],
        )
      ],
    ));
  }
}
