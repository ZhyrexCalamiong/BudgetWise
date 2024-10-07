import 'package:bloc/bloc.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final UserService _registrationRepository;

  RegistrationBloc(this._registrationRepository) : super(RegistrationLoading()) {
    on<UserRegistrationRequested>((event, emit) async {
      try {
        emit(RegistrationLoaded());
        await _registrationRepository.signup(event.user);
        emit(RegistrationNavigateToLoginScreenActionState());
      } catch (e) {
        emit(RegistrationError(e.toString())); 
      }
    });
  }
}
