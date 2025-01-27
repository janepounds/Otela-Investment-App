import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _isChecked = false; // To manage the checkbox state
  String _selectedCountryCode = '+1'; // Default country code

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final Map<String, TextEditingController> _controllers = {};

  String errorMessage = '';


  final List<String> _countryCodes = [
    '+1',
    '+44',
    '+27',
    '+91',
    '+61'
  ]; // List of country codes

// Initialize controllers for each field
  @override
  void initState() {
    super.initState();
    _controllers['First Name'] = TextEditingController();
    _controllers['Last Name'] = TextEditingController();
    _controllers['Email'] = TextEditingController();
  }


  // Dispose all controllers to free up resources
  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
  void _validateAndSignUp() {
  if (!_isChecked) {
    setState(() {
      errorMessage = 'Please agree to the Terms and Conditions.';
    });
    return;
  }
  if (_nameController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _controllers['Phone Number']!.text.isEmpty) {
    setState(() {
      errorMessage = 'All fields are required.';
    });
    return;
  }
  // Call the sign-up method if everything is valid
  _signUp();
}


  Future<void> _signUp() async {
    try {
      // Create a user using Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // After creating the user, store additional info in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      // Redirect to the home or login screen
      Navigator.pushReplacementNamed(context, '/login'); // Replace with your desired screen
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'An error occurred';
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Main Content Area with Scroll
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                'Create Account',
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
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        // Form background color
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              30), // Curve only the top-right corner
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildTextField('First Name'),
                          const SizedBox(height: 16),
                          _buildTextField('Last Name'),
                          const SizedBox(height: 16),
                          _buildTextField('Email'),
                          const SizedBox(height: 16),

                          // Phone Number Field
                          Row(
                            children: [
                              // Country Code Dropdown
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
                              const SizedBox(width: 12),
                              Expanded(child: _buildTextField('Phone Number')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField('Password', obscureText: true),
                          const SizedBox(height: 16),
                          _buildTextField('Confirm Password',
                              obscureText: true),
                          const SizedBox(height: 16),

                          // Terms and Conditions
                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Align text with the checkbox
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to Terms and Conditions
                                  },
                                  child: const Text.rich(
                                    TextSpan(
                                      text: 'I agree to the ',
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: TextStyle(
                                            color: Color(0xFF113293),
                                             fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,                                               
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Sign Up Button
                          ElevatedButton(
                            onPressed: _validateAndSignUp,
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
                        ],
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

  // Helper to create text fields
Widget _buildTextField(
  String labelText, {
  bool obscureText = false,
  TextEditingController? controller,
}) {
  return TextFormField(
    controller: controller ?? _controllers[labelText],
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    ),
  );
}

}
