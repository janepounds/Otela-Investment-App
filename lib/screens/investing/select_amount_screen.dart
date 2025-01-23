import 'package:flutter/material.dart';

class SelectAmountScreen extends StatelessWidget {
  const SelectAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Select Amount')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Start your investment journey', style: TextStyle(fontSize: 20)),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/paymentMethod');
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
