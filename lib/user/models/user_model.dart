class UserModel {
  String firstName;
  String lastName;
  String dob;
  String gender;
  String email;
  String collegeName;
  String id;
  String userImg;
  bool profile;

  UserModel({
    this.firstName = '',
    this.lastName = '',
    this.dob = '',
    this.gender = '',
    this.email = '',
    this.collegeName = '',
    this.id = '',
    this.userImg = '',
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
      userImg: map['userImg'],
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
        'userImg': userImg,
        'profile': profile,
      };
}
