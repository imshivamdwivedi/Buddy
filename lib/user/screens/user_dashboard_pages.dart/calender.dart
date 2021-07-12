import 'package:buddy/constants.dart';
import 'package:buddy/user/screens/calender_screen/bottom_sheet.dart';
import 'package:buddy/user/screens/calender_screen/event_datasource.dart';
import 'package:buddy/user/screens/calender_screen/event_provider.dart';
import 'package:buddy/user/screens/calender_screen/events.dart';
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final List<EventCalender> events = [
        EventCalender(
          title: 'Temp Title',
          description: 'Temp Description',
          from: DateTime.now(),
          to: DateTime.now().add(Duration(hours: 2)),
          isAllDay: false,
        ),
        EventCalender(
          title: 'Temp Title 2',
          description: 'Temp Description 2',
          from: DateTime.now().add(Duration(hours: 1)),
          to: DateTime.now().add(Duration(hours: 6)),
          isAllDay: false,
        ),
      ];
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
            context: context,
            builder: (context) => ModalBootom(),
          );
        },
      ),
    );
  }
}
