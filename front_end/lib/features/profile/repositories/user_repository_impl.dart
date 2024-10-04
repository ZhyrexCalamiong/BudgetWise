import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../authentication/models/user.dart'; // Import the User model
import 'user_repository.dart';

class UserService implements UserRepository {
  final String baseUrl = 'http://localhost:8000/api';

  @override
  Future<void> signup(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toMap()), // Convert User object to Map here
      );

      if (response.statusCode == 201) {
        print('User successfully created');
      } else {
        throw Exception(
            'Failed to create user. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Signup error: $e');
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<void> signin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signin'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Signin successful: ${responseData['message']}');
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception('Failed to login: ${responseData['message']}');
      }
    } catch (e) {
      print('Signin error: $e');
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Verification code sent: ${responseData['message']}');
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
            'Failed to send verification code: ${responseData['message']}');
      }
    } catch (e) {
      print('Forgot Password error: $e');
      throw Exception('Failed to send verification code: $e');
    }
  }

  @override
  Future<void> resetPassword(
      String email, String code, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'code': code,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Password reset successful: ${responseData['message']}');
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception('Failed to reset password: ${responseData['message']}');
      }
    } catch (e) {
      print('Reset Password error: $e');
      throw Exception('Failed to reset password: $e');
    }
  }
}
