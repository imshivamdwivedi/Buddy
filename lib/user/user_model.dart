class UserModel {
  String name;
  String email;
  String phoneNumber;

  UserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
      };
}
