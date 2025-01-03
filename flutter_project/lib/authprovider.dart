import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _email;
  String? _password;

  String? get token => _token;
  String? get email => _email;
  String? get password => _password;

  void setToken(String token) {
    _token = token;
    notifyListeners(); // Notify listeners when token changes
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners(); // Notify listeners when email changes
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners(); // Notify listeners when password changes
  }

  void clearCredentials() {
    _token = null;
    _email = null;
    _password = null;
    notifyListeners(); // Notify listeners when credentials are cleared
  }
}
