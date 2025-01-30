import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otela_investment_club_app/screens/my_profile_bank_details_screen.dart';

class PersonalKycScreen extends StatefulWidget {
  const PersonalKycScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalKycScreenState createState() => _PersonalKycScreenState();
}

class _PersonalKycScreenState extends State<PersonalKycScreen> {
  String? selectedIDType;
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  File? idPicture;
  File? taxDocument;

  Future<void> pickImage(bool isIDPicture) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isIDPicture) {
          idPicture = File(pickedFile.path);
        } else {
          taxDocument = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Finish setting up your profile",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // KYC/FICA Section
              const Text(
                "KYC/FICA",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // ID Type Dropdown
              DropdownButtonFormField<String>(
                value: selectedIDType,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                hint: const Text("ID Type"),
                items: ["National ID", "Passport", "Driver’s License"]
                    .map((id) => DropdownMenuItem(value: id, child: Text(id)))
                    .toList(),
                onChanged: (value) => setState(() => selectedIDType = value),
              ),
              const SizedBox(height: 12),

              buildTextField("ID Number", idNumberController),
              const SizedBox(height: 16),

              // Picture Upload
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Picture:"),
                  ElevatedButton(
                    onPressed: () => pickImage(true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text("Upload File"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tax PIN Section
              const Text("TAX PIN Certificate", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              buildTextField("Tax Payer Number (PIN/TIN/SSN)", taxNumberController),
              const SizedBox(height: 16),

              // Document Upload
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Document:"),
                  ElevatedButton(
                    onPressed: () => pickImage(false),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text("Upload File"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Save & Continue Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA78A52),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // Save and proceed
                   Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileBankDetailScreen()));
                },
                child: Center(
                  child: Text(
                    "Save & Continue",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back to Personal Details", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }
}
