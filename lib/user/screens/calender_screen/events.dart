class EventCalender {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final bool isAllDay;

  const EventCalender({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.isAllDay,
  });
}