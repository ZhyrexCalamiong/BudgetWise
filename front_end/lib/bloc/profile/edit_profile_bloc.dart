// edit_profile_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UserService userService;

  EditProfileBloc(this.userService) : super(EditProfileInitial()) {
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoading());

    try {
      const userId = ""; // Get the user ID
      await userService.updateProfile(
        userId,
        event.firstName,
        event.middleName,
        event.lastName,
      );
      emit(EditProfileSuccess());
    } catch (e) {
      emit(EditProfileError(message: e.toString()));
    }
  }
}
