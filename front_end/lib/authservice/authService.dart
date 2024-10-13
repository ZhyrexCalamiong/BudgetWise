import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:reown_appkit/modal/models/public/appkit_siwe_config.dart';
import 'package:reown_appkit/modal/utils/public/appkit_modal_siwe_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
 

  static Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<String?> getCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}