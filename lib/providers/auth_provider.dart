import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  static const String _loginKey = 'login_state';
  static const String _emailKey = 'email'; // For currently logged-in user
  static const String _nameKey = 'name'; // For currently logged-in user
  static const String _signedUpEmailKey = 'signed_up_email'; // For the last signed-up user
  static const String _signedUpPasswordKey = 'signed_up_password'; // For the last signed-up user

  bool _isLoggedIn = false;
  String? _email;
  String? _name;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get name => _name;

  AuthProvider() {
    _loadLoginState();
  }

  void _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_loginKey) ?? false;
    if (_isLoggedIn) {
      _email = prefs.getString(_emailKey);
      _name = prefs.getString(_nameKey);
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    // Dummy login logic: Replace with actual authentication (e.g., API call)
    if (email == "test@example.com" && password == "password") {
      _isLoggedIn = true;
      _email = email;
      _name = "Test User"; // Dummy name
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loginKey, _isLoggedIn);
      await prefs.setString(_emailKey, _email!);
      await prefs.setString(_nameKey, _name!);
      notifyListeners();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString(_emailKey);
      final storedPassword = prefs.getString('signed_up_password');

      if (email == storedEmail && password == storedPassword) {
        _isLoggedIn = true;
        _email = storedEmail; // Set _email from stored value
        _name = prefs.getString(_nameKey) ?? "User"; // Set _name from stored value or default
        await prefs.setBool(_loginKey, _isLoggedIn);
        await prefs.setString(_emailKey, _email!); // Store the email for consistency
        await prefs.setString(_nameKey, _name!); // Store the name for consistency
        notifyListeners();
      } else {
        throw Exception('Invalid email or password');
      }
    }
  }

  Future<void> signup(String name, String email, String password) async {
    // Dummy signup logic: Replace with actual registration (e.g., API call)
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && password.length >= 6) {
      // In a real app, you'd register the user with a backend here.
      // For now, we'll just simulate success.
      print('User $email registered successfully (dummy)');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, email);
      await prefs.setString('signed_up_password', password);
      await prefs.setString(_nameKey, name);
      // Optionally, log in the user immediately after signup
      // await login(email, password);
    } else {
      throw Exception('Signup failed. Please check your name, email and password (min 6 characters).');
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _email = null;
    _name = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_signedUpEmailKey);
    await prefs.remove(_signedUpPasswordKey);
    notifyListeners();
  }
}
