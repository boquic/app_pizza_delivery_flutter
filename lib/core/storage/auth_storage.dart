import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_model.dart';

class AuthStorage {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userRolKey = 'user_rol';
  static const String _userDataKey = 'user_data';

  final SharedPreferences _prefs;

  AuthStorage(this._prefs);

  Future<void> saveToken(String token, [String? refreshToken]) async {
    await _prefs.setString(_tokenKey, token);
    if (refreshToken != null) {
      await _prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> saveUserId(int userId) async {
    await _prefs.setInt(_userIdKey, userId);
  }

  int? getUserId() {
    return _prefs.getInt(_userIdKey);
  }

  Future<void> saveUserRol(String rol) async {
    await _prefs.setString(_userRolKey, rol);
  }

  String? getUserRol() {
    return _prefs.getString(_userRolKey);
  }

  Future<void> saveUser(UsuarioModel user) async {
    await _prefs.setString(_userDataKey, jsonEncode(user.toJson()));
    await saveUserId(user.id);
    await saveUserRol(user.rol);
  }

  UsuarioModel? getUser() {
    final userJson = _prefs.getString(_userDataKey);
    if (userJson == null) return null;
    return UsuarioModel.fromJson(jsonDecode(userJson));
  }

  bool isAdmin() {
    return getUserRol() == 'ADMIN';
  }

  Future<void> clearAll() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userRolKey);
    await _prefs.remove(_userDataKey);
  }

  bool hasToken() {
    return _prefs.getString(_tokenKey) != null;
  }
}
