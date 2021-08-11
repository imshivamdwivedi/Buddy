import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/utils/named_profile_avatar.dart';

import 'package:flutter/material.dart';

class GroupMemberScreen extends StatefulWidget {
  List<UserModel> _users;
  GroupMemberScreen(this._users);

  @override
  _GroupMemberScreenState createState() => _GroupMemberScreenState();
}

class _GroupMemberScreenState extends State<GroupMemberScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _showOnlyFavourites = false;

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.black,
          expandedHeight: 100.0,
          floating: false,
          pinned: true,
          iconTheme: IconThemeData(color: Colors.black),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Members',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    )),
                Divider()
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialogMoreOption(context),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  child: widget._users[index].userImg == ''
                                      ? NamedProfileAvatar().profileAvatar(
                                          widget._users[index].firstName
                                              .substring(0, 1),
                                          40.0)
                                      : Image.network(
                                          widget._users[index].userImg,
                                          height: 40.0,
                                          width: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            title: Text(widget._users[index].firstName +
                                " " +
                                widget._users[index].lastName),
                          ),
                        ),
                        Divider()
                      ],
                    ),
                  ),
              childCount: widget._users.length),
        )
      ]),
    );
  }

  Widget _buildPopupDialogMoreOption(BuildContext context) {
    return new AlertDialog(
      backgroundColor: kPrimaryColor,
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(onTap: () {}, child: Text("Visit Profile")),
          SizedBox(
            height: 20,
          ),
          InkWell(onTap: () {}, child: Text("Make Admin")),
          SizedBox(
            height: 20,
          ),
          InkWell(onTap: () {}, child: Text("Remove")),
          SizedBox(
            height: 20,
          ),
          InkWell(onTap: () {}, child: Text("Block"))
        ],
      ),
    );
  }
}
