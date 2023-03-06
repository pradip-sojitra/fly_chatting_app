// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.fullName,
    this.profilePicture,
    this.about,
    this.active,
    this.isSeen,
  });

  String uid;
  String phoneNumber;
  String fullName;
  String? profilePicture;
  String? about;
  bool? active;
  int? isSeen;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        phoneNumber: json["phoneNumber"],
        fullName: json["fullName"],
        profilePicture: json["profilePicture"],
        about: json["about"],
        active: json["active"],
        isSeen: json["isSeen"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "phoneNumber": phoneNumber,
        "fullName": fullName,
        "profilePicture": profilePicture,
        "about": about,
        "active": active,
        "isSeen": isSeen,
      };
}
