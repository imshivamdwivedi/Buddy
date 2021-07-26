import 'package:buddy/chat/models/chat_list_provider.dart';
import 'package:buddy/chat/screens/user_chat_list.dart';
import 'package:buddy/components/searchbar.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/models/home_search_provider.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/user/screens/connection%20screen/search_connection_screen.dart';
import 'package:buddy/user/widgets/activity_item.dart';
import 'package:buddy/utils/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // final _nameController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  Query _refAct = FirebaseDatabase.instance.reference().child('Activity');

  @override
  void initState() {
    _updateSearch(context);
    super.initState();
  }

  void _updateSearch(BuildContext context) async {
    final _user = _auth.currentUser;
    final List<String> friendsId = [];
    friendsId.add(_user!.uid);
    final List<String> requestsId = [];
    final _friendsDB =
        FirebaseDatabase.instance.reference().child('Friends').child(_user.uid);
    await _friendsDB.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          friendsId.add(element['uid']);
        });
      }
    });
    final _requestDB = FirebaseDatabase.instance
        .reference()
        .child('Requests')
        .child(_user.uid);
    await _requestDB.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          requestsId.add(element['uid']);
        });
      }
    });
    final List<HomeSearchHelper> allUsersList = [];
    final _searchDB = FirebaseDatabase.instance.reference().child('Users');
    await _searchDB.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map map = snapshot.value;
        map.values.forEach((element) {
          if (!friendsId.contains(element['id'])) {
            final userM = UserModel.fromMap(element);
            final homeU = HomeSearchHelper(
                userModel: userM, isFriend: requestsId.contains(userM.id));
            allUsersList.add(homeU);
          }
        });
      }
    });
    Provider.of<HomeSearchProvider>(context, listen: false)
        .setAllUsers(allUsersList);
  }

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Container(
                        child: SearchBar(
                          text: 'Search buddies',
                          icon: Icons.search,
                          val: true,
                          func: () {
                            Navigator.of(context)
                                .pushNamed(SearchConnectionScreen.routeName)
                                .then((_) {
                              _updateSearch(context);
                            });
                          },
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      // Navigator.of(context)
                      //     .pushNamed(SearchConnectionScreen.routeName)
                      //     .then((_) {
                      //   _updateSearch(context);
                      // });
                      //   },
                      //   icon: Icon(
                      //     Icons.search,
                      //     color: Colors.black87,
                      //   ),
                      // ),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      IconButton(
                        onPressed: () {
                          // showDialog(
                          //   barrierDismissible: false,
                          //   context: context,
                          //   builder: (context) =>
                          //       new CustomLoader().buildLoader(context),
                          // );

                          Navigator.of(context)
                              .pushNamed(UserChatList.routeName);

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => ChangeNotifierProvider(
                          //       create: (ctx) => ChatListProvider(),
                          //       child: UserChatList(),
                          //     ),
                          //   ),
                          // );
                        },
                        icon: Icon(
                          Icons.message,
                          size: size.height * 0.05,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
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
