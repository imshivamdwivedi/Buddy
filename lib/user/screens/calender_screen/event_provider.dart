import 'package:buddy/user/screens/calender_screen/events.dart';
import 'package:flutter/cupertino.dart';

class EventProvider extends ChangeNotifier {
  final List<EventCalender> _events = [];

  DateTime selectedDate = DateTime.now();

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

  void addEventList(List<EventCalender> events) {
    _events.clear();
    _events.addAll(events);
    notifyListeners();
  }
}
