import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _isChecked = false; // To manage the checkbox state

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
        color: Colors.white, // Form background color
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30), // Curve only the top-right corner
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/south_africa.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('+27', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTextField('Phone Number')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField('Password', obscureText: true),
                          const SizedBox(height: 16),
                          _buildTextField('Confirm Password', obscureText: true),
                          const SizedBox(height: 16),

                          // Terms and Conditions
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
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
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
                            onPressed: () {
                              // Handle sign-up logic
                            },
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
                                    color: Colors.blue,
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
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4), // Footer background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '©Otela',
                    style: TextStyle(fontSize: 12, color: Colors.black),
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
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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
    );
  }

  // Helper to create text fields
  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
