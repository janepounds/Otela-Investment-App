import 'package:flutter/material.dart';
import 'animated_screens.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AnimatedScreens()),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFFDCB765), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none, // Allow the image to overflow if necessary
              alignment: Alignment.topCenter,
              children: [
                // "otela" text
                Text(
                  'otela',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppins',
                    color: Colors.white,
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
            SizedBox(height: 20), // Add some spacing
            // Optional tagline below
            Text(
              'If you can dream it,\nTogether we can realize it!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
