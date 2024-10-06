import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordSuccessState extends ForgotPasswordState {}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordErrorState(this.message);
}

class ForgotPasswordVerificationSuccessState extends ForgotPasswordState {}