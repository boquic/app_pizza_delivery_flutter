import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userRolKey = 'user_rol';

  final SharedPreferences _prefs;

  AuthStorage(this._prefs);

  Future<void> saveToken(String token, String refreshToken) async {
    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_refreshTokenKey, refreshToken);
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

  bool isAdmin() {
    return getUserRol() == 'ADMIN';
  }

  Future<void> clearAll() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userRolKey);
  }

  bool hasToken() {
    return getToken() != null;
  }
}
