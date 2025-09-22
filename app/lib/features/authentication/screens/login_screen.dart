// lib/features/authentication/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as AppAuthProvider;
import 'signup_screen.dart'; // Para navegar para cadastro

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmailPassword() async {
    Provider
        .of<AppAuthProvider.AuthProvider>(context, listen: false)
        .clearError();
    if (_formKey.currentState!.validate()) {
      await Provider
          .of<AppAuthProvider.AuthProvider>(context, listen: false)
          .signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  // NOVO MÉTODO PARA LOGIN ANÔNIMO
  Future<void> _submitAnonymous() async {
    Provider
        .of<AppAuthProvider.AuthProvider>(context, listen: false)
        .clearError();
    // Certifique-se que você adicionou o método signInAnonymously no seu AuthProvider
    await Provider
        .of<AppAuthProvider.AuthProvider>(context, listen: false)
        .signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider.AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login - Gotas de Esperança')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const FlutterLogo(size: 80),
                const SizedBox(height: 30),
                Text(
                  'Bem-vindo(a)!',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty ||
                        !value.contains('@')) {
                      return 'Por favor, insira um email válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                if (authProvider.status == AppAuthProvider.AuthStatus.loading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _submitEmailPassword,
                    // Mudado para o método específico
                    child: const Text('ENTRAR COM EMAIL'),
                  ),
                if (authProvider.status == AppAuthProvider.AuthStatus.error &&
                    authProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 15), // Espaçamento

                // BOTÃO PARA LOGIN ANÔNIMO
                if (authProvider.status != AppAuthProvider.AuthStatus
                    .loading) // Não mostrar se já estiver carregando
                  TextButton(
                    onPressed: _submitAnonymous, // Chama o novo método
                    child: const Text('Continuar como Visitante'),
                  ),
                // FIM DO BOTÃO PARA LOGIN ANÔNIMO

                const SizedBox(height: 15), // Espaçamento
                TextButton(
                  onPressed: () {
                    Provider.of<AppAuthProvider.AuthProvider>(
                        context, listen: false).clearError();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()),
                    );
                  },
                  child: const Text('Não tem uma conta? Cadastre-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}