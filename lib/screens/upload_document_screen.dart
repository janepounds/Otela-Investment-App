import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
      Reference storageRef = FirebaseStorage.instance.ref().child("documents/$fileName");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text("TAX PIN Certificate",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 15),
            buildInputField("Tax number (PIN/TIN/SSN)", taxNumberController),
            const SizedBox(height: 10),
            buildUploadSection("Document:", taxFile, taxFileUrl, () => pickFile(true), () => uploadFile(taxFile!, true)),
            const SizedBox(height: 30),
            const Text("Domicilium",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 10),
            buildUploadSection("Document:", domiciliumFile, domiciliumFileUrl, () => pickFile(false), () => uploadFile(domiciliumFile!, false)),
            const SizedBox(height: 30),
            isUploading ? const CircularProgressIndicator() : buildSaveButton(),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Back to Stokvel Details",
                style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget buildUploadSection(String title, File? file, String? fileUrl, VoidCallback onPick, VoidCallback onUpload) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            file != null
                ? Expanded(child: Text(file.path.split('/').last, style: const TextStyle(color: Colors.black54)))
                : const SizedBox(),
            ElevatedButton(
              onPressed: onPick,
              child: const Text("Pick File", style: TextStyle(color: Colors.white)),
            ),
            if (file != null)
              ElevatedButton(
                onPressed: onUpload,
                child: const Text("Upload", style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
        if (fileUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text("Uploaded: $fileUrl", style: const TextStyle(color: Colors.green, fontSize: 12)),
          ),
      ],
    );
  }

  Widget buildSaveButton() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text("Save & Continue"),
    );
  }
}
