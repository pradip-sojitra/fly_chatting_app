class ChatDataModel {
  ChatDataModel(
      {this.text, this.sender, this.seen, this.createDone, this.messageId});

  ChatDataModel.fromJson(Map<String, String> json) {
    text = json['text'];
    sender = json['sender'];
    messageId = json['messageId'];
    seen = json['seen'] as bool?;
    createDone = json['createDone'] as DateTime?;
  }

  String? text;
  String? messageId;
  String? sender;
  bool? seen;
  DateTime? createDone;

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'messageId': messageId,
      'sender': sender,
      'seen': seen,
      'createDone': createDone,
    };
  }
}
