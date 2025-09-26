// lib/features/authentication/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as AppAuthProvider;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const String routeName = '/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    Provider
        .of<AppAuthProvider.AuthProvider>(context, listen: false)
        .clearError();
    if (_formKey.currentState!.validate()) {
      // Aqui você pode adicionar lógica para coletar mais dados do usuário (nome, etc.)
      // e passá-los para o AuthProvider ou um ProfileProvider para salvar no Firestore.
      await Provider
          .of<AppAuthProvider.AuthProvider>(context, listen: false)
          .signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // Se o cadastro for bem-sucedido, o App widget deve levar para HomeScreen
      // Se não, o erro será exibido
      if (mounted && Provider
          .of<AppAuthProvider.AuthProvider>(context, listen: false)
          .status != AppAuthProvider.AuthStatus.authenticated) {
        // Erro permaneceu, não fazer nada aqui, o provider já notificou
      } else if (mounted) {
        // Sucesso, o App widget cuidará da navegação
        // Navigator.of(context).popUntil((route) => route.isFirst); // Opcional, para limpar pilha de navegação
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider.AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro - Gotas de Esperança')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Crie sua conta',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
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
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha.';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem.';
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
                    onPressed: _submit,
                    child: const Text('CADASTRAR'),
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
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Provider.of<AppAuthProvider.AuthProvider>(
                        context, listen: false).clearError();
                    Navigator.of(context).pop(); // Voltar para a tela de Login
                  },
                  child: const Text('Já tem uma conta? Faça Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}