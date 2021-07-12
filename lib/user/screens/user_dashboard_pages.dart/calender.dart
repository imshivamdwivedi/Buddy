import 'package:buddy/constants.dart';
import 'package:buddy/user/create_activity/activity_model.dart';
import 'package:buddy/user/screens/calender_screen/bottom_sheet.dart';
import 'package:buddy/user/screens/calender_screen/event_datasource.dart';
import 'package:buddy/user/screens/calender_screen/event_provider.dart';
import 'package:buddy/user/screens/calender_screen/events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class UserCalender extends StatefulWidget {
  const UserCalender({Key? key}) : super(key: key);

  @override
  _UserCalenderState createState() => _UserCalenderState();
}

class _UserCalenderState extends State<UserCalender> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final _user = FirebaseAuth.instance.currentUser;
      final _dbref = FirebaseDatabase.instance.reference().child('Activity');
      List<EventCalender> events = [];
      await _dbref
          .orderByChild('creatorId')
          .equalTo(_user!.uid)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value == null) {
          events = [];
        } else {
          Map myMap = snapshot.value;
          myMap.values.forEach((element) {
            final activityData = ActivityModel.fromMap(element);
            final event = EventCalender(
              title: activityData.title,
              description: activityData.desc,
              from: DateTime.parse(activityData.startDate),
              to: DateTime.parse(activityData.endDate),
              isAllDay: false,
            );
            events.add(event);
          });
        }
      });
      // final List<EventCalender> events = [
      //   EventCalender(
      //     title: 'Temp Title',
      //     description: 'Temp Description',
      //     from: DateTime.now(),
      //     to: DateTime.now().add(Duration(hours: 2)),
      //     isAllDay: false,
      //   ),
      //   EventCalender(
      //     title: 'Temp Title 2',
      //     description: 'Temp Description 2',
      //     from: DateTime.now().add(Duration(hours: 1)),
      //     to: DateTime.now().add(Duration(hours: 6)),
      //     isAllDay: false,
      //   ),
      // ];
      Provider.of<EventProvider>(context, listen: false).addEventList(events);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: EventDataSource(events),
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.transparent,
        onLongPress: (details) {
          final provider = Provider.of<EventProvider>(context, listen: false);

          provider.setDate(details.date!);
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
            ),
            context: context,
            builder: (context) => ModalBootom(),
          );
        },
      ),
    );
  }
}
