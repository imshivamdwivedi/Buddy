import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          Provider.of<UserProvider>(context, listen: false).getUserName(),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(10),
          child: TypeAheadField<UserModel>(
            debounceDuration: Duration(microseconds: 500),
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                focusColor: Colors.black87,
                prefixIcon: Icon(Icons.search),
                hintText: 'Search User name',
              ),
            ),
            suggestionsCallback: UserAPI.getUserSuggestion,
            itemBuilder: (context, UserModel? suggestions) {
              final user = suggestions!;
              return ListTile(
                onTap: () {},
                title: Text(user.firstName + " " + user.lastName),
              );
            },
            noItemsFoundBuilder: (context) => Container(
              height: 100,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No User found",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            onSuggestionSelected: (UserModel? suggestions) {
              final user = suggestions;

              Text(user!.firstName + " " + user.lastName);
            },
          ),
        ),
      ]),
      // body: Container(
      //   margin: EdgeInsets.only(
      //     top: MediaQuery.of(context).size.height * 0.03,
      //   ),
      //   child: ListTile(
      //     onTap: () {
      //       Navigator.of(context).pushNamed(DmChatScreen.routeName);
      //     },
      //     tileColor: kPrimaryLightColor,
      //     leading: CircleAvatar(
      //       backgroundImage: NetworkImage(
      //           "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
      //       radius: 20,
      //     ),
      //     title: Text(
      //       "Chat With Me !",
      //       style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      //     ),
      //   ),
    );
  }
}
