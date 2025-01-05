import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _email;
  String? _password;
  String? _role; // Add the role field

  String? get token => _token;
  String? get email => _email;
  String? get password => _password;
  String? get role => _role; // Add the role getter

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setRole(String role) {
    // Add the role setter
    _role = role;
    notifyListeners();
  }

  void clearCredentials() {
    _token = null;
    _email = null;
    _password = null;
    _role = null; // Clear the role
    notifyListeners();
  }
}
