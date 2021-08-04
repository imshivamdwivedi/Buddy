class EventCalender {
  final String id;
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final String creatotId;
  final bool isAllDay;

  const EventCalender({
    required this.id,
    required this.title,
    required this.description,
    required this.from,
    required this.creatotId,
    required this.to,
    required this.isAllDay,
  });
}
