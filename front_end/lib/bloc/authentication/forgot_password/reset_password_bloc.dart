import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/user_repository_impl.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final UserService userService;

  ResetPasswordBloc(this.userService) : super(ResetPasswordInitial()) {
    on<ChangePasswordRequested>((event, emit) async {
      emit(ResetPasswordLoading());
      try {
        await userService.resetPassword(event.email, event.code, event.newPassword);
        emit(ResetPasswordSuccess());
      } catch (e) {
        emit(ResetPasswordFailure(e.toString()));
      }
    });
  }
}
