import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/createAccount'),
            child: Text('Create Account'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/main'),
            child: Text('Log In'),
          ),
        ],
      ),
    );
  }
}
