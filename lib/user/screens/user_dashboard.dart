import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/textarea.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/calender.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/home.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/notification_screen.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile_screen.dart';
import 'package:buddy/user/screens/user_intial_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserDashBoard extends StatefulWidget {
  static const routeName = 'user-dashboard';

  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  bool init = true;
  final _topicController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

  int currentTab = 0;
  List<Widget> screens = [
    UserHome(),
    UserCalender(),
    UserNotification(),
    UserProfileScreen()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = UserHome();

  _openPopup(context) {
    Alert(
        context: context,
        title: "Create",
        content: Column(
          children: <Widget>[
            RoundedInputField(
              icon: Icons.account_circle,
              text: "Topic",
              val: false,
              controller: _topicController,
            ),
            RoundedInputField(
              icon: Icons.timer_sharp,
              text: "Start Time",
              val: false,
              controller: _startTimeController,
            ),
            RoundedInputField(
              icon: Icons.timer_sharp,
              text: "Date -  dd/mm/yy",
              val: false,
              controller: _startTimeController,
            ),
            TextArea(
                text: "Write description here ... ",
                val: false,
                controller: _descriptionController)
          ],
        ),
        buttons: [
          DialogButton(
            color: kPrimaryProfileColor,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Create",
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
        ]).show();
  }

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
        } else {
          Provider.of<UserProvider>(context, listen: false)
              .updateUserData(UserModel.fromJson(snapshot, _user.uid));
        }
      });
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
          onPressed: () {
            _openPopup(context);
          },
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
