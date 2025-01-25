import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/screens/create_account.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDCB765), // Background color
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo at the top
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
                      fontFamily: 'Poppins',
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
              SizedBox(height: 30),
              // Login form
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
             TextFormField(
                  decoration: InputDecoration(
                    hintText: 'E-mail',
                      hintStyle: TextStyle(
                      color: Colors.white, // Change to the desired hint text color
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Color(0xFFa78a52),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none, // No border when the field is not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none, // No border when the field is focused
                    ),
                  ),
                ),

                  SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.white, // Change to the desired hint text color
                          fontSize: 16,
                        ),
                      filled: true,
                      fillColor: Color(0xFFa78a52),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                       enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none, // No border when the field is not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none, // No border when the field is focused
                    ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Add navigation logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF9E0B1),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA78A52),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Registration Screen
                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                                      );

                        },
                        child: Text(
                          'Register Here',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Terms & Conditions
              SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  text: TextSpan(
                    text: 'By signing in, you agree to our ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms & Conditions.',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
