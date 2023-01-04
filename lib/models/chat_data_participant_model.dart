class ChatDataParticipant {
  String? text;
  String? messageId;
  String? sender;
  bool? seen;
  DateTime? createDone;
  String? time;

  ChatDataParticipant(
      {this.text,
      this.sender,
      this.seen,
      this.createDone,
      this.messageId,
      this.time});

  ChatDataParticipant.fromMap(Map<String, String> data) {
    text = data['text'];
    sender = data['sender'];
    messageId = data['messageId'];
    seen = data['seen'] as bool?;
    createDone = data['createDone'] as DateTime?;
    time = data['time'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'messageId': messageId,
      'sender': sender,
      'seen': seen,
      'createDone': createDone,
      'time': time,
    };
  }
}
