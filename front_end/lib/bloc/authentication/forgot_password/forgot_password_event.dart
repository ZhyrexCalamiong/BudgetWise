import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordSubmitEvent extends ForgotPasswordEvent {
  final String email;

  const ForgotPasswordSubmitEvent(this.email);
}

class ForgotPasswordVerifyEvent extends ForgotPasswordEvent {
  final String email;
  final String code;
  final String newPassword;


  const ForgotPasswordVerifyEvent(this.email, this.code, this.newPassword);
}