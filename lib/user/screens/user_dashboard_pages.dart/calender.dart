import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/screens/calender_screen/bottom_sheet.dart';
import 'package:buddy/user/screens/calender_screen/event_datasource.dart';
import 'package:buddy/user/screens/calender_screen/event_provider.dart';
import 'package:buddy/user/screens/calender_screen/events.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/screen_helper_provider.dart';
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
              id: activityData.id,
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
      Provider.of<EventProvider>(context, listen: false).addEventList(events);

      //---( Snack Payload )---//
      final helper = Provider.of<ScreenHelperProvider>(context, listen: false);
      if (helper.getSnackAvail) {
        CustomSnackbar().showFloatingFlushbar(
          context: context,
          message: helper.getSnackPayload,
          color: Colors.green,
        );
      }
      helper.flushSnackMessage();
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
        onTap: (details) {
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
