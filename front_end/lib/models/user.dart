class User {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName ;
  final String email;
  final String dateofBirth;
  final String phone;
  final String password;

  User({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.dateofBirth,
    required this.phone,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      dateofBirth: json['dateofBirth'],
      phone: json['phone'],
      password: json['password']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'dateofBirth': dateofBirth,
      'phone': phone,
      'password': password
    };
  }
}
