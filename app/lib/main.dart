// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart'; // Gerado pelo flutterfire configure
import 'app/app.dart'; // Criaremos este
import 'features/authentication/services/auth_service.dart'; // Criaremos este
import 'features/authentication/providers/auth_provider.dart' as AppAuthProvider; // Criaremos este

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider para o serviço de autenticação
        Provider<AuthService>(create: (_) => AuthService()),
        // ChangeNotifierProvider para o estado da autenticação
        ChangeNotifierProvider<AppAuthProvider.AuthProvider>(
          create: (context) =>
              AppAuthProvider.AuthProvider(context.read<AuthService>()),
        ),
        // Adicione outros providers aqui conforme necessário no futuro
      ],
      child: const App(), // Nosso widget App principal que decide a tela inicial
    );
  }
}