import 'package:flutter/material.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Account')),
      body: Form(
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Name')),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/main'),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
