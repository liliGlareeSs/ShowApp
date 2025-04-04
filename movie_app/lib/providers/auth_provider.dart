import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/config/api_config.dart';

class AuthProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String? _token;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        _token = jsonDecode(response.body)['token'];
        await storage.write(key: 'auth_token', value: _token);
      } else {
        _error = 'Login failed: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Connection error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> autoLogin() async {
    _token = await storage.read(key: 'auth_token');
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    await storage.delete(key: 'auth_token');
    notifyListeners();
  }

  Future<bool> get isAuthenticated async {
    await autoLogin();
    return _token != null;
  }
}