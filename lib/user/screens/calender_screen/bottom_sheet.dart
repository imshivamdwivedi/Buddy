import 'package:buddy/constants.dart';
import 'package:buddy/user/screens/calender_screen/event_datasource.dart';
import 'package:buddy/user/screens/calender_screen/event_provider.dart';
import 'package:buddy/user/screens/calender_screen/event_viewing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ModalBootom extends StatefulWidget {
  const ModalBootom({Key? key}) : super(key: key);

  @override
  _ModalBootomState createState() => _ModalBootomState();
}

class _ModalBootomState extends State<ModalBootom> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          "No Events found!",
          style: TextStyle(color: Colors.black87, fontSize: 24),
        ),
      );
    }

    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: TextStyle(fontSize: 16, color: Colors.black87),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SfCalendar(
            view: CalendarView.schedule,
            dataSource: EventDataSource(provider.events),
            initialDisplayDate: provider.selectedDate,
            appointmentBuilder: appointmentBuilder,
            headerHeight: 0,
            todayHighlightColor: Colors.black87,
            selectionDecoration:
                BoxDecoration(color: Colors.red.withOpacity(0.3)),
            onTap: (details) {
              if (details.appointments == null) return;
              final event = details.appointments!.first;

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EventViewingScreen(event: event)));
            },
          ),
        ),
      ),
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
          color: kPrimaryLightColor, borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
