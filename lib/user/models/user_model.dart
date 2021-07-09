import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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

  factory UserModel.fromJson(DataSnapshot snapshot, String uid) {
    return UserModel(
      firstName: snapshot.value[uid]['firstName'],
      lastName: snapshot.value[uid]['lastName'],
      dob: snapshot.value[uid]['dob'],
      gender: snapshot.value[uid]['gender'],
      email: snapshot.value[uid]['email'],
      collegeName: snapshot.value[uid]['collegeName'],
      id: snapshot.value[uid]['id'],
      profile: snapshot.value[uid]['profile'],
    );
  }

  Map<String, dynamic> toJson() => {
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
