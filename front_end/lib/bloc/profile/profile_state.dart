import 'package:budgetwise_one/models/user.dart';

// Define login states
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}


class ProfileSuccess extends ProfileState {}


class ProfileLoaded extends ProfileState {
  final List<User> user;

  ProfileLoaded({required this.user});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}

class ProfileNavigate extends ProfileState {}
