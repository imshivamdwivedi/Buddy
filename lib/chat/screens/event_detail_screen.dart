import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/screens/calender_screen/events.dart';
import 'package:buddy/user/screens/calender_screen/utils.dart';
import 'package:buddy/user/screens/user_dashboard.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/create_activity_screen.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/screen_helper_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  final ActivityModel activityModel;

  const EventDetailScreen({required this.activityModel});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  void AddEvent() async {
    final uid = _auth.currentUser!.uid;
    final activity_id = widget.activityModel.id;

    final _refUserEvent = FirebaseDatabase.instance
        .reference()
        .child('Events')
        .child(uid)
        .child(activity_id);
    await _refUserEvent.child('eid').set(activity_id);
  }

  @override
  Widget build(BuildContext context) {
    final event = EventCalender(
      id: widget.activityModel.id,
      creatotId: widget.activityModel.creatorId,
      title: widget.activityModel.title,
      description: widget.activityModel.desc,
      from: DateTime.parse(widget.activityModel.startDate),
      to: DateTime.parse(widget.activityModel.endDate),
      isAllDay: false,
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.black87,
          onPressed: AddEvent),
      appBar: AppBar(
        leading: CloseButton(
          color: Colors.black87,
        ),
        elevation: 0.0,
        backgroundColor: kPrimaryLightColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            Center(
                child: Text(
              "Event Details",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            )),
            SizedBox(height: 10),
            buildDateTime(event),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Agenda - ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              event.description,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDateTime(EventCalender event) {
    return Column(
      children: [
        buildDate('From', event.from),
        SizedBox(
          height: 10,
        ),
        buildDate('To', event.to),
      ],
    );
  }

  Widget buildDate(String head, DateTime date) {
    return Row(
      children: [
        Expanded(
          child: Text(
            head,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Text(
                Utils.toDate(date),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                Utils.toTime(date),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
