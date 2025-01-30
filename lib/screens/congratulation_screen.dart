import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/screens/dashboard_screen.dart';
import 'package:otela_investment_club_app/screens/personal_details_screen.dart';
import 'package:otela_investment_club_app/screens/stokvel_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CongratulationsScreen extends StatefulWidget {
  final String caller;
  const CongratulationsScreen({super.key, required this.caller});

  @override
  // ignore: library_private_types_in_public_api
  _CongratulationsScreenState createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen> {
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
      backgroundColor: Color(0xFFF9E0B1),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Congratulations!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'geat_vibes'),
                  ),
                ],
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
                      Text('Congratulations!',
                          style: TextStyle(fontSize: 20, color: Colors.blue)),
                      SizedBox(height: 10),
                      Text(
                        userName,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF113293)),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.caller == "Create Account"
                            ? "You have successfully created your account!"
                            : widget.caller == "Create Stokvel"
                                ? "You have successfully joined $stokvel Stokvel!!"
                                : "$stokvel has been successfully registered!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF113293),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Otela welcomes you to your home of AI-powered Roboadvisory Investing services.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.caller == "Create Account") {
                            // Navigate to Dashboard if called by Signup
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardScreen()),
                            );
                          } else if(widget.caller == "Create Stokvel"){
                            // Navigate to StockDetails if called by any other screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PersonalDetailsScreen()),
                            );
                          }else{
                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StokvelDetailsScreen()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD8A85B),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                        ),
                        child:
                            Text(
                           widget.caller == "Create Account"
                            ? "Next"
                            : widget.caller == "Create Stokvel"
                                ? "My Profile"
                                : "STOKVEL PROFILE",
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
