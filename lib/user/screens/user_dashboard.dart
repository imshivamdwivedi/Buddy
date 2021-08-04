import 'package:buddy/chat/models/chat_list_provider.dart';
import 'package:buddy/chat/models/chat_search_provider.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/notification/model/notification_provider.dart';
import 'package:buddy/notification/screen/notification_screen.dart';
import 'package:buddy/onboarder/onboarder_widget.dart';
import 'package:buddy/user/models/event_provider.dart';
import 'package:buddy/user/models/follower_provider.dart';
import 'package:buddy/user/models/following_provider.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/calender.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/create_activity_screen.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/home.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/screen_helper_provider.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/user_profile_screen_currentuser.dart';
import 'package:buddy/user/screens/user_genre.dart';
import 'package:buddy/user/screens/user_intial_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

class UserDashBoard extends StatefulWidget {
  static const routeName = 'user-dashboard';

  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  bool init = true;
  //final _startTimeController = TextEditingController();
  //final _descriptionController = TextEditingController();
  //final _titleController = TextEditingController();
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

  int currentTab = 0;
  List<Widget> screens = [
    UserHome(),
    UserCalender(),
    UserNotification(),
    UserProfileScreen(),
    OnboarderWidget(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = UserHome();

  // Future<dynamic> _openPopup(context) {
  //   final Size size = MediaQuery.of(context).size;
  //   // return showDialog(
  //   //   context: context,
  //   //   builder: (context) {
  //   //     return StatefulBuilder(
  //   //       builder: (context, setState) {

  //   //       },
  //   //     );
  //   //   },
  //   // );
  // }

  @override
  Widget build(BuildContext context) {
    if (init) {
      final _user = _auth.currentUser;
      final _refUser = _firebaseDatabase.reference().child('Users');
      _refUser
          .orderByChild('id')
          .equalTo(_user!.uid)
          .once()
          .then((DataSnapshot snapshot) {
        if (!snapshot.value[_user.uid]['profile']) {
          Navigator.of(context).pushReplacementNamed(UserIntialInfo.routeName);
          return;
        } else if (snapshot.value[_user.uid]['userGenre'] == '') {
          Navigator.of(context).pushReplacementNamed(UserGenre.routeName);
          return;
        } else {
          if (snapshot.value[_user.uid]['userImg'] != '') {
            DefaultCacheManager()
                .downloadFile(snapshot.value[_user.uid]['userImg'])
                .then((_) {
              print('Caching Image Here !');
            });
          }
        }
      });
      if (Provider.of<ScreenHelperProvider>(context, listen: false)
              .getCurrentTab ==
          1) {
        currentTab = 1;
        currentScreen = UserCalender();
      }
      Provider.of<UserProvider>(context, listen: false);
      Provider.of<ChatSearchProvider>(context, listen: false);
      Provider.of<ChatListProvider>(context, listen: false);
      Provider.of<FollowerProvider>(context, listen: false);
      Provider.of<FollowingProvider>(context, listen: false);
      Provider.of<NotificationProvider>(context, listen: false);
      Provider.of<EventsProvider>(context, listen: false).refresh();
      init = false;
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
            ),
            backgroundColor: Colors.black87,
            // onPressed: () {
            //   showDialog(
            //       context: context,
            //       builder: (_) {
            //         return PopUp();
            //       });
            // },
            onPressed: () {
              setState(() {
                currentScreen = CreateActivityScreen(null);
                currentTab = 5;
              });
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: kPrimaryColor,
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //home
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = UserHome();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentTab == 0 ? Colors.black87 : Colors.grey,
                        ),
                        // Text(
                        //   'Home',
                        //   style: TextStyle(
                        //       color: currentTab == 0 ? Colors.blue : Colors.grey),
                        // )
                      ],
                    ),
                  ),
                ),
                //calender
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = UserCalender();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: currentTab == 1 ? Colors.black87 : Colors.grey,
                        ),
                        // Text(
                        //   'Home',
                        //   style: TextStyle(
                        //       color: currentTab == 1 ? Colors.blue : Colors.grey),
                        // )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                //notification
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = UserNotification();

                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications,
                          color: currentTab == 2 ? Colors.black87 : Colors.grey,
                        ),
                        // Text(
                        //   'Notification',
                        //   style: TextStyle(
                        //       color: currentTab == 2 ? Colors.blue : Colors.grey),
                        // )
                      ],
                    ),
                  ),
                ),
                //profile
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = UserProfileScreen();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentTab == 3 ? Colors.black87 : Colors.grey,
                        ),
                        // Text(
                        //   'Profile',
                        //   style: TextStyle(
                        //       color: currentTab == 3 ? Colors.blue : Colors.grey),
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
