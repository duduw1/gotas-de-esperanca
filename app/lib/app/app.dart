// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/authentication/providers/auth_provider.dart' as AppAuthProvider;
import '../features/authentication/screens/login_screen.dart';
import '../home/screens/home_screen.dart';
import '../features/about/screens/sobre_screen.dart';
//import '../features/profile/screens/profile_screen.dart';
import '../features/campaigns/screens/campanhas_screen.dart';
import '../features/proximidades/screens/proximidades_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Usar Consumer ou context.watch para reagir a mudanças no AuthStatus
    return Consumer<AppAuthProvider.AuthProvider>(
      builder: (context, auth, child) {
        Widget homeWidget;
        switch (auth.status) {
          case AppAuthProvider.AuthStatus.unknown:
          case AppAuthProvider.AuthStatus.loading:
            homeWidget = const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
            break;
          case AppAuthProvider.AuthStatus.authenticated:
            homeWidget = const HomeScreen();
            break;
          case AppAuthProvider.AuthStatus.unauthenticated:
          case AppAuthProvider.AuthStatus
              .error: // Tratar erro também mostrando login
            homeWidget = const LoginScreen();
            break;
        }

        return MaterialApp(
          title: 'Gotas de Esperança',
          theme: ThemeData(
              primarySwatch: Colors.red,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              inputDecorationTheme: InputDecorationTheme( // Estilo padrão para inputs
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData( // Estilo padrão para botões
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)
                  )
              )
          ),
          home: homeWidget,
          routes: {
            CampanhasScreen.routeName: (context) => const CampanhasScreen(),
            ProximidadesScreen.routeName: (context) => const ProximidadesScreen(),
            //ProfileScreen.routeName: (context) => const ProfileScreen(),
            SobreScreen.routeName: (context) => const SobreScreen(),
          },
        );
      },
    );
  }
}// TODO Implement this library.