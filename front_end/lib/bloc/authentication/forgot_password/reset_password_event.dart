import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ChangePasswordRequested extends ResetPasswordEvent {
  final String email;
  final String code;
  final String newPassword;

  const ChangePasswordRequested(this.email, this.code, this.newPassword);

  @override
  List<Object?> get props => [email, code, newPassword];
}
