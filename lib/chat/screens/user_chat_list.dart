import 'package:buddy/chat/models/chat_search_provider.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/notification/model/friends_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    _loadFriends();
    super.initState();
  }

  void _loadFriends() async {
    List<FriendsModel> myFriendList = [];
    final user = _auth.currentUser;
    final _friendsDB = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(user!.uid)
        .child('Friends');
    await _friendsDB.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        print(snapshot.value);
        Map map = snapshot.value;
        map.values.forEach((element) {
          myFriendList.add(FriendsModel.fromMap(element));
        });
      }
    });
    Provider.of<ChatSearchProvider>(context, listen: false)
        .setFriendsList(myFriendList);
    print(myFriendList.length);
    print(Provider.of<UserProvider>(context, listen: false).getUserName());
  }

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
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          padding: EdgeInsets.all(20),
          child: TypeAheadField<FriendsModel>(
            debounceDuration: Duration(microseconds: 500),
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                focusColor: Colors.black87,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
                hintText: 'Search User name',
              ),
            ),
            suggestionsCallback: UserAPI.getUserSuggestion,
            itemBuilder: (context, FriendsModel? suggestions) {
              final friend = suggestions!;
              return ListTile(
                onTap: () {},
                title: Text(friend.name),
              );
            },
            noItemsFoundBuilder: (context) => Container(
              height: 100,
              child: Center(
                child: Container(
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
            ),
            onSuggestionSelected: (FriendsModel? suggestions) {
              final friend = suggestions;

              Text(friend!.name);
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
