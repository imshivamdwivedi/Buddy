class ChatListModel {
  String chid;
  String name;
  String nameImg;
  String user;
  int msgPen;
  String lastMsg;

  ChatListModel({
    required this.chid,
    required this.name,
    required this.nameImg,
    required this.user,
    required this.msgPen,
    required this.lastMsg,
  });

  factory ChatListModel.fromMap(Map map) {
    return ChatListModel(
      chid: map['chid'],
      name: map['name'],
      nameImg: map['nameImg'],
      user: map['user'],
      msgPen: map['msgPen'],
      lastMsg: map['lastMsg'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chid': chid,
      'name': name,
      'nameImg': nameImg,
      'user': user,
      'msgPen': msgPen,
      'lastMsg': lastMsg,
    };
  }
}
