
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otela_investment_club_app/screens/personal_kyc_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  String fullName = "";
  String firstName = "";
  String lastName = "";
  String phoneNumber = "";
  String email = "";
  String gender = "";
  String dob = "";
  String selectedCountry = "";
  List<String> countryList = ['South Africa', 'Kenya', 'Nigeria', 'Uganda'];
   bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
   User? user = _auth.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          fullName = "${userDoc['firstName']} ${userDoc['lastName']}";
          phoneNumber = userDoc['phone'] ?? "";
          email = userDoc['email'] ?? "";
          gender = userDoc['gender'] ?? "";
          dob = userDoc['dob'] ?? "";
          selectedCountry = userDoc['country'] ?? "";
          isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching user data: $error");
      Fluttertoast.showToast(msg: "Error loading profile", backgroundColor: Colors.red);
      setState(() {
        isLoading = false;
      });
    }
  }

   Future<void> saveUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'gender': gender,
        'dob': dob,
        'country': selectedCountry,
      }, SetOptions(merge: true)); // Prevent overwriting existing fields

      Fluttertoast.showToast(msg: "Profile updated successfully", backgroundColor: Colors.green);

      Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalKycScreen()));
    } catch (error) {
      print("Error updating profile: $error");
      Fluttertoast.showToast(msg: "Failed to update profile", backgroundColor: Colors.red);
    }
  }

 
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildReadOnlyField("Full Name", fullName),
                  buildReadOnlyField("Phone Number", phoneNumber),
                  buildReadOnlyField("Email", email),

                  TextFormField(
                    initialValue: gender,
                    decoration: InputDecoration(labelText: "Gender"),
                    onChanged: (value) {
                      setState(() { gender = value; });
                    },
                  ),
                  TextFormField(
                    initialValue: dob,
                    decoration: InputDecoration(labelText: "Date of Birth"),
                    onChanged: (value) {
                      setState(() { dob = value; });
                    },
                  ),

                  DropdownButtonFormField(
                    value: selectedCountry.isNotEmpty ? selectedCountry : null,
                    decoration: InputDecoration(labelText: "Country of Residence"),
                    items: countryList.map((country) {
                      return DropdownMenuItem(value: country, child: Text(country));
                    }).toList(),
                    onChanged: (value) {
                      setState(() { selectedCountry = value.toString(); });
                    },
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: saveUserData,
                    child: Text("Save & Continue"),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        readOnly: true,
      ),
    );
  }
}