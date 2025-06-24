import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/bank_details_screen.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  __UploadDocumentScreenState createState() => __UploadDocumentScreenState();
}

class __UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final TextEditingController taxNumberController = TextEditingController();
  File? taxFile;
  File? domiciliumFile;
  String? taxFileUrl;
  String? domiciliumFileUrl;
  bool isUploading = false;

  Future<void> pickFile(bool isTaxDocument) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        if (isTaxDocument) {
          taxFile = File(result.files.single.path!);
        } else {
          domiciliumFile = File(result.files.single.path!);
        }
      });
    }
  }

  Future<void> uploadFile(File file, bool isTaxDocument) async {
    setState(() {
      isUploading = true;
    });

    try {
      String fileName = file.path.split('/').last;
      Reference storageRef =
          FirebaseStorage.instance.ref().child("documents/$fileName");
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        if (isTaxDocument) {
          taxFileUrl = downloadUrl;
        } else {
          domiciliumFileUrl = downloadUrl;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File uploaded successfully: $fileName")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }

    setState(() {
      isUploading = false;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           const SizedBox(height: 30),
  //           const Text("TAX PIN Certificate",
  //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
  //           const SizedBox(height: 15),
  //           buildInputField("Tax number (PIN/TIN/SSN)", taxNumberController),
  //           const SizedBox(height: 10),
  //           buildUploadSection("Document:", taxFile, taxFileUrl, () => pickFile(true), () => uploadFile(taxFile!, true)),
  //           const SizedBox(height: 30),
  //           const Text("Domicilium",
  //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
  //           const SizedBox(height: 10),
  //           buildUploadSection("Document:", domiciliumFile, domiciliumFileUrl, () => pickFile(false), () => uploadFile(domiciliumFile!, false)),
  //           const SizedBox(height: 30),
  //           isUploading ? const CircularProgressIndicator() : buildSaveButton(),
  //           const SizedBox(height: 15),
  //           TextButton(
  //             onPressed: () {},
  //             child: const Text(
  //               "Back to Stokvel Details",
  //               style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
              children:  [
                Text("My Profile",
                    style: Theme.of(context).textTheme.displayLarge),
                SizedBox(height: 4),
                Text("Finish Setting up your profile",
                   style: Theme.of(context).textTheme.titleLarge),
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
            const SizedBox(height: 8), // Spacing
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
                      const SizedBox(height: 10),
                      const ProgressStepper(),
                      const SizedBox(height: 20),
                      const Center(
                          child: Text("TAX PIN Certificate",
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.darBlue))),
                      const SizedBox(height: 15),
                      buildInputField(
                          "Tax number (PIN/TIN/SSN)", taxNumberController),
                      const SizedBox(height: 15),
                      buildUploadSection(
                          "Document:",
                          taxFile,
                          taxFileUrl,
                          () => pickFile(true),
                          () => uploadFile(taxFile!, true)),
                      const SizedBox(height: 20),
                      const Center(
                          child: Text("Domicilium",
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.darBlue))),
                      const SizedBox(height: 10),
                      _buildDomiciliumList(),
                      const SizedBox(height: 20),
                      buildUploadSection(
                          "Document:",
                          domiciliumFile,
                          domiciliumFileUrl,
                          () => pickFile(false),
                          () => uploadFile(domiciliumFile!, false)),
                      const SizedBox(height: 30),
                      isUploading
                          ? const CircularProgressIndicator()
                          : buildSaveButton(),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Back to Stokvel Details",
                          style: TextStyle(
                              fontSize: 12,
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

  Widget buildInputField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.titleMedium,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

 Widget buildUploadSection(
    String title,
    File? file,
    String? fileUrl,
    VoidCallback onPick,
    VoidCallback onUpload,
  ) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darBlue),
            ),
            ElevatedButton(
              onPressed: onPick,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Upload File",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        if (file != null)
          Text(
            file.path.split('/').last,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        if (file != null)
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onUpload,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text("Upload",
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        if (fileUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text("Uploaded: $fileUrl",
                style: const TextStyle(color: Colors.green, fontSize: 12)),
          ),
      ],
    ),
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
      child:  Text(
        "Save & Continue",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildDomiciliumList() {
    List<String> docs = ["Agreement", "Policies", "Members contacts"];
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: Icon(Icons.description, color: Colors.white),
                  title: Text(docs[index],
                      style:
                          TextStyle(fontSize: 10, color: AppColors.darBlue)));
              // return Text(members[index], style: TextStyle(fontSize: 16));
            },
          ),
          SizedBox(height: 10)
        ],
      ),
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
          children: [
            buildStep("Stokvel", AppColors.beige, true),
            buildStep("Tax & Domicilium", AppColors.beige, true),
            buildStep("Banking Details", AppColors.darBlue, true),
          ],
        ));
  }

  Widget buildStep(String title, Color selectedColor, bool isChecked) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selectedColor, size: 12),
          SizedBox(width: 3),
          Text(title, style: TextStyle(fontSize: 10, color: AppColors.darBlue)),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
