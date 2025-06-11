import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/congratulation_screen.dart';
import 'package:otela_investment_club_app/screens/loadingOverLay.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;

  const VerificationScreen(this.verificationId, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<VerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

void verifyOTP() async {
  setState(() {
    _isLoading = true;
  });

  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otpController.text,
    );

    // 🔗 Link the phone credential to the currently logged-in user
    await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CongratulationsScreen(),
      ),
    );
  } on FirebaseAuthException catch (e) {
    String errorMessage = "Invalid OTP: ${e.message}";
    if (e.code == 'provider-already-linked') {
      errorMessage = "Phone number already linked to this account.";
    } else if (e.code == 'credential-already-in-use') {
      errorMessage = "This phone number is already used by another account.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
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
                flex: 3,
                child: Container(
                  color: AppColors.beige,
                  child: Center(
                    child: Image.asset(
                      'assets/images/verification_code_no_bg.png',
                      width: 300,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Please enter verification code\nsent to you.',
                          style: TextStyle(
                            color: AppColors.darBlue,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: otpController,
                          decoration: InputDecoration(
                            hintText: 'Verification Code',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: AppColors.gray),
                            ),
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: _isLoading ? null : verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.beige,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                          ),
                          child: const Text(
                            'Verify Code',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Loading Overlay
          if (_isLoading)
            const LoadingOverLay(),
        ],
      ),
    );
  }
}

