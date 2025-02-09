import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppLib {
  static const String _keyUrl = 'url';
  static const String _keyUsername = 'username';
  static String? _url;

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
    _url = url;
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
      return response.body;
    } catch (e) {
      return null;
    }
  }

  static Future<List?> getUsersList({
    required String token,
  }) async {
    final endpoint = Uri.parse('$_url/api/admin/usuaris');
    try {
      final response = await http.get(
        endpoint,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );
      if(response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"];
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateUserRole(
    {
      required String token,
      String? username,
      String? email,
      String? telefon,
      required String role,
    }
  ) async {
    final endpoint = Uri.parse('$_url/api/admin/usuaris/pla/actualitzar');
    final body = jsonEncode({
      'username': username,
      'pla': role,
      'token': token,
    });
    print(body);
    final response = await http.post(
      endpoint,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: body,
    );
    if(response.statusCode == 200) {
      print("Updated user role");
      return true;
    }
    print("Error updating user role: ${response.body}");
    return false;
  }

  static Future<List<dynamic>> getLogs(
    {
      required String token,
    }
  ) async {
    final endpoint = Uri.parse('$_url/api/admin/usuaris/logs');
    final response = await http.post(
      endpoint,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return data["data"]["logs"];
    }
    return [];
  }
}

 