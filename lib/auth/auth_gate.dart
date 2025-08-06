import 'package:cuoiki/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/main_home_page.dart'; // Trang chủ ban đầu
import '../pages/home_page.dart'; // Trang chủ chính sau khi đăng nhập

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return HomePage(); // Trang chủ chính sau khi đăng nhập
          } else {
            return MainHomePage(
              onReadBook: () => _navigateToLogin(context), // Chuyển đến trang đăng nhập
            );
          }
        },
      ),
    );
  }
}