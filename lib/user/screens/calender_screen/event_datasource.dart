import 'package:buddy/user/screens/calender_screen/events.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<EventCalender> appointments) {
    this.appointments = appointments;
  }
  EventCalender getEvent(int index) {
    return appointments![index] as EventCalender;
  }

  @override
  DateTime getStartTime(int index) {
    return getEvent(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return getEvent(index).to;
  }

  @override
  String getSubject(int index) {
    return getEvent(index).title;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
