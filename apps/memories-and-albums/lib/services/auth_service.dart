import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthService() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('current_user');
    if (userJson != null) {
      try {
        _currentUser = UserModel.fromJson(jsonDecode(userJson));
        notifyListeners();
      } catch (e) {
        _currentUser = null;
      }
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      await prefs.setString('current_user', jsonEncode(_currentUser!.toJson()));
    } else {
      await prefs.remove('current_user');
    }
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = UserModel(
      id: 'u1', 
      displayName: 'Jane Doe', 
      email: email,
      photoUrl: 'https://i.pravatar.cc/150?u=jane'
    );
    
    await _saveToPrefs();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = UserModel(
      id: 'u1', 
      displayName: 'Jane Doe', 
      email: 'jane@example.com', 
      photoUrl: 'https://i.pravatar.cc/150?u=jane'
    );
    
    await _saveToPrefs();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    await _saveToPrefs();
    notifyListeners();
  }
}
