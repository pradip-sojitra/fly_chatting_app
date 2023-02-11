import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListModel {
  ChatListModel({
    required this.name,
    required this.profilePic,
    required this.id,
    required this.time,
    required this.lastMessage,
  });

  String name;
  String profilePic;
  String id;
  Timestamp time;
  String lastMessage;

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
        name: json["name"],
        profilePic: json["profilePic"],
        id: json["id"],
        time: json["time"],
        lastMessage: json["lastMessage"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePic": profilePic,
        "id": id,
        "time": time,
        "lastMessage": lastMessage,
      };
}
