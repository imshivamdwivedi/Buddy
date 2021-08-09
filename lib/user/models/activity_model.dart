class ActivityModel {
  String id;
  String img;
  String title;
  String desc;
  String startDate;
  String endDate;
  String shareType;
  String searchTag;
  String creatorId;
  String creatorName;
  String creatorClg;
  String communities;

  ActivityModel({
    required this.id,
    required this.img,
    required this.title,
    required this.desc,
    required this.startDate,
    required this.endDate,
    required this.shareType,
    required this.searchTag,
    required this.creatorId,
    required this.creatorName,
    required this.creatorClg,
    required this.communities,
  });

  factory ActivityModel.fromMap(Map map) {
    return ActivityModel(
      id: map['id'],
      img: map['img'],
      title: map['title'],
      desc: map['desc'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      shareType: map['shareType'],
      searchTag: map['searchTag'],
      creatorId: map['creatorId'],
      creatorName: map['creatorName'],
      creatorClg: map['creatorClg'],
      communities: map['communities'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'img': img,
        'title': title,
        'desc': desc,
        'startDate': startDate,
        'endDate': endDate,
        'shareType': shareType,
        'searchTag': searchTag,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'creatorClg': creatorClg,
        'communities': communities,
      };
}
