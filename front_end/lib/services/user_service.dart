import 'package:http/http.dart' as http;
import 'dart:convert';
import '/models/user.dart';

class UserService {
  final String baseUrl = 'http://localhost:8000/api';

Future<void> signup(Map<String, dynamic> data) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    // Log the response for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Check for successful response
    if (response.statusCode == 201) {
      print('User successfully created');
    } else {
      // If server responds with an error code, throw an exception with details
      throw Exception('Failed to create user. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    // Log the exception details
    print('Signup error: $e');
    throw Exception('Failed to create user: $e');
  }
}


 Future<void> signin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signin'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email, // Make sure this matches what the backend expects
          'password': password,
        }),
      );

      // Log response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Signin successful: ${responseData['message']}');
        // Handle successful signin, e.g., save user data or navigate
      } else {
        // Handle errors
        final responseData = jsonDecode(response.body);
        throw Exception('Failed to login: ${responseData['message']}');
      }
    } catch (e) {
      print('Signin error: $e');
      throw Exception('Failed to login: $e');
    }
  }
  
 Future<void> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email}),
      );

      // Log response for debugging
      print('Forgot Password Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Verification code sent: ${responseData['message']}');
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception('Failed to send verification code: ${responseData['message']}');
      }
    } catch (e) {
      print('Forgot Password error: $e');
      throw Exception('Failed to send verification code: $e');
    }
  }

  Future<void> resetPassword(String email, String code, String newPassword) async {
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

      // Log response for debugging
      print('Reset Password Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

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
