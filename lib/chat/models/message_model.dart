class NewMessage {
  String msgId;
  String senderId;
  String text;
  bool isRead;

  NewMessage({
    required this.msgId,
    required this.senderId,
    required this.text,
    required this.isRead,
  });

  factory NewMessage.fromMap(Map map) {
    return NewMessage(
      msgId: map['msgId'],
      senderId: map['senderId'],
      text: map['text'],
      isRead: map['isRead'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'msgId': msgId,
      'senderId': senderId,
      'text': text,
      'isRead': isRead,
    };
  }
}
