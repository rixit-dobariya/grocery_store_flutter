class UserModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? mobile;
  final String? password;
  final String? profilePicture;
  final String? token;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.mobile,
    this.password,
    this.profilePicture,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      mobile: json['mobile'],
      password: json['password'],
      profilePicture: json['profilePicture'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobile': mobile,
      'password': password,
      'profilePicture': profilePicture,
      'token': token,
    };
  }
}
