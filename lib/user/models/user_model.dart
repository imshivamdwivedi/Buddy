import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  String firstName;
  String lastName;
  String dob;
  String gender;
  String email;
  String collegeName;
  String id;
  bool profile;

  UserModel({
    this.firstName = '',
    this.lastName = '',
    this.dob = '',
    this.gender = '',
    this.email = '',
    this.collegeName = '',
    this.id = '',
    required this.profile,
  });

  factory UserModel.fromMap(Map map) {
    return UserModel(
      firstName: map['firstName'],
      lastName: map['lastName'],
      dob: map['dob'],
      gender: map['gender'],
      email: map['email'],
      collegeName: map['collegeName'],
      id: map['id'],
      profile: map['profile'],
    );
  }

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob,
        'gender': gender,
        'email': email,
        'collegeName': collegeName,
        'id': id,
        'profile': profile,
      };
}
