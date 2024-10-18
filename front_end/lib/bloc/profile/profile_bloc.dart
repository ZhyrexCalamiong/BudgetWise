import 'package:bloc/bloc.dart';
import 'package:budgetwise_one/bloc/profile/profile_event.dart';
import 'package:budgetwise_one/bloc/profile/profile_state.dart';
import 'package:budgetwise_one/models/user.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService _profileRepository;

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<FetchUserName>(getName);
    // on<UpdateUser>(updateProfile);
    //on<LogoutProfile>(logout);
  }

  Future<void> getName(FetchUserName event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading()); // Emit loading state

    try {
      // Assuming _getId() is a method within UserService
      const userId = "";
      User user = await _profileRepository.getName(userId);

      // Assuming userNameResponse contains firstName and lastName
      emit(ProfileLoaded(user: [user]));
    } catch (e) {
      print('Error fetching name: $e');
      emit(ProfileError(message: e.toString())); // Emit error state
    }
  }

  // Future<void> updateProfile(
  //     UpdateUser event, Emitter<ProfileState> emit) async {
  //   emit(ProfileLoading()); // Emit loading state
  //   try {
  //     final userId = "";
  //     User user = await _profileRepository.updateProfile(
  //       userId,
  //       event.firstName,
  //       event.middleName,
  //       event.lastName,
  //     );
  //     emit(ProfileSuccess());
  //     emit(ProfileLoaded(user: [user]));
  //   } catch (e) {
  //     print('Error fetching name: $e');
  //     emit(ProfileError(message: e.toString()));
  //   }
  // }
}
