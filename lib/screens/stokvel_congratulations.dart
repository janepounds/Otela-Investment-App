import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/dashboard_screen.dart';
import 'package:otela_investment_club_app/screens/personal_details_screen.dart';
import 'package:otela_investment_club_app/screens/stokvel_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StokvelCongratulationsScreen extends StatefulWidget {
  const StokvelCongratulationsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StokvelCongratulationsScreenState createState() => _StokvelCongratulationsScreenState();
}

class _StokvelCongratulationsScreenState extends State<StokvelCongratulationsScreen> {
  String userName = '';
  String stokvel = '';

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
      stokvel = prefs.getString('stokvelName') ?? 'Default';
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.beige,
    body: Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/congrats_no_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
               
                    // Pushes content down
                     Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darBlue,
              )
                     ),
                     SizedBox(height: 20),
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF113293),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("$stokvel has been successfully registered!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.darBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Otela welcomes you to your home of AI-powered Roboadvisory Investing services.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.darBlue, fontSize: 16),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StokvelDetailsScreen()),
                          );
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.beige,
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                      ),
                      child: Text("STOKVEL PROFILE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ✅ Move the "Congratulations!" text UP using Positioned
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15, // Adjust to move higher
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 52,
                fontFamily: 'geat_vibes',
                color: AppColors.darBlue,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


}
