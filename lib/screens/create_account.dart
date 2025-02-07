import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/login_screen.dart';
import 'package:otela_investment_club_app/screens/verification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String verificationId = '';

  bool _isLoading = false;
  bool _isChecked = false;
  String _selectedCountryCode = '+256';
  final List<String> _countryCodes = ['+256', '+254', '+270', '+291', '+261'];

  Future<void> _signUp() async {
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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': '$_selectedCountryCode ${_phoneController.text.trim()}',
        'createdAt': Timestamp.now(), // Firestore timestamp
      });

      //send otp and navigate to verifcation screen

      // Fluttertoast.showToast(
      //   msg: 'Account created successfully!',
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      // );

      //save first name in shared preferences
      final String phoneNo =
          '$_selectedCountryCode ${_phoneController.text.trim()}';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', _firstNameController.text.trim());
      await prefs.setString('phone', phoneNo);

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
      phoneNumber: '$_selectedCountryCode ${_phoneController.text.trim()}',
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
            builder: (context) =>
                VerificationScreen(verificationId, caller: "Create Account"),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.beige,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Create Account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins')),
                SizedBox(height: 4),
                Text("Enter your details",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'poppins')),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset('assets/images/logo_no_text.png',
                  width: 50, height: 50),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 20), // Spacing
            Expanded(
              // Ensures the form expands to take available space
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  // Enables scrolling if content is too much
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Your form content here
                      // Form Section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                labelText: 'First Name',
                                controller: _firstNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                labelText: 'Last Name',
                                controller: _lastNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                labelText: 'Email',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email.';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address.';
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
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
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildTextField(
                                      labelText: 'Phone Number',
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your phone number.';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                labelText: 'Password',
                                controller: _passwordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password.';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                labelText: 'Confirm Password',
                                controller: _confirmPasswordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match.';
                                  }
                                  return null;
                                },
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
                                      checkColor: Colors
                                          .white, // Color of the checkmark
                                      activeColor: AppColors
                                          .darBlue, // Background color when checked
                                      side: const BorderSide(
                                        color:
                                            AppColors.darBlue, // Border color
                                        width: 2, // Border width
                                      )),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: RichText(
                                      text: const TextSpan(
                                        text: 'I agree to the  ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.darBlue),
                                        children: [
                                          TextSpan(
                                            text: 'Terms & Conditions.',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: _signUp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.beige,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 80,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 24),

                              // Already Have an Account? Sign In
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to Sign In screen
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                    child: const Text(
                                      'Sign In!',
                                      style: TextStyle(
                                        color: Color(0xFF113293),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              

                              //footer section
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),


                  //new footer
                  
                ),
              ),

              
            ),

            /// 🔥 Footer Section Sticks to Bottom 🔥 ///
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const BoxDecoration(
                                  color: AppColors.footer,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      '©Otela',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.darBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Privacy',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.darBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Legal',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.darBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Contact',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.darBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
          ],
        ));
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
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.gray)),
      ),
    );
  }
}
