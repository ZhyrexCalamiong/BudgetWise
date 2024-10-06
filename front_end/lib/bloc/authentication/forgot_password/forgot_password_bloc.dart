import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/user_repository_impl.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final UserService userService;

  ForgotPasswordBloc(this.userService) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      try {
        await userService.forgotPassword(event.email);
        emit(ForgotPasswordSuccessState());
      } catch (e) {
        emit(ForgotPasswordErrorState(e.toString()));
      }
    });


    on<ForgotPasswordVerifyEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      try {
        await userService.resetPassword(event.email, event.code, event.newPassword);
        emit(ForgotPasswordVerificationSuccessState());
      } catch (e) {
        emit(ForgotPasswordErrorState(e.toString()));
      }
    });
  }
}
