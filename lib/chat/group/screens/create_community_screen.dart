import 'package:buddy/chat/group/screens/community_intial_info_screen.dart';
import 'package:buddy/chat/models/chat_search_provider.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/notification/model/friends_model.dart';
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
                            height: MediaQuery.of(context).size.width * 0.3,
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
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundImage: AssetImage(
                                                    'assets/images/elon.jpg'),
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
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
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
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundImage: AssetImage(
                                                'assets/images/elon.jpg'),
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
            ],
          ),
        ),
      ),
    );
  }
}
