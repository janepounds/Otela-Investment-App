import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/screens/congratulation_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;
  const VerificationScreen(this.verificationId, {super.key});
   @override
  // ignore: library_private_types_in_public_api
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}


  class _OtpVerificationScreenState extends State<VerificationScreen>{
    final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;



  void verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text,
      );
      await _auth.signInWithCredential(credential);
      //navigate to congratulation screen
       Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CongratulationsScreen()),
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
      backgroundColor: Color(0xFFF9E0B1),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/envelope.png', width: 150),
            SizedBox(height: 20),
            Text(
              'Please enter verification code sent to you.',
              style: TextStyle(color: Colors.blue, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                hintText: 'Verification code',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                verifyOTP();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD8A85B),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text('Verify Code', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}