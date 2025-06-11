import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/congratulation_screen.dart';
import 'package:otela_investment_club_app/screens/loadingOverLay.dart';
import 'package:otela_investment_club_app/screens/stokvel_congratulations.dart';

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

  final TextEditingController _stokvelNameController = TextEditingController();
  final TextEditingController _stokvelNumberController =
      TextEditingController();

  String verificationId = '';
  String phone = '';

  bool _isLoading = false;
  bool _isChecked = false;
  String? selectedPurpose;
  final TextEditingController accountNumberController = TextEditingController();

  final List<String> purposes = ["Test", "Investment", "Growth"];

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone') ?? 'User'; // Default to "User" if null
    });
  }



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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(message: "User not found", code: "401");

    final userId = user.uid;
    final DatabaseReference db = FirebaseDatabase.instance.ref();

    // Fetch user details
    final userSnapshot = await db.child('users/$userId').get();
    if (!userSnapshot.exists) throw Exception("User record not found.");

    final userData = Map<String, dynamic>.from(userSnapshot.value as Map);

    // Create a new stokvel and push it to database
    final stokvelRef = db.child('stokvels').push();
    final stokvelId = stokvelRef.key;

    await stokvelRef.set({
      'stokvelName': _stokvelNameController.text.trim(),
      'stokvelNumber': _stokvelNumberController.text.trim(),
      'stokvelPurpose': selectedPurpose,
      'createdBy': userId,
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Add current user as admin/member under the stokvel
    await db.child('stokvels/$stokvelId/members/$userId').set({
      'role': 'admin',
      'firstName': userData['firstName'],
      'lastName': userData['lastName'],
      'phone': userData['phone'],
      'roboAdvisor': false,
      'amountPaid': 0,
      'status': 'Pending',
      'joinedAt': DateTime.now().toIso8601String(),
    });

    Fluttertoast.showToast(
      msg: 'Stokvel Created Successfully',
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('stokvelName', _stokvelNameController.text.trim());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StokvelCongratulationsScreen(),
      ),
    );
  } catch (e) {
    Fluttertoast.showToast(
      msg: e.toString(),
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
      phoneNumber: "+256704151828",
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
                VerificationScreen(verificationId),
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
    resizeToAvoidBottomInset: true, // Handle keyboard overlapping
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Create Stokvel",
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
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.menu, color: Colors.white, size: 30),
        ),
      ],
    ),
    body: Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField(
                          labelText: 'Stokvel Name',
                          controller: _stokvelNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Stokvel name.';
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
                              return 'Please enter Stokvel number.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        buildDropdownField(
                          "Purpose of Stokvel",
                          selectedPurpose,
                          purposes,
                          (value) {
                            setState(() {
                              selectedPurpose = value;
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Read T’s and C’s',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.beige,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                              checkColor: Colors.white,
                              activeColor: AppColors.darBlue,
                              side: const BorderSide(
                                  color: AppColors.darBlue, width: 2),
                            ),
                            Expanded(
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
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _createStokvel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.beige,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 12),
                          ),
                          child: const Text(
                            'Create Stokvel',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              color: Colors.white,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      '©Otela',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF113293),
                          fontWeight: FontWeight.bold),
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
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF113293)),
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
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF113293)),
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
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF113293)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Loader
        if (_isLoading) const LoadingOverLay(),
      ],
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
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.gray)),
      ),
    );
  }

  Widget buildDropdownField(String title, String? selectedValue,
      List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(title, style: const TextStyle(color: Colors.grey)),
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
