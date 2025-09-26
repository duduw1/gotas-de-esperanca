// lib/features/authentication/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart'; // Ajuste o caminho
import '../services/auth_service.dart'; // Ajuste o caminho

enum AuthStatus { unknown, authenticated, unauthenticated, loading, error }

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  UserModel? _user;
  AuthStatus _status = AuthStatus.unknown;
  String? _errorMessage;

  UserModel? get user => _user;

  AuthStatus get status => _status;

  String? get errorMessage => _errorMessage;

// Em AuthProvider

  AuthProvider(this._authService) {
    _authService.authStateChanges.listen(_onAuthStateChanged);
    _checkCurrentUser(); // Verificar estado inicial
  }

  Future<void> _checkCurrentUser() async {
    _status = AuthStatus.loading; // Inicialmente define como loading
    notifyListeners(); // Notifica

    _user = _authService.getCurrentUser();
    if (_user != null) {
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners(); // Notifica o estado final
  }


  void _onAuthStateChanged(UserModel? user) {
    _user = user;
    if (user != null) {
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signUpWithEmail(String email, String password) async { // VERIFIQUE ESTE NOME
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.signUpWithEmailAndPassword(email, password); // Chama o do AuthService
      if (_user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = "Falha no cadastro. Usuário nulo retornado.";
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.signInWithEmailAndPassword(email, password);
      if (_user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = "Falha no login. Usuário nulo retornado.";
      }
    } catch (e) {
      _status = AuthStatus.error; // Mudado para error
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }
    notifyListeners();
  }

  Future<void> signInAnonymously() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.signInAnonymously(); // Chama o método do AuthService
      if (_user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = "Falha no login anônimo. Usuário nulo retornado.";
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    // Não precisa de loading aqui, a mudança de estado já será notificada
    try {
      await _authService.signOut();
      // _onAuthStateChanged cuidará de atualizar _user e _status
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage =
      "Erro ao sair: ${e.toString().replaceFirst("Exception: ", "")}";
      notifyListeners(); // Notificar sobre o erro
    }
  }

  void clearError() {
    _errorMessage = null;
    // Se o status era error, volta para unauthenticated para não ficar preso
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}// TODO Implement this library.