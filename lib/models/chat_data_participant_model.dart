class ChatDataModel {
  String? text;
  String? messageId;
  String? sender;
  String? time;

  ChatDataModel(
      {this.text,
      this.sender,
      this.messageId,
      this.time});

  ChatDataModel.fromMap(Map<String, dynamic> data) {
    text = data['text'];
    sender = data['sender'];
    messageId = data['messageId'];
    time = data['time'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'messageId': messageId,
      'sender': sender,
      'time': time,
    };
  }
}
