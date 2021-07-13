import 'package:buddy/constants.dart';
import 'package:buddy/user/screens/calender_screen/event_provider.dart';
import 'package:buddy/user/screens/calender_screen/events.dart';
import 'package:buddy/user/screens/calender_screen/utils.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/calender.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/create_activity_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventViewingScreen extends StatelessWidget {
  final EventCalender event;

  const EventViewingScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          color: Colors.black87,
        ),
        actions: buildViewActions(context, event),
        backgroundColor: kPrimaryLightColor,
      ),
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Card(
          elevation: 5,
          child: ListView(
            padding: EdgeInsets.all(32),
            children: [
              Center(
                  child: Text(
                "Event Details",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              )),
              SizedBox(height: 20),
              buildDateTime(event),
              SizedBox(height: 20),
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
                      fontSize: 20,
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Text(
                Utils.toDate(date),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                Utils.toTime(date),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> buildViewActions(
          BuildContext context, EventCalender eventCalender) =>
      [
        IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => CreateActivityScreen(eventCalender))),
            icon: Icon(
              Icons.edit,
              color: Colors.black87,
            )),
        IconButton(
          onPressed: () async {
            final _dbref =
                FirebaseDatabase.instance.reference().child('Activity');
            await _dbref.child(event.id).set(null);

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => UserCalender()));
          },
          icon: Icon(
            Icons.delete,
            color: Colors.black87,
          ),
        )
      ];
}
