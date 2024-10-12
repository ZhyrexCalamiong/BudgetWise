import 'package:bloc/bloc.dart';
import 'package:budgetwise_one/bloc/profile/bloc/profile_event.dart';
import 'package:budgetwise_one/bloc/profile/bloc/profile_state.dart';
import 'package:budgetwise_one/models/user.dart';
import 'package:budgetwise_one/pages/login_page.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService _profileRepository;

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<FetchUserName>(getName);
    //on<LogoutProfile>(logout);
  }

  Future<void> getName(FetchUserName event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading()); // Emit loading state

    try {
      // Assuming _getId() is a method within UserService
      final userId = "";
      User user = await _profileRepository.getName(userId);

      // Assuming userNameResponse contains firstName and lastName
      emit(ProfileLoaded(user: [user]));
    } catch (e) {
      print('Error fetching name: $e');
      emit(ProfileError(message: e.toString())); // Emit error state
    }
  }

  // Future<void> logout(LogoutProfile event, Emitter<ProfileState> emit) async {
  //   // Navigate to Login Page
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const LoginPage()),
  //   );
  // }
}
