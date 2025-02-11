import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/investing/bank_transfer_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethod = "bank_transfer";
  String _selectedDepositType = "once_off";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Payment Method",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'poppins',
            ),
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
              const SizedBox(height: 20),
              const Center(
                  child: Text(
                "Select a payment method",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darBlue),
              )),
              const SizedBox(height: 40),
              // Summary Card (Removed Expanded)

              // 🔹 Payment Selection Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 🔹 Bank Transfer Option
                    RadioListTile(
                      value: "bank_transfer",
                      groupValue: _selectedMethod,
                      activeColor: AppColors.darBlue, // Set custom color
                      onChanged: (value) {
                        setState(() {
                          _selectedMethod = value.toString();
                        });
                      },
                      title: const Text(
                        "Bank Transfer",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.darBlue),
                      ),
                      subtitle: const Text(
                        "+0 Fees.\nTransfer can take up to 2 days processing.",
                        style:
                            TextStyle(fontSize: 12, color: AppColors.darBlue),
                      ),
                    ),

                    // 🔹 PayPal Option
                    RadioListTile(
                      value: "paypal",
                      groupValue: _selectedMethod,
                      activeColor: AppColors.darBlue, // Set custom color
                      onChanged: (value) {
                        setState(() {
                          _selectedMethod = value.toString();
                        });
                      },
                      title: Row(
                        children: [
                          Image.asset('assets/images/paypal.png',
                              width: 20), // Add PayPal logo
                          const SizedBox(width: 8),
                          const Text(
                            "PayPal",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.darBlue),
                          ),
                        ],
                      ),
                      subtitle: const Text(
                        "+0 Fees.\nTransfer can take up to 1 day processing.\nOnly Once-off Deposits allowed.",
                        style:
                            TextStyle(fontSize: 12, color: AppColors.darBlue),
                      ),
                    ),

                    // 🔹 Deposit Type Selection
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Recurring Deposit
                        Row(
                          children: [
                            Radio(
                              value: "recurring",
                              groupValue: _selectedDepositType,
                              activeColor:
                                  AppColors.darBlue, // Set custom color
                              onChanged: (value) {
                                setState(() {
                                  _selectedDepositType = value.toString();
                                });
                              },
                            ),
                            const Text(
                              "Recurring Deposit",
                              style: TextStyle(color: AppColors.darBlue),
                            ),
                          ],
                        ),

                        // Once-off Deposit
                        Row(
                          children: [
                            Radio(
                              value: "once_off",
                              groupValue: _selectedDepositType,
                              activeColor:
                                  AppColors.darBlue, // Set custom color
                              onChanged: (value) {
                                setState(() {
                                  _selectedDepositType = value.toString();
                                });
                              },
                            ),
                            const Text(
                              "Once-off Deposit",
                              style: TextStyle(color: AppColors.darBlue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Payment Summary Fields
              _buildSummaryRow("Fund Name:", "",
                  style: TextStyle(
                      color: AppColors.darBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              _buildSummaryRow("How much am I paying now?", "",
                  style: TextStyle(
                      color: AppColors.beige,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              _buildSummaryRow("Amount Selected:", "",
                  style: TextStyle(
                      color: AppColors.darBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              _buildSummaryRow("Traction Fees:", "",
                  style: TextStyle(
                      color: AppColors.darBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              _buildSummaryRow("Pay Now:", "",
                  style: TextStyle(color: AppColors.darBlue)),
              _buildSummaryRow("How much will get invested?", "",
                  style: TextStyle(
                      color: AppColors.beige,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              _buildSummaryRow("Otela Fees:", "",
                  style: TextStyle(
                      color: AppColors.darBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              _buildSummaryRow("Total Invested:", "",
                  style: TextStyle(
                      color: AppColors.darBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),

              const SizedBox(height: 10),

              // 🔹 Transfer Fees Notice
              const Text(
                "Your bank or mobile operator might apply transfer fees.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.darBlue, fontSize: 12),
              ),

              // 🔹 Action Buttons
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton("Cancel", Colors.amber, () {
                    Navigator.pop(context);
                  }),
                  _buildButton("Pay Now", Colors.blue, () {
                    // Handle Payment

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BankTransferScreen()),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Summary Text Row
  Widget _buildSummaryRow(String title, String value,
      {required TextStyle style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: style,
          ),
          Text(value,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // 🔹 Custom Button
  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
