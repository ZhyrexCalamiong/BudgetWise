import 'package:equatable/equatable.dart';

// Define login states
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {}

class LoginInitial extends LoginState {}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}

class LoginNavigateToHomeScreenActionState extends LoginState {}
