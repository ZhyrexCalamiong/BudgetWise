import 'package:equatable/equatable.dart';
import '../../../models/user.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class RegistrationInitialEvent extends RegistrationEvent {}


class UserRegistrationRequested extends RegistrationEvent {
  final User user;

  const UserRegistrationRequested(this.user);

  @override
  List<Object?> get props => [user];
}