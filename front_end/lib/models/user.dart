class User {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? password;
  final String? dateOfBirth;

  User({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'dateOfBirth': dateOfBirth,
    };
  }

  factory User.fromJsom(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      dateOfBirth: map['dateOfBirth'],
    );
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      dateOfBirth: map['dateOfBirth'],
    );
  }
}
