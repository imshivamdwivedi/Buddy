import 'package:buddy/chat/models/chat_list_provider.dart';
import 'package:buddy/chat/models/chat_search_provider.dart';
import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/chat/screens/dm_chat_screen.dart';
import 'package:buddy/chat/screens/group_chat_screen.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SharePost extends StatefulWidget {
  const SharePost({Key? key}) : super(key: key);

  @override
  _SharePostState createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        actions: [TextButton(onPressed: () {}, child: Text("Send"))],
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
        child: Container(
          height: size.height - kToolbarHeight,
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(10),
              child: TypeAheadField<FriendsModel>(
                debounceDuration: Duration(microseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    focusColor: Colors.black87,
                    prefixIcon: Icon(Icons.search),
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
                  height: 80,
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
                onSuggestionSelected: (FriendsModel? suggestions) {
                  final friend = suggestions;

                  Text(friend!.name);
                },
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                ),
                child: Consumer<ChatListProvider>(
                  builder: (context, value, child) {
                    if (value.allChatList.isEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/nonewnot.png",
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                'No Messages Yet !',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        height: 600,
                        child: ListView.builder(
                          itemCount: value.allChatList.length,
                          itemBuilder: (context, index) {
                            final _chatTile = value.allChatList[index];
                            return Container(
                              margin:
                                  EdgeInsets.only(left: 5, right: 5, bottom: 5),
                              child: ListTile(
                                  tileColor: kPrimaryColor,
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      child: _chatTile.nameImg == ''
                                          ? NamedProfileAvatar().profileAvatar(
                                              _chatTile.name.substring(0, 1),
                                              40.0)
                                          : Image.network(
                                              _chatTile.nameImg,
                                              height: 40.0,
                                              width: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  title: Text(
                                    _chatTile.name,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                  ),
                                  trailing: Radio(
                                    value: 2,
                                    groupValue: 1,
                                    activeColor: Colors.pink,
                                    onChanged: (value) {},
                                  )),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ]),
        ),
      )),
    );
  }
}
