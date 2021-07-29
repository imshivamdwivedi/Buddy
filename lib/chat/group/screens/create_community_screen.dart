import 'package:buddy/chat/group/screens/community_intial_info_screen.dart';
import 'package:buddy/chat/models/chat_search_provider.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCommunityScreen extends StatefulWidget {
  static const routeName = "/create-community";
  const CreateCommunityScreen({Key? key}) : super(key: key);

  @override
  _CreateCommunityScreenState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  List<FriendsModel> _userList = [];

  void _addUserToList(FriendsModel user) {
    setState(() {
      if (!_userList.contains(user)) {
        _userList.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Community',
        backgroundColor: Colors.black87,
        child: Icon(
          Icons.arrow_forward,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CommunityIntialInfoCreateScreen(users: _userList),
          ));
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "New Community",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _userList.length > 0
                  ? Row(
                      children: [
                        Flexible(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: _userList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      width: 85,
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 5,
                                                    color: Colors.grey,
                                                    spreadRadius: 1)
                                              ],
                                            ),
                                            child: Container(
                                              // margin: EdgeInsets.all(5),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Container(
                                                  child: _userList[index]
                                                              .userImg ==
                                                          ''
                                                      ? NamedProfileAvatar()
                                                          .profileAvatar(
                                                              _userList[index]
                                                                  .name
                                                                  .substring(
                                                                      0, 1),
                                                              60.0)
                                                      : Image.network(
                                                          _userList[index]
                                                              .userImg,
                                                          height: 60.0,
                                                          width: 60.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _userList.removeAt(index);
                                                });
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ));
                                }),
                          ),
                        )
                      ],
                    )
                  : Center(child: Text("Add participant")),
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Consumer<ChatSearchProvider>(
                          builder: (context, value, child) {
                            final friends = value.allFriends;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: friends.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      _addUserToList(friends[index]);
                                    },
                                    child: Container(
                                        width: 85,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 5,
                                                      color: Colors.grey,
                                                      spreadRadius: 1)
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Container(
                                                  child: friends[index]
                                                              .userImg ==
                                                          ''
                                                      ? NamedProfileAvatar()
                                                          .profileAvatar(
                                                              friends[index]
                                                                  .name
                                                                  .substring(
                                                                      0, 1),
                                                              60.0)
                                                      : Image.network(
                                                          friends[index]
                                                              .userImg,
                                                          height: 60.0,
                                                          width: 60.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.05),
                                            Text(
                                              friends[index].name,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
