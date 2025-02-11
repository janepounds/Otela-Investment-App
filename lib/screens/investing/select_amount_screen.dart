import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/investing/payment_method_screen.dart';

class SelectAmountScreen extends StatefulWidget {
  const SelectAmountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SelectAmountScreenState createState() => _SelectAmountScreenState();
}

class _SelectAmountScreenState extends State<SelectAmountScreen> {
  String _selectedCountryCode = 'ZAR';
  final List<String> _countryCodes = ['ZAR', 'UGX', 'KSH'];
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Select Amount",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'poppins',
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                  child: Text(
                'Start your Investment Journey!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darBlue,
                ),
              )),
              const SizedBox(height: 40),
              Center(
                  child: Text(
                'How much do you want\n to invest?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.darBlue),
              )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        items: _countryCodes
                            .map(
                              (code) => DropdownMenuItem(
                                value: code,
                                child: Text(code,
                                    style: const TextStyle(fontSize: 16)),
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
                      labelText: 'Enter Amount',
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                  child: ElevatedButton(
                onPressed: () {
                  // navigate to select amount
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentMethodScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.beige, // Gold color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )),
              const SizedBox(height: 20),
            ],
          ),
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
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.gray)),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final TextEditingController amountController = TextEditingController();

  //   return Scaffold(
  //     appBar: AppBar(title: Text('Select Amount')),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           Text('Start your investment journey', style: TextStyle(fontSize: 20)),
  //           TextField(
  //             controller: amountController,
  //             keyboardType: TextInputType.number,
  //             decoration: InputDecoration(labelText: 'Amount'),
  //           ),
  //           SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, '/paymentMethod');
  //             },
  //             child: Text('Next'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
