import 'package:flutter/material.dart';

class BankTransferScreen extends StatelessWidget {
  const BankTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bank Transfer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pay with Bank Transfer', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text('Account Information:'),
            Text('Account Name: Otela Funds'),
            Text('Account Number: 123456789'),
            Text('Bank: ABC Bank'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/success');
              },
              child: Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
