// lib/core/models/user_model.dart
class UserModel {
  final String uid;
  final String? email;
  final bool isAnonymous;

  UserModel({
    required this.uid,
    this.email,
    this.isAnonymous = false, // Valor padrão
  });
}