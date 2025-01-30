import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                VerificationScreen(verificationId, caller: "Create Stokvel"),
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
                      color: const Color(0xFFA78A52),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Join Stokvel',
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
                          const Icon(Icons.menu, color: Colors.white, size: 30),
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
                              labelText: 'First Name',
                              controller: _firstNameController,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              labelText: 'Last Name',
                              controller: _lastNameController,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              labelText: 'ID / Passport',
                              controller: _idPassportController,
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
                                      items: _countryCodes.map((code) {
                                        return DropdownMenuItem(
                                          value: code,
                                          child: Text(code,
                                              style: const TextStyle(
                                                  fontSize: 16)),
                                        );
                                      }).toList(),
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
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Stokvel Dropdown
                            StreamBuilder<List<Map<String, dynamic>>>(
                              stream: fetchStokvels(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }

                                List<Map<String, dynamic>> stokvels =
                                    snapshot.data!;

                                return DropdownButtonFormField<String>(
                                  value: selectedStockvelId,
                                  hint: Text("Select a Stokvel"),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedStockvelId =
                                          newValue; // Save selected Stokvel ID
                                    });
                                  },
                                  items: stokvels
                                      .map<DropdownMenuItem<String>>((stokvel) {
                                    return DropdownMenuItem<String>(
                                      value: stokvel['id'], // Stokvel ID
                                      child:
                                          Text(stokvel['name']), // Stokvel Name
                                    );
                                  }).toList(),
                                );
                              },
                            ),

                            const SizedBox(height: 16),
                            CheckboxListTile(
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                              title: const Text(
                                  'I agree to the Terms and Conditions'),
                            ),
                            const SizedBox(height: 24),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      if (selectedStockvelId != null) {
                                        _joinSkovel(
                                            selectedStockvelId!); // Pass stokvelId here
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please select a Stokvel!");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFA78A52),
                                    ),
                                    child: const Text('Join Stokvel'),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String labelText,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
