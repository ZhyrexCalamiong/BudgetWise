abstract class ProfileEvent {}

class InitialEvent extends ProfileEvent {}

class FetchUserName extends ProfileEvent {}

// class UpdateUser extends ProfileEvent{
//   final String firstName;
//   final String middleName;
//   final String lastName;

//   UpdateUser({
//     required this.firstName,
//     required this.middleName,
//     required this.lastName,
//   });
// }

class LogoutProfile extends ProfileEvent {}
