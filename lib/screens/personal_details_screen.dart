
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otela_investment_club_app/screens/personal_kyc_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String fullName = "";
  String phoneNumber = "";
  String email = "";
  String gender = "";
  String dob = "";
  String selectedCountry = "";
  List<String> countryList = ['South Africa', 'Kenya', 'Nigeria', 'Uganda'];

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        fullName = userDoc['fullName'] ?? "";
        phoneNumber = userDoc['phoneNumber'] ?? "";
        email = userDoc['email'] ?? "";
        gender = userDoc['gender'] ?? "";
        dob = userDoc['dob'] ?? "";
        selectedCountry = userDoc['country'] ?? countryList.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(initialValue: fullName, readOnly: true),
            Row(
              children: [
                Text("+27"),
                Expanded(child: TextFormField(initialValue: phoneNumber, readOnly: true)),
              ],
            ),
            TextFormField(initialValue: email, readOnly: true),
            TextFormField(initialValue: gender, readOnly: true),
            TextFormField(initialValue: dob, readOnly: true),
            DropdownButtonFormField(
              value: selectedCountry,
              items: countryList.map((country) {
                return DropdownMenuItem(value: country, child: Text(country));
              }).toList(),
              onChanged: (value) {
                setState(() { selectedCountry = value.toString(); });
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalKycScreen()),
                );
              },
              child: Text("Save & Continue"),
            ),
          ],
        ),
      ),
    );
  }
}