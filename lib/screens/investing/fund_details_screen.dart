import 'package:flutter/material.dart';

class FundDetailsScreen extends StatelessWidget {
  const FundDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fund Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Strategic Fund', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Fund Objectives: Maximize returns in 5 years'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/selectAmount');
              },
              child: Text('Invest'),
            ),
          ],
        ),
      ),
    );
  }
}
