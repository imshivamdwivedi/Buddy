import 'package:buddy/constants.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/calender.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/home.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/notification.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/profile.dart';
import 'package:flutter/material.dart';

class UserDashBoard extends StatefulWidget {
  const UserDashBoard({Key? key}) : super(key: key);

  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  int currentTab = 0;
  List<Widget> screens = [
    UserHome(),
    UserCalender(),
    UserNotification(),
    UserProfile()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = UserHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.black87,
          onPressed: () {},
        ),
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
                MaterialButton(
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
                //calender
                MaterialButton(
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
                //notification
                MaterialButton(
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
                //profile
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = UserProfile();
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
              ],
            ),
          ),
        ));
  }
}
