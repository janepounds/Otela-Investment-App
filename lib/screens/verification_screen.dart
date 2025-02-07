import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/congratulation_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;
  
  final String caller; // Identify the calling screen
  const VerificationScreen(this.verificationId, {super.key, required this.caller});

  @override
  // ignore: library_private_types_in_public_api
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<VerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text,
      );
      await _auth.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
        builder: (context) => CongratulationsScreen(caller: widget.caller))
      );
      
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP: ${e.toString()}")),
      );
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
                    child: Image.asset('assets/images/verification_code_no_bg.png', width: 300),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Please enter verification code\n sent to you.',
                          style: TextStyle(color: AppColors.darBlue, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: otpController,
                          decoration: InputDecoration(
                            hintText: 'Verification Code',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: AppColors.gray)
                            ),
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.beige,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                          ),
                          child: Text(
                            'Verify Code',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
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
