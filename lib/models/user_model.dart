// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.fullName,
    this.profilePicture,
    this.about,
    this.isOnline,
    this.groupId,
  });

  String uid;
  String phoneNumber;
  String fullName;
  String? profilePicture;
  String? about;
  bool? isOnline;
  List<String>? groupId;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        phoneNumber: json["phoneNumber"],
        fullName: json["fullName"],
        profilePicture: json["profilePicture"],
        about: json["about"],
        isOnline: json["isOnline"],
        groupId: List<String>.from(json["groupId"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "phoneNumber": phoneNumber,
        "fullName": fullName,
        "profilePicture": profilePicture,
        "about": about,
        "isOnline": isOnline,
        "groupId": groupId,
      };

  @override
  // TODO: implement equatable
  List<Object?> get props => [phoneNumber];
}
