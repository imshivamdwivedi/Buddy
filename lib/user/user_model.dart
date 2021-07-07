import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String firstName;
  String lastName;
  String dob;
  String gender;
  String email;
  String collegeName;
  bool profile;
  Map<dynamic, dynamic> genre;

  UserModel({
    this.firstName = '',
    this.lastName = '',
    this.dob = '',
    this.gender = '',
    this.email = '',
    this.collegeName = '',
    required this.profile,
    required this.genre,
  });

  factory UserModel.fromJson(DataSnapshot snapshot) {
    return UserModel(
      firstName: snapshot.value['firstName'],
      lastName: snapshot.value['lastName'],
      dob: snapshot.value['dob'],
      gender: snapshot.value['gender'],
      email: snapshot.value['email'],
      collegeName: snapshot.value['collegeName'],
      profile: snapshot.value['profile'],
      genre: snapshot.value['genre'] == null ? [] : snapshot.value['genre'],
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob,
        'gender': gender,
        'email': email,
        'collegeName': collegeName,
        'profile': profile,
        'genre': genre,
      };
}
