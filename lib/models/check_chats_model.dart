class CheckChatModel {
  CheckChatModel({this.chatId, this.participant, this.lastMessage});

  CheckChatModel.fromJson(Map<String, String> json) {
    chatId = json['chatId'];
    lastMessage = json['lastMessage'];
    participant = json['participant'] as Map<String, dynamic>?;
  }

  String? chatId;
  String? lastMessage;
  Map<String, dynamic>? participant;

  Map<String, dynamic> toJson() {
    return {
      'lastMessage': lastMessage,
      'chatId': chatId,
      'participant': participant,
    };
  }
}
