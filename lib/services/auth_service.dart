import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthService {
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  static const _userKey = 'current_user';
  static const _usersKey = 'registered_users';

  Future<User?> login(String email, String password) async {
    final usersJson = _prefs.getStringList(_usersKey) ?? [];

    for (final userJson in usersJson) {
      final user = User.fromJson(jsonDecode(userJson));
      if (user.email == email && user.password == password) {
        await _prefs.setString(_userKey, userJson);
        return user;
      }
    }
    throw Exception('Invalid credentials');
  }

  Future<User?> register(String name, String email, String password) async {
    final usersJson = _prefs.getStringList(_usersKey) ?? [];

    // Check if email already exists
    if (usersJson
        .any((json) => User.fromJson(jsonDecode(json)).email == email)) {
      throw Exception('Email already registered');
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );

    usersJson.add(jsonEncode(newUser.toJson()));
    await _prefs.setStringList(_usersKey, usersJson);
    await _prefs.setString(_userKey, jsonEncode(newUser.toJson()));

    return newUser;
  }

  Future<void> logout() async {
    await _prefs.remove(_userKey);
  }

  Future<User?> getCurrentUser() async {
    final userJson = _prefs.getString(_userKey);
    return userJson != null ? User.fromJson(jsonDecode(userJson)) : null;
  }
}
