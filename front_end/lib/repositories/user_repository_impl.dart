import 'package:budgetwise_one/authservice/authService.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart'; // Import the User model
import 'user_repository.dart';

class UserService implements UserRepository {
  final String baseUrl = 'http://localhost:8000/api';

  Future<String?> _getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

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
        final data = jsonDecode(response.body);
        String userId = data['userId']; // Assuming the response contains userId
        await AuthService.saveUserId(userId); // _id from MongoDB is saved
        print('Signin successful: ${data['message']}');
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

  @override
  Future<User> getName(String id) async {
    try {
      final userId = await _getId();
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {"Content-Type": "application/json"},
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('successful get');
        final Map<String, dynamic> body = jsonDecode(response.body);
        print(body);
        return User.fromJson(body);
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception('Failed to get: ${responseData['message']}');
      }
    } catch (e) {
      print('Signin error: $e');
      throw Exception('Failed to login: $e');
    }
  }
}
