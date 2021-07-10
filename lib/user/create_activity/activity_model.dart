import 'package:firebase_database/firebase_database.dart';

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

  factory ActivityModel.fromJson(DataSnapshot snapshot, String id) {
    return ActivityModel(
      id: snapshot.value[id]['id'],
      title: snapshot.value[id]['title'],
      desc: snapshot.value[id]['desc'],
      startDate: snapshot.value[id]['startDate'],
      startTime: snapshot.value[id]['startTime'],
      endDate: snapshot.value[id]['endDate'],
      endTime: snapshot.value[id]['endTime'],
      creatorId: snapshot.value[id]['creatorId'],
      creatorName: snapshot.value[id]['creatorName'],
      creatorClg: snapshot.value[id]['creatorClg'],
    );
  }

  Map<String, dynamic> toJson() => {
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
