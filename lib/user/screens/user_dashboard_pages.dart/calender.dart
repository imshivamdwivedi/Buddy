import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class UserCalender extends StatefulWidget {
  const UserCalender({Key? key}) : super(key: key);

  @override
  _UserCalenderState createState() => _UserCalenderState();
}

class _UserCalenderState extends State<UserCalender> {
  @override
  Widget build(BuildContext context) {
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
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.transparent,
      ),
    );
  }
}
