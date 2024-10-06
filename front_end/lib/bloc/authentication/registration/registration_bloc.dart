import 'package:bloc/bloc.dart';
import '../../../features/profile/repositories/user_repository.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final UserRepository _registrationRepository;

  RegistrationBloc(this._registrationRepository)
      : super(RegistrationLoading()) {
    on<UserRegistrationRequested>((event, emit) async {
      emit(RegistrationLoading()); // Emit loading state
      try {
        await _registrationRepository.signup(event.user);
        emit(RegistrationNavigateToLoginScreenActionState());
      } catch (e) {
        emit(RegistrationError(e.toString())); // Emit error state
      }
    });
  }
}
