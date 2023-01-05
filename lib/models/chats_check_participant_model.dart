class ChatCheckModel{
  String? chatId;
  String? lastMessage;
  String? lastTime;
  Map<String, dynamic>? participant;

  ChatCheckModel({this.chatId, this.participant, this.lastMessage, this.lastTime});

  ChatCheckModel.fromMap(Map<String, dynamic> data) {
    chatId = data['chatId'];
    lastMessage = data['lastMessage'];
    participant = data['participant'];
    lastTime = data['lastTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'chatId': chatId,
      'participant': participant,
      'lastTime':lastTime,
    };
  }
}
