import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;
  bool _isLoading = false;

  AuthProvider(this._authService);

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.login(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.register(name, email, password);
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> loadUser() async {
    _setLoading(true);
    try {
      _user = await _authService.getCurrentUser();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
