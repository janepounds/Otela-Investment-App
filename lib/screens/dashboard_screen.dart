import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName =
          prefs.getString('firstName') ?? 'User'; // Default to "User" if null
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/money_tree_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Upper section with logout image
              Container(
                padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                width: double.infinity,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: logout,
                        child: Icon(Icons.menu, color: Color(0xFF113293), size: 30),
                      ),
                    ),
                    SizedBox(height: 200),
                    Stack(
                      clipBehavior:
                          Clip.none, // Allow the image to overflow if necessary
                      alignment: Alignment.topCenter,
                      children: [
                        // "otela" text
                        Text(
                          'otela',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppins',
                            color: Color(0xFFD8A85B),
                          ),
                        ),
                        // Image positioned at the top-right of "otela"
                        Positioned(
                          top: -30, // Adjust this value as needed
                          right: -40, // Adjust this value as needed
                          child: Image.asset(
                            'assets/images/logo_no_text.png', // Replace with your image path
                            width: 50, // Adjust the size of the image
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Hi',
                      style: TextStyle(fontSize: 16, color: Color(0xFF113293)),
                    ),
                    Text(
                      userName,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF113293)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // White container with buttons
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFD8A85B),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF113293),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                        ),
                        child: Text('Join Existing Stokvel',
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF113293),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                        ),
                        child: Text('Create A New Stokvel',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
