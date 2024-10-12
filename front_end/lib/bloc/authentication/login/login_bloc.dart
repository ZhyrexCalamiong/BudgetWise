import 'package:bloc/bloc.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService _loginRepository;

  LoginBloc(this._loginRepository) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const LoginError("Email and password cannot be empty."));
        return;
      }
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
