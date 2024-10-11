import '/models/user.dart';

abstract class UserRepository {
  Future<void> signin(String email, String password);
  Future<void> signup(User user);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String email, String code, String newPassword);
  Future<User> getName(String id);
}