import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';

class BankDetailscreen extends StatefulWidget {
  const BankDetailscreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailscreen> {
  String? selectedBank;
  String? selectedAccountType;
  final TextEditingController accountNumberController = TextEditingController();

  final List<String> banks = [
    "Standard Bank",
    "ABSA",
    "FNB",
    "Nedbank",
    "Capitec"
  ];
  final List<String> accountTypes = ["Savings", "Current", "Business"];

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
                Text("My Profile",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins')),
                SizedBox(height: 4),
                Text("Finish Setting up your profile",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'poppins')),
              ],
            ),
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 16.0),
          //     child: Image.asset('assets/images/logo_no_text.png',
          //         width: 50, height: 50),
          //   ),
          // ],
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
                      const SizedBox(height: 30),
                      const ProgressStepper(),
                      const SizedBox(height: 20),
                      const Center(
                          child: Text("Banking Details",
                              style: TextStyle(
                                  fontSize: 22, color: AppColors.darBlue))),
                      const SizedBox(height: 15),
                      buildDropdownField("Bank", selectedBank, banks, (value) {
                        setState(() {
                          selectedBank = value;
                        });
                      }),
                      buildDropdownField(
                          "Account Type", selectedAccountType, accountTypes,
                          (value) {
                        setState(() {
                          selectedAccountType = value;
                        });
                      }),
                      _buildTextField(
                        labelText: 'Account Number',
                        controller: accountNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter  Account number.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      buildSaveButton(),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Back to Tax & Domicilium",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  //new footer
                ),
              ),
            ),
          ],
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   // Header Section
  //                   Container(
  //                     width: double.infinity,
  //                     color: const Color(0xFFA78A52), // Header background color
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 16, vertical: 24),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: const [
  //                             Text(
  //                               'Stokvel',
  //                               style: TextStyle(
  //                                 fontSize: 24,
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                             SizedBox(height: 4),
  //                             Text(
  //                               'Finish setting up your stokvel',
  //                               style: TextStyle(
  //                                 fontSize: 16,
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         const Icon(
  //                           Icons.menu, // Example menu icon
  //                           color: Colors.white,
  //                           size: 30,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   const ProgressStepper(),
  //                   const SizedBox(height: 20),
  //                   const Text(
  //                     "Banking Details",
  //                     style: TextStyle(
  //                         fontSize: 24,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.blue),
  //                   ),
  //                   const SizedBox(height: 30),
  //                   buildDropdownField("Bank", selectedBank, banks, (value) {
  //                     setState(() {
  //                       selectedBank = value;
  //                     });
  //                   }),
  //                   buildDropdownField(
  //                       "Account Type", selectedAccountType, accountTypes,
  //                       (value) {
  //                     setState(() {
  //                       selectedAccountType = value;
  //                     });
  //                   }),
  //                   buildInputField("Account Number", ""),
  //                   const SizedBox(height: 30),
  //                   buildSaveButton(),
  //                   const SizedBox(height: 15),
  //                   TextButton(
  //                     onPressed: () {},
  //                     child: const Text(
  //                       "Back to Tax & Domicilium",
  //                       style: TextStyle(
  //                           fontSize: 14,
  //                           color: Colors.blue,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

  Widget buildPhoneInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Admin Number",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Image.network("https://flagcdn.com/w40/za.png",
                  width: 25), // South Africa Flag
              const SizedBox(width: 10),
              const Text("+27",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(width: 10),
              const Text("73 987 6543",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        //navigate to banking details
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BankDetailscreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.beige,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Text(
        "Save & Continue",
        style: TextStyle(color: Colors.white, fontSize: 16),
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

class ProgressStepper extends StatelessWidget {
  const ProgressStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildStep("Stokvel", Colors.amber.shade600),
          buildStep("Tax & Domicilium", Colors.amber.shade600),
          buildStep("Banking Details", Colors.amber.shade600),
        ],
      ),
    );
  }

  Widget buildStep(String title, Color color) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color,
            child: const Icon(Icons.check, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField(String title, String? selectedValue,
      List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
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

  Widget buildInputField(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Account Number",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildSaveButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber.shade700,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Text(
        "Save & Continue",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
