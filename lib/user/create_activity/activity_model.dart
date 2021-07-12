class ActivityModel {
  String id;
  String title;
  String desc;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  String creatorId;
  String creatorName;
  String creatorClg;

  ActivityModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.creatorId,
    required this.creatorName,
    required this.creatorClg,
  });

  factory ActivityModel.fromMap(Map map) {
    return ActivityModel(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      startDate: map['startDate'],
      startTime: map['startTime'],
      endDate: map['endDate'],
      endTime: map['endTime'],
      creatorId: map['creatorId'],
      creatorName: map['creatorName'],
      creatorClg: map['creatorClg'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'desc': desc,
        'startDate': startDate,
        'startTime': startTime,
        'endDate': endDate,
        'endTime': endTime,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'creatorClg': creatorClg,
      };
}
