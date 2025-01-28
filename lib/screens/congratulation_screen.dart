import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/screens/dashboard_screen.dart';

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9E0B1),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Congratulations!', style: TextStyle(fontSize: 28, color: Colors.green)),
            SizedBox(height: 10),
            Text('Linda', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 10),
            Text(
              'You have successfully created your account!\nOtela welcomes you to your home of AI powered Roboadvisory Investing services.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD8A85B),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text('Next', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}