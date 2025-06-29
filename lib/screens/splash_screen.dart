import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/animated_screens.dart';
import 'package:otela_investment_club_app/screens/main_screen.dart';
// Make sure to import your MainScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay to show splash screen for 2 seconds
  Future.delayed(const Duration(seconds: 3), () {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AnimatedScreens()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/logo.svg",
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 20),
            const Text(
              'If you can dream it,\nTogether we can realize it!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'poppins',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 50,
              height: 3,
              color: AppColors.darBlue,
            ),
          ],
        ),
      ),
    );
  }
}
