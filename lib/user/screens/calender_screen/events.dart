class EventCalender {
  final String id;
  final String title;
  final String description;
  final String img;
  final DateTime from;
  final DateTime to;
  final String creatotId;
  final bool isAllDay;

  const EventCalender({
    required this.id,
    required this.title,
    required this.description,
    required this.img,
    required this.from,
    required this.creatotId,
    required this.to,
    required this.isAllDay,
  });
}
