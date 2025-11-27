import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/usuario_model.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_request_model.dart';
import '../../../../injection_container.dart';

class AuthState {
  final UsuarioModel? user;
  final String? token;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.token,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UsuarioModel? user,
    String? token,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRemoteDataSource _authDataSource;
  final AuthStorage _authStorage;

  AuthNotifier(this._authDataSource, this._authStorage) : super(AuthState()) {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final token = _authStorage.getToken();
    final user = _authStorage.getUser();

    if (token != null && user != null) {
      state = state.copyWith(
        token: token,
        user: user,
        isAuthenticated: true,
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequestModel(email: email, password: password);
      final response = await _authDataSource.login(request);

      await _authStorage.saveToken(response.token);
      await _authStorage.saveUser(response.usuario);

      state = state.copyWith(
        token: response.token,
        user: response.usuario,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> register(String nombre, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = RegisterRequestModel(
        nombre: nombre,
        apellido: '', // Por ahora vacío, se puede agregar campo en UI después
        email: email,
        password: password,
      );
      final response = await _authDataSource.register(request);

      await _authStorage.saveToken(response.token);
      await _authStorage.saveUser(response.usuario);

      state = state.copyWith(
        token: response.token,
        user: response.usuario,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authStorage.clearAll();
    } catch (e) {
      // Ignorar errores de limpieza de almacenamiento
    } finally {
      state = AuthState();
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    getIt<AuthRemoteDataSource>(),
    getIt<AuthStorage>(),
  );
});
