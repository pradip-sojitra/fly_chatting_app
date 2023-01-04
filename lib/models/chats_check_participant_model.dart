class ChatCheckParticipant{
  String? chatId;
  String? lastMessage;
  Map<String, dynamic>? participant;

  ChatCheckParticipant({this.chatId, this.participant, this.lastMessage});

  ChatCheckParticipant.fromMap(Map<String, dynamic> data) {
    chatId = data['chatId'];
    lastMessage = data['lastMessage'];
    participant = data['participant'] as Map<String, dynamic>?;
  }

  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'chatId': chatId,
      'participant': participant,
    };
  }
}
