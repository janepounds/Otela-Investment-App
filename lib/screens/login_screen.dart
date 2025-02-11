import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/dashboard_screen.dart';
import 'package:otela_investment_club_app/screens/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'create_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Track password visibility

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill in both fields",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Authenticate user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null)
        throw FirebaseAuthException(message: "Login failed", code: '500');

      // Save email to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);

      Fluttertoast.showToast(
        msg: "Login successful!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Check if the user has created or joined a stokvel
      bool hasStokvel = await userHasStokvel(user.uid);

      // Navigate based on stokvel status
      if (hasStokvel) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? "Login failed. Please try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> userHasStokvel(String userId) async {
    try {
      // Check if the user has created a stokvel
      var createdStokvels = await FirebaseFirestore.instance
          .collection('stokvels')
          .where('createdBy', isEqualTo: userId)
          .get();

      if (createdStokvels.docs.isNotEmpty) return true;

      // Check if user is a member of any stokvel
      var memberOfStokvels = await FirebaseFirestore.instance
          .collectionGroup('members')
          .where(FieldPath.documentId, isEqualTo: userId)
          .get();

      return memberOfStokvels.docs.isNotEmpty;
    } catch (e) {
      print("Error checking stokvel status: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
  child: GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensures content is as small as needed
          children: [
            const SizedBox(height: 40), // Moves everything up
            SvgPicture.asset(
              "assets/icons/logo.svg",
              width: 250, // Reduce width slightly if needed
              height: 250,
            ),
            const SizedBox(height: 20), // Reduce space after the logo
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'E-mail',
                hintStyle: const TextStyle(color: Colors.white, fontSize: 16),
                filled: true,
                fillColor: const Color(0xFFa78a52),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.white, fontSize: 16),
                filled: true,
                fillColor: const Color(0xFFa78a52),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Centered Login Button
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9E0B1),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:  const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.beige,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Forgot Password
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Forgot Your password? ',
                style: const TextStyle(fontSize: 14, color: Colors.white),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountScreen(),
                      ),
                    );
                  },
              ),
            ),
            const SizedBox(height: 30),
            // Sign Up
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: const TextStyle(fontSize: 14, color: Colors.white),
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),


             // Reusable Loader
          LoadingOverlay(isLoading: _isLoading),
          ],
        ),
      ),
    ),
  ),
),
    );
  }
}
