import 'package:buddy/chat/models/chat_list_provider.dart';
import 'package:buddy/chat/screens/user_chat_list.dart';
import 'package:buddy/components/searchbar.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/models/home_search_provider.dart';
import 'package:buddy/user/screens/connection%20screen/search_connection_screen.dart';
import 'package:buddy/user/widgets/activity_item.dart';
import 'package:buddy/user/widgets/badge.dart';
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
  @override
  void initState() {
    _updateSearch(context);
    super.initState();
  }

  void _updateSearch(BuildContext context) async {
    Provider.of<HomeSearchProvider>(context, listen: false).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: SearchBar(
                        text: 'Find Buddies',
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
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    Consumer<ChatListProvider>(
                      builder: (context, value, child) =>
                          value.totalMsgCount != 0
                              ? Badge(
                                  child: child!,
                                  value: value.totalMsgCount.toString())
                              : child!,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(UserChatList.routeName);
                        },
                        icon: Icon(
                          Icons.message,
                          size: size.height * 0.04,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight + size.height * 0.01),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight +
                  size.height * 0.01 -
                  kBottomNavigationBarHeight,
              child: Consumer<HomeSearchProvider>(
                builder: (_, model, child) => ListView.builder(
                  itemCount: model.allEventsList.length,
                  itemBuilder: (context, index) =>
                      ActivityItem(dataModel: model.allEventsList[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// FirebaseAnimatedList(
//                 query: _refAct,
//                 itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                     Animation<double> animation, int index) {
//                   Map data = snapshot.value;
//                   return ActivityItem(
//                     dataModel: ActivityModel.fromMap(data),
//                   );
//                 },
//               )