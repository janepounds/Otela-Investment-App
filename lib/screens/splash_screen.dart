import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/animated_screens.dart';
import 'package:otela_investment_club_app/screens/bank_details_screen.dart';
import 'package:otela_investment_club_app/screens/main_screen.dart';
import 'package:otela_investment_club_app/screens/stokvel_details.dart';
import 'package:otela_investment_club_app/screens/upload_document_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _checkNavigation() async {
    //await Future.delayed(const Duration(seconds: 3)); // Simulating splash screen delay

    User? user = _auth.currentUser;

    if (user == null) {
      // **🔹 User is NOT logged in → Go to Animated Screens**
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AnimatedScreens()),
      );
    } else {
      // **🔹 Check if user has created or joined a Stokvel**
      // bool isMemberOrCreator = await _checkUserStokvelMembership(user.uid);

      // if (isMemberOrCreator) {
      //   // **✅ User is part of a Stokvel → Navigate to Main Screen**
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => MainScreen()),
      //   );
      // } else {
      //   // **🚀 User is logged in but NOT part of a Stokvel → Go to Dashboard**
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => MainScreen()),
      //   );
      // }ss

       Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BankDetailscreen()),
        );
    }
  }

/// **Checks if the user has created OR joined a Stokvel**
// Future<bool> _checkUserStokvelMembership(String userId) async {
//   try {
//     // 🔹 Check if the user has created a Stokvel
//     QuerySnapshot createdStokvels = await _firestore
//         .collection('stokvels')
//         .where('createdBy', isEqualTo: userId)
//         .get();

//     // 🔹 Check if the user has joined a Stokvel
//     QuerySnapshot joinedStokvels = await _firestore
//         .collectionGroup('members') // Searches all "members" subcollections
//         .where('userId', isEqualTo: userId) // ✅ Indexed field
//         .get();

//     // ✅ If user has created OR joined a stokvel, return true
//     bool hasStokvel = createdStokvels.docs.isNotEmpty || joinedStokvels.docs.isNotEmpty;

//     print("User has stokvel: $hasStokvel"); // Debugging log
//     return hasStokvel;
//   } catch (e) {
//     print("🔥 Error checking stokvel membership: $e");
//     return false; // Assume no stokvel found in case of an error
//   }
//}


  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      _checkNavigation();
    });

    return Scaffold(
      backgroundColor: AppColors.beige, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior:
                  Clip.none, // Allow the image to overflow if necessary
              alignment: Alignment.topCenter,
              children: [
                // "otela" text
                SvgPicture.asset("assets/icons/logo.svg",
                 width: 300,
                  height: 300),
                // Text(
                //   'otela',
                //   style: TextStyle(
                //     fontSize: 50,
                //     fontWeight: FontWeight.bold,
                //     fontFamily: 'poppins',
                //     color: Colors.white,
                //   ),
                // ),
                // Image positioned at the top-right of "otela"
                // Positioned(
                //   top: -30, // Adjust this value as needed
                //   right: -40, // Adjust this value as needed
                //   child: Image.asset(
                //     'assets/images/logo_no_text.png', // Replace with your image path
                //     width: 50, // Adjust the size of the image
                //     height: 50,
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 20), // Add some spacing
            // Optional tagline below
            Text(
              'If you can dream it,\nTogether we can realize it!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'poppins'),
            ),

            const SizedBox(height: 8), // Add spacing before the line
            Container(
              width: 50, // Adjust line width as needed
              height: 3, // Adjust thickness
              color: AppColors.darBlue, // Use your background color
            ),
          ],
        ),
      ),
    );
  }
}
