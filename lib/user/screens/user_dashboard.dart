import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/textarea.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/calender.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/home.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/notification_screen.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

class UserDashBoard extends StatefulWidget {
  static const routeName = 'user-dashboard';

  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  final _titleController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  late TimeOfDay _selectedTime = TimeOfDay.now();

  void _birthDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1970),
            lastDate: DateTime(2011))
        .then((datePicked) {
      if (datePicked == null) {
        return;
      }
      setState(() {
        _selectedDate = datePicked;
      });
      print(_selectedDate);
    });
  }

  void _birthTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((timePicked) {
      if (timePicked == null) {
        return;
      }
      setState(() {
        _selectedTime = timePicked;
      });
      print(_selectedTime);
    });
  }

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
        content: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: "Title",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                cursorColor: Colors.black87,
                controller: _titleController,
                autofocus: true,
              ),
              Row(
                children: [
                  Text(
                    "From:",
                    style: TextStyle(fontSize: 12),
                  ),
                  Expanded(
                      child: TextButton(
                    // ignore: unnecessary_null_comparison
                    child: Text(_selectedDate == null
                        ? "From"
                        : "${DateFormat.yMd().format(_selectedDate)}"),
                    onPressed: _birthDatePicker,
                  )),
                  Text(
                    "Time:",
                    style: TextStyle(fontSize: 12),
                  ),
                  Expanded(
                      child: TextButton(
                    child:
                        // ignore: unnecessary_null_comparison
                        Text(_selectedTime == null
                            ? "From"
                            : _selectedTime.toString()),
                    onPressed: _birthTime,
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: " To",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                      ),
                      cursorColor: Colors.black87,
                      controller: _titleController,
                      autofocus: true,
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Time",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                      ),
                      cursorColor: Colors.black87,
                      controller: _titleController,
                      autofocus: true,
                    ),
                  )
                ],
              ),
              TextField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  hintText: 'Tell us about yourself',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                minLines:
                    6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
                cursorColor: Colors.black87,
                controller: _titleController,
                autofocus: true,
              ),
            ],
          ),
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
