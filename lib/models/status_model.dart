// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class StatusModel {
//   StatusModel({
//     required this.uid,
//     required this.userName,
//     required this.phoneNumber,
//     required this.photoUrl,
//     required this.time,
//     required this.profilePic,
//     required this.statusId,
//     required this.whoCanSee,
//   });
//
//   String uid;
//   String userName;
//   String phoneNumber;
//   List<String> photoUrl;
//   Timestamp time;
//   String profilePic;
//   String statusId;
//   List<String> whoCanSee;
//
//   factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
//         uid: json["uid"],
//         userName: json["userName"],
//         phoneNumber: json["phoneNumber"],
//         photoUrl: List<String>.from(json["photoUrl"]),
//         time: json["time"],
//         profilePic: json["profilePic"],
//         statusId: json["statusId"],
//         whoCanSee: List<String>.from(json["whoCanSee"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "uid": uid,
//         "userName": userName,
//         "phoneNumber": phoneNumber,
//         "photoUrl": photoUrl,
//         "time": time,
//         "profilePic": profilePic,
//         "statusId": statusId,
//         "whoCanSee": whoCanSee,
//       };
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  StatusModel({
    required this.uid,
    required this.userName,
    required this.phoneNumber,
    required this.photoUrl,
    required this.time,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });

  String uid;
  String userName;
  String phoneNumber;
  List<String> photoUrl;
  DateTime time;
  String profilePic;
  String statusId;
  List<String> whoCanSee;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        uid: json["uid"],
        userName: json["userName"],
        phoneNumber: json["phoneNumber"],
        photoUrl: List<String>.from(json["photoUrl"]),
        time: DateTime.fromMillisecondsSinceEpoch(json["time"]),
        profilePic: json["profilePic"],
        statusId: json["statusId"],
        whoCanSee: List<String>.from(json["whoCanSee"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "userName": userName,
        "phoneNumber": phoneNumber,
        "photoUrl": photoUrl,
        "time": time.millisecondsSinceEpoch,
        "profilePic": profilePic,
        "statusId": statusId,
        "whoCanSee": whoCanSee,
      };
}
