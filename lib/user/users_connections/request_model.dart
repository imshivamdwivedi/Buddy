class RequestModel {
  String senId;
  String recId;
  String createdAt;
  String status;
  String id;

  RequestModel({
    required this.senId,
    required this.recId,
    required this.createdAt,
    required this.status,
    required this.id,
  });

  factory RequestModel.fromMap(Map map) {
    return RequestModel(
      senId: map['senId'],
      recId: map['recId'],
      createdAt: map['createdAt'],
      status: map['status'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() => {
        'senId': senId,
        'recId': recId,
        'createdAt': createdAt,
        'status': status,
        'id': id,
      };
}
