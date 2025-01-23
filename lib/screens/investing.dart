import 'package:flutter/material.dart';

class InvestingScreen extends StatelessWidget {
  const InvestingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investing'),
      ),
      body: Center(
        child: Text('This is the Investing Screen'),
      ),
    );
  }
}
