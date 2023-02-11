import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fly_chatting_app/models/message_enum.dart';

class MessageModel {
  MessageModel({
    required this.receiverId,
    required this.senderId,
    required this.messageId,
    required this.text,
    required this.time,
    required this.isSeen,
    required this.type,
  });

  String receiverId;
  String senderId;
  String messageId;
  String text;
  Timestamp time;
  bool isSeen;
  MessageEnum type;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    receiverId: json["receiverId"],
    senderId: json["senderId"],
    messageId: json["messageId"],
    text: json["text"],
    time: json["time"],
    isSeen: json["isSeen"],
    type: (json["type"] as String).toEnum(),
  );

  Map<String, dynamic> toJson() => {
    "receiverId": receiverId,
    "senderId": senderId,
    "messageId": messageId,
    "text": text,
    "time": time,
    "isSeen": isSeen,
    "type": type.type,
  };
}
