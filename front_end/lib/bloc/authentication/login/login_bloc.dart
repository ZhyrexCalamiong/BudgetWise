import 'package:bloc/bloc.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService _loginRepository;

  LoginBloc(this._loginRepository) : super(LoginLoading()) {
    on<LoginSubmitted>((event, emit) async {
      try {
        emit(LoginLoaded());
        await _loginRepository.signin(event.email, event.password);
        emit(LoginNavigateToHomeScreenActionState());
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    });
  }
}
