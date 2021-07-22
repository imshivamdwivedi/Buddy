class NewMessage {
  String msgId;
  String senderId;
  String text;
  int createdAt;
  bool isRead;

  NewMessage({
    required this.msgId,
    required this.senderId,
    required this.text,
    required this.isRead,
    required this.createdAt,
  });

  factory NewMessage.fromMap(Map map) {
    return NewMessage(
      msgId: map['msgId'],
      senderId: map['senderId'],
      text: map['text'],
      isRead: map['isRead'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'msgId': msgId,
      'senderId': senderId,
      'text': text,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }
}
