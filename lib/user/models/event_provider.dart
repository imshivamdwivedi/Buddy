import 'dart:async';

import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/screens/calender_screen/events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EventsProvider with ChangeNotifier {
  List<EventCalender> _events = [];
  List<String> _eventId = [];
  DateTime selectedDate = DateTime.now();
  // ignore: non_constant_identifier_names
  final _EventDB = FirebaseDatabase.instance.reference().child('Events');
  final _auth = FirebaseAuth.instance;
  late StreamSubscription<Event> _eventStream;

  List<EventCalender> get allEvents {
    return [..._events];
  }

  EventsProvider() {
    fetchAllEvent();
  }

  void fetchAllEvent() {
    _eventStream =
        _EventDB.child(_auth.currentUser!.uid).onValue.listen((event) {
      if (event.snapshot.value == null) {
        _eventId.clear();
        _events.clear();
        notifyListeners();
      } else {
        _eventId.clear();
        _events.clear();
        final eventMapData = Map<String, dynamic>.from(event.snapshot.value);
        _eventId = eventMapData.values.map((e) {
          return e['eid'] as String;
        }).toList();

        fetchEventFromId(_eventId);
      }
    });
  }

  @override
  void dispose() {
    _eventStream.cancel();
    super.dispose();
  }

  void fetchEventFromId(List<String> eventId) {
    final activityDB = FirebaseDatabase.instance.reference().child('Activity');
    eventId.forEach((element) {
      activityDB.child(element).once().then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value != null) {
          final eventModel = ActivityModel.fromMap(dataSnapshot.value);
          final event = EventCalender(
            id: eventModel.id,
            title: eventModel.title,
            description: eventModel.desc,
            from: DateTime.parse(eventModel.startDate),
            to: DateTime.parse(eventModel.endDate),
            isAllDay: false,
          );
          _events.add(event);
        }
      });
    });
    notifyListeners();
  }

  void refresh() {
    fetchAllEvent();
  }

  DateTime get selectedDateTime {
    return selectedDate;
  }

  void setDate(DateTime dateTime) {
    selectedDate = dateTime;
  }

  List<EventCalender> get eventsOfSelectedDate {
    return _events;
  }

  List<EventCalender> get events {
    return _events;
  }
}
