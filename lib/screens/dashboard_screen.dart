import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9E0B1),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('otela', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFD8A85B))),
            SizedBox(height: 10),
            Text('Hi Linda', style: TextStyle(fontSize: 24, color: Colors.blue)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text('Join Existing Stokvel', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text('Create A New Stokvel', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}