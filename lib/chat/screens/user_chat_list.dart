import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class UserChatList extends StatefulWidget {
  static const routeName = "/user-message";
  const UserChatList({Key? key}) : super(key: key);

  @override
  _UserChatListState createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: ListTile(
          tileColor: kPrimaryLightColor,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
            radius: 20,
          ),
          title: Text(
            "Hey, How are you ?",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          // subtitle: Text(DateFormat.yMMMEd().format(widget.transaction.date))
        ),
      ),
    ));
  }
}
