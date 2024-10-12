abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted(this.email, this.password);

  List<Object> get props => [email, password];
}

