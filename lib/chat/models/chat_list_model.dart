class ChatListModel {
  String chid;
  String name;
  String user;

  ChatListModel({
    required this.chid,
    required this.name,
    required this.user,
  });

  factory ChatListModel.fromMap(Map map) {
    return ChatListModel(
      chid: map['chid'],
      name: map['name'],
      user: map['user'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chid': chid,
      'name': name,
      'user': user,
    };
  }
}
