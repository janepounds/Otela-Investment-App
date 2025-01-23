import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Method')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Bank Transfer'),
            onTap: () {
              Navigator.pushNamed(context, '/bankTransfer');
            },
          ),
          ListTile(
            title: Text('PayPal'),
            onTap: () {
              // Handle PayPal logic here
            },
          ),
        ],
      ),
    );
  }
}
