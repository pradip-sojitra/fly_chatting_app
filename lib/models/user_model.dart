import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  String phoneNumber;
  String uid;
  String? profilePicture;
  String? fullName;
  String? about;

  UserModel({
    required this.phoneNumber,
    required this.uid,
    this.profilePicture,
    this.fullName,
    this.about,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      phoneNumber: data['phoneNumber'],
      uid: data['uid'],
      profilePicture: data['profilePicture'],
      fullName: data['fullName'],
      about: data['about'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'uid': uid,
      'profilePicture': profilePicture,
      'fullName': fullName,
      'about': about,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber, fullName, uid, profilePicture, about];
}
