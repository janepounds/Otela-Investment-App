import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/join_club.dart';
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
        child: Image.asset(
          'assets/images/money_tree_bg.png',
          fit: BoxFit.cover,
        ),
      ),
      // Transparent overlay
      Positioned.fill(
        child: Container(
          color: Colors.white.withOpacity(0.3), // Adjust transparency
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
                    child: Icon(Icons.menu,
                        color: Color(0xFF113293), size: 30),
                  ),
                ),
                SizedBox(height: 150),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    SvgPicture.asset("assets/icons/logo_color.svg",
                        width: 300, height: 300),
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
                color: AppColors.beige.withOpacity(0.8), // Adjust opacity
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8), // Add spacing before the line
                  Container(
                    width: 60, // Adjust line width as needed
                    height: 5, // Adjust thickness
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7), // Slightly transparent line
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JoinStokvelScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF113293),
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 14),
                    ),
                    child: Text('Join Existing Stokvel',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the next screen (e.g., Home)
                      Navigator.pushReplacementNamed(context, '/createStokvel');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darBlue,
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 14),
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
