// lib/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/authentication/providers/auth_provider.dart' as AppAuthProvider;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider.AuthProvider>(
        context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gotas de Esperança - Início'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              // O App widget cuidará da navegação para Login
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo(a), ${authProvider.user?.email ?? "Usuário"}!'),
            const SizedBox(height: 20),
            const Text('Esta é a tela inicial.'),
            // Aqui você adicionará links para Campanhas, Perfil, etc.
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('Ver Campanhas'),
              onPressed: () {
                Navigator.of(context).pushNamed('/campanhas');
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Ver Proximidades'),
              onPressed: () {
                Navigator.of(context).pushNamed('/proximidades');
              },
            ),
          ],
        ),
      ),
    );
  }
}