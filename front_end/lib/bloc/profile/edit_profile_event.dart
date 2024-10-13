// edit_profile_event.dart
abstract class EditProfileEvent {}

class UpdateProfile extends EditProfileEvent {
  final String firstName;
  final String middleName;
  final String lastName;

  UpdateProfile({
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });
}
