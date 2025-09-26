// lib/features/authentication/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthPackage;
import '../../../core/models/user_model.dart'; // Ajuste o caminho se necessário

class AuthService {
  final FirebaseAuthPackage.FirebaseAuth _firebaseAuth = FirebaseAuthPackage
      .FirebaseAuth.instance;

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  UserModel? _userFromFirebase(FirebaseAuthPackage.User? user) {
    if (user == null) return null;
    // Adapte conforme o seu UserModel
    return UserModel(
      uid: user.uid,
      email: user.email,
      isAnonymous: user.isAnonymous,
    );
  }
  

  // ... (seus métodos existentes signInWithEmailAndPassword, signUpWithEmailAndPassword) ...

  Future<UserModel?> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(credential.user);
    } on FirebaseAuthPackage.FirebaseAuthException catch (e) {
      // print("Erro no login anônimo (AuthService): ${e.message}");
      throw Exception("Falha ao fazer login anônimo: ${e.message}");
    } catch (e) {
      // print("Erro desconhecido no login anônimo (AuthService): $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      // print("Erro no logout (AuthService): $e");
      rethrow;
    }
  }

  UserModel? getCurrentUser() {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }


  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(credential.user);
    } on FirebaseAuthPackage.FirebaseAuthException catch (e) {
      throw Exception(e.message); // Re-lançar para o provider/UI tratar
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Aqui você pode querer salvar informações adicionais do usuário no Firestore
      return _userFromFirebase(credential.user);
    } on FirebaseAuthPackage.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }
}

