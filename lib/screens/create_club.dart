import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otela_investment_club_app/screens/login_screen.dart';
import 'package:otela_investment_club_app/screens/verification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateStokvelScreen extends StatefulWidget {
  const CreateStokvelScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateStokvelScreenState createState() => _CreateStokvelScreenState();
}

class _CreateStokvelScreenState extends State<CreateStokvelScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _stokvelNameController = TextEditingController();
  final TextEditingController _stokvelNumberController = TextEditingController();
  final TextEditingController _stokvelPurposeController = TextEditingController();

  String verificationId = '';

  bool _isLoading = false;
  bool _isChecked = false;
  String _selectedCountryCode = '+256';
  final List<String> _countryCodes = ['+256', '+254', '+270', '+291', '+261'];

  Future<void> _createStokvel() async {
    if (!_formKey.currentState!.validate() || !_isChecked) {
      if (!_isChecked) {
        Fluttertoast.showToast(
          msg: 'You must agree to the Terms and Conditions',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
  
      await _firestore.collection('stockvel').doc(userCredential.user?.uid).set({
        'stokvelName': _stokvelNameController.text.trim(),
        'stockvelNumber': _stokvelNumberController.text.trim(),
        'stockvelPurpose': _stokvelPurposeController.text.trim(),
        'createdAt': DateTime.now(),
      });

      //send otp and navigate to verifcation screen


      // Fluttertoast.showToast(
      //   msg: 'Account created successfully!',
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      // );

      //save first name in shared preferences
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('firstName', _firstNameController.text.trim());

     // Navigator.pushReplacementNamed(context, '/login');

      sendOTP();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? 'An error occurred.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


   void sendOTP() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '$_selectedCountryCode ${_stokvelNumberController.text.trim()}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        // Navigate to the next screen
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });
        // Navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationScreen(verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section
                     Container(
                      width: double.infinity,
                      color: const Color(0xFFA78A52), // Header background color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Create Stokvel',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Enter your details',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.menu, // Example menu icon
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),

                    // Form Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              labelText: 'Stokvel Name',
                              controller: _stokvelNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter  Stokvel name.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              labelText: 'Stokvel Number if Registered',
                              controller: _stokvelNumberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter  Stookvel number.';
                                }
                                return null;
                              },
                            ),               
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCountryCode,
                                    items: _countryCodes
                                        .map(
                                          (code) => DropdownMenuItem(
                                            value: code,
                                            child: Text(code,
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCountryCode = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              ],
                            ),
                            const SizedBox(height: 16,),
                            Text(
                                'Read T’s and C’s',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFA78A52),
                                ),
                              ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                    'I agree to the Terms and Conditions',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _createStokvel,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFA78A52),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text(
                                      'Create Stokvel',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                   const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
         // Footer Section
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16), // Add margin to start and end
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4), // Footer background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 12), // Vertical padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    '©Otela',
                    style: TextStyle(fontSize: 12, color: Color(0xFF113293),fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to Privacy
                        },
                        child: const Text(
                          'Privacy',
                          style: TextStyle(
                            color: Color(0xFF113293),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Legal
                        },
                        child: const Text(
                          'Legal',
                          style: TextStyle(
                            color: Color(0xFF113293),
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Contact
                        },
                        child: const Text(
                          'Contact',
                          style: TextStyle(
                            color: Color(0xFF113293),
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
