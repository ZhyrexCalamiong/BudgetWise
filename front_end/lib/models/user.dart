class User {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String dateOfBirth;

  User({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.dateOfBirth,
  });

  // Add a method to convert User object to a Map
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

  // Add a factory constructor to create a User from a Map if needed
  factory User.fromMap(Map<String, dynamic> map) {
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
