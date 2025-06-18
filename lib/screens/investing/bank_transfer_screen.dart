import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/investing/success_screen.dart';

class BankTransferScreen extends StatefulWidget {
  const BankTransferScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BankTransferScreenState createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:  Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Bank Transfer",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.menu,
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
                    const SizedBox(height: 10),
                    const Center(
                        child: Text(
                      "Pay with Bank Transfer",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darBlue),
                    )),
                    const SizedBox(height: 20),
                    // Summary Card (Removed Expanded)

                    // 🔹 Account Details Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBoldText("Account Number:"),
                          _buildDetailText("Account Name:"),
                          _buildDetailText("Bank Branch:"),
                          _buildDetailText("Swift Code:"),
                          _buildDetailText("Address:"),
                          _buildDetailText("Email:"),
                          const SizedBox(height: 10),
                          _buildBoldText("Amount Invested:"),
                          _buildDetailText("Bank Fees:"),
                          _buildDetailText("Otela Fees:"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Payment Instructions
                    const Text(
                      "Please make sure to:",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.beige),
                    ),
                    const SizedBox(height: 5),
                    _buildInstructionText(
                        "1. Cover all bank transfer charges from your side to ensure that your full investment amount is received by our bank."),
                    _buildInstructionText(
                        "2. Specify the exact investment amount and exact reference while you make the bank transfer to avoid any delays."),
                    const SizedBox(height: 10),
                    const Text(
                      "Once you have completed the operation, please proceed to select the checkbox below:",
                      style: TextStyle(fontSize: 14, color: AppColors.darBlue),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                          activeColor:
                              AppColors.darBlue, // Customize checkbox color
                        ),
                        const Text(
                          "I have transferred the money.",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darBlue),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20), // Pushes buttons to bottom

                    // 🔹 Action Buttons
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildButton("Cancel", AppColors.beige, () {
                            Navigator.pop(context);
                          }),
                          _buildButton("Confirm Payment", AppColors.beige, () {
                            if (_isChecked) {
                              // Handle Confirmation Logic

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SuccessScreen()),
                              );
                              print("Payment Confirmed");
                            } else {
                              // Show error if checkbox is not selected
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please confirm the transfer before proceeding."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }),
                        ]),
                  ]))),
    );
  }

  // 🔹 Bold Text Widget
  Widget _buildBoldText(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darBlue),
    );
  }

  // 🔹 Detail Text Widget
  Widget _buildDetailText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: AppColors.darBlue),
    );
  }

  // 🔹 Instruction Text Widget
  Widget _buildInstructionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.darBlue),
      ),
    );
  }

  // 🔹 Button Widget
  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
