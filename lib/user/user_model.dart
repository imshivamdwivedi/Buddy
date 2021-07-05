class UserModel {
  String firstName;
  String lastName;
  String dob;
  String gender;
  String email;
  String collegeName;
  bool profile;
  List<String> genre;

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

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'],
      lastName: map['lastName'],
      dob: map['dob'],
      gender: map['gender'],
      email: map['email'],
      collegeName: map['collegeName'],
      profile: map['profile'],
      genre: map['genre'],
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
