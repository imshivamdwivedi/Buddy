class ChatListModel {
  String chid;
  String name;
  String nameImg;
  String user;

  ChatListModel({
    required this.chid,
    required this.name,
    required this.nameImg,
    required this.user,
  });

  factory ChatListModel.fromMap(Map map) {
    return ChatListModel(
      chid: map['chid'],
      name: map['name'],
      nameImg: map['nameImg'],
      user: map['user'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chid': chid,
      'name': name,
      'nameImg': nameImg,
      'user': user,
    };
  }
}
