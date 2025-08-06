import 'package:cuoiki/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? onTap;


  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) async {
    final _auth = AuthService();
    if (_pwController.text == _confirmPwController.text) {
      try {
        await _auth.signUpWithEmailPassword(_emailController.text, _pwController.text);
        // Hiển thị thông báo đăng ký thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thành công!'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
        // Chờ 1 giây để người dùng thấy thông báo, sau đó chuyển hướng
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString().replaceAll('Exception: ', '')),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Mật khẩu không khớp!"),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),

            Text(
              "Welcome back, you've been missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),

            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(height: 25),

            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(height: 25),
            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _confirmPwController,
            ),
            const SizedBox(height: 25),

            MyButton(
              text: "Register",
              onTap: ()=>register(context),
            ),
            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text("Already have an account for you ",
                  style:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap:onTap,
                  child:
                    Text("Login now ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),

                ),

              ],
            )

          ],
        ),
      ),
    );
  }
}
