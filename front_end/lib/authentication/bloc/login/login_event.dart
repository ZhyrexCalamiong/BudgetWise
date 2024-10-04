import 'package:equatable/equatable.dart';

// Define login events
abstract class LoginEvent extends Equatable {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password]; // Include the props for Equatable comparison
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted(super.email, super.password);
}
