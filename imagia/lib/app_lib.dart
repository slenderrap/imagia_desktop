import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  static Future<String?> connect({
    required String url,
    required String username,
    required String password,
  }) async {
    final endpoint = Uri.parse('$url/api/admin/usuaris/login');
    final body = jsonEncode({
      'username': username,
      'password': password,
    });
    try {
      final response = await http.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'];
      } else {
        return response.body;
      }
    } catch (e) {
      return null;
    }
  }
}
 