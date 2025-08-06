import 'package:cuoiki/auth/auth_gate.dart';
import 'package:cuoiki/themes/light_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/login_or_register.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightMode,
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthGate(),
        '/login': (context) => const LoginOrRegister(),
        '/home': (context) => HomePage(),
      },
    );
  }
}