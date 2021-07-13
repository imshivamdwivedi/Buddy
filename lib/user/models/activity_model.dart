class ActivityModel {
  String id;
  String title;
  String desc;
  String startDate;
  String endDate;
  String creatorId;
  String creatorName;
  String creatorClg;

  ActivityModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.startDate,
    required this.endDate,
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
      endDate: map['endDate'],
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
        'endDate': endDate,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'creatorClg': creatorClg,
      };
}
