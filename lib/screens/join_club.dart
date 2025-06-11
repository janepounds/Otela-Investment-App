import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/verification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinStokvelScreen extends StatefulWidget {
  const JoinStokvelScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JoinStokvelScreenState createState() => _JoinStokvelScreenState();
}

class _JoinStokvelScreenState extends State<JoinStokvelScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idPassportController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String verificationId = '';
  bool _isLoading = false;
  bool _isChecked = false;
  String _selectedCountryCode = '+256';
  String? selectedStokvel;
  String? selectedStockvelId;

  final List<String> _countryCodes = ['+256', '+254', '+270', '+291', '+261'];

  List<Map<String, dynamic>> stokvelList = []; // Store fetched stokvels

  Stream<List<Map<String, dynamic>>> fetchStokvels() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('stokvels') // Fetch all stokvels
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return {
            'id': doc.id, // Stokvel ID
            'name': doc['stokvelName'], // Stokvel Name
          };
        }).toList();
      });
    } else {
      return const Stream.empty();
    }
  }

  Future<void> _joinSkovel(String s) async {
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

    //save selected stokvel in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('stokvelName', selectedStokvel!);

    //save user under members stokvel
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Store member information inside the selected stokvel's "members" subcollection
        await FirebaseFirestore.instance
            .collection('stokvels')
            .doc(s) // Find the stokvel
            .collection('members') // Go to members subcollection
            .doc(user.uid) // Use user ID as member ID
            .set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'phone': '$_selectedCountryCode ${_phoneController.text.trim()}',
          'joinedAt': Timestamp.now(),
        });

        Fluttertoast.showToast(
          msg: 'Successfully joined the Stokvel!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } catch (error) {
        print("Error joining stokvel: $error");
        Fluttertoast.showToast(
          msg: 'Error joining stokvel. Try again!',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }

    try {
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Join Stokvel",
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
                              // id or passport
                              _buildTextField(
                                labelText: 'ID/ Passport',
                                controller: _lastNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name.';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              //phone number
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
                              //stokvel name

                              // Stokvel Dropdown
                              StreamBuilder<List<Map<String, dynamic>>>(
                                stream: fetchStokvels(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Text("No stokvels available");
                                  }

                                  stokvelList = snapshot
                                      .data!; // Save the fetched stokvels

                                  return buildDropdownField(
                                    selectedStokvel ?? "Select a Stokvel",
                                    selectedStokvel, // Show Stokvel name instead of ID
                                    stokvelList
                                        .map((stokvel) =>
                                            stokvel['name'] as String)
                                        .toList(),
                                    (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          selectedStokvel = newValue;
                                          selectedStockvelId =
                                              stokvelList.firstWhere(
                                            (stokvel) =>
                                                stokvel['name'] == newValue,
                                            orElse: () => {'id': ''},
                                          )['id'];
                                        });
                                      }
                                    },
                                  );
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
                                      onPressed: () {
                                        if (selectedStockvelId != null) {
                                          // Find the selected Stokvel Name using its ID
                                          _joinSkovel(
                                              selectedStockvelId!); // Pass stokvelId here
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Please select a Stokvel!");
                                        }
                                      },
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
                                        'Join Stokvel',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 24),

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
              color: Colors.white, // Outer background color set to white
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16), // Add margin to start and end
                decoration: const BoxDecoration(
                  color: Color(
                      0xFFF4F4F4), // Keep the original footer background color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12), // Vertical padding
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
                                fontWeight: FontWeight.bold),
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
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
