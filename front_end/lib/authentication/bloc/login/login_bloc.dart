import 'package:bloc/bloc.dart';
import '../../../features/profile/repositories/user_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _loginRepository;

  LoginBloc(this._loginRepository) : super(LoginLoading()) {
    on<LoginSubmitted>((event, emit) async {
      try {
        emit(LoginLoading());
        await _loginRepository.signin(event.email, event.password);
        emit(LoginNavigateToHomeScreenActionState());
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    });
  }
}
