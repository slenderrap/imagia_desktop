import 'package:shared_preferences/shared_preferences.dart';

class AppLib {
  static const String _keyUrl = 'url';
  static const String _keyUsername = 'username';

  static Future<void> savePreferences({
    required String url, 
    required String username
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUrl, url);
    await prefs.setString(_keyUsername, username);
  }

  static Future<Map<String, String>?> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString(_keyUrl);
    final username = prefs.getString(_keyUsername);
        if (url != null && username != null) {
      return {
        'url': url,
        'username': username,
      };
    }
    return null;
  }

  static Future<void> connect({required String url, required String username, required String password,}) async {

  }

}