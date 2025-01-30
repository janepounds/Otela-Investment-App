import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StokvelDetailsScreen extends StatefulWidget {
  const StokvelDetailsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StokvelDetailsScreenState createState() => _StokvelDetailsScreenState();
}

class _StokvelDetailsScreenState extends State<StokvelDetailsScreen> {
  Stream<QuerySnapshot> fetchUserStokvels() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('stokvels') // Collection storing stokvels
          .where('createdBy', isEqualTo: user.uid) // Fetch only user's stokvels
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              color: const Color(0xFFA78A52),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Stokvel',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Finish setting up your stokvel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const ProgressStepper(),
            const SizedBox(height: 20),
            const Text(
              "Stokvel Details",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 20),

            // Fetch Stokvel Data
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fetchUserStokvels(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var stokvelDocs = snapshot.data!.docs;

                  if (stokvelDocs.isEmpty) {
                    return const Center(child: Text("No Stokvels Found"));
                  }

                  // Fetch the first Stokvel
                  var stokvel = stokvelDocs.first;
                  String stokvelId = stokvel.id; // Get stokvel ID

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        buildInputField(
                            "Stokvel/Club", stokvel['stokvelName'] ?? "N/A"),
                        buildInputField("Registration Number",
                            stokvel['stockvelNumber'] ?? "N/A"),
                        buildInputField("Stokvel Admin", "Test"),
                        buildPhoneInputField(),
                        const SizedBox(height: 20),
                        buildMembersList(stokvelId), // Pass stokvelId here
                        const SizedBox(height: 20),
                        buildSaveButton(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(value,
                style: const TextStyle(fontSize: 16, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget buildPhoneInputField() {
    return buildInputField("Admin Number", "+27 73 987 6543");
  }

  // Widget buildMembersList() {
  //   List<Map<String, String>> members = [
  //     {"name": "Linda K. (ADMIN)", "status": "", "action": "Edit"},
  //     {"name": "Miriam O", "status": "(Pending Approval)", "action": "Edit"},
  //     {"name": "Tebogo S", "status": "(Approve)", "action": "Edit"},
  //     {"name": "Popi N", "status": "(Approve)", "action": "Edit"},
  //     {"name": "Sam T", "status": "(Declined)", "action": "Edit"},
  //   ];

  //   return Container(
  //     padding: const EdgeInsets.all(15),
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade200,
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text("Members",
  //             style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.blue)),
  //         const SizedBox(height: 5),
  //         ...members.asMap().entries.map((entry) {
  //           int index = entry.key + 1;
  //           Map<String, String> member = entry.value;
  //           return Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text("$index. ${member['name']} ${member['status']}",
  //                   style: const TextStyle(fontSize: 14)),
  //               TextButton(
  //                 onPressed: () {},
  //                 child: Text(member['action']!,
  //                     style: const TextStyle(
  //                         color: Colors.blue, fontWeight: FontWeight.bold)),
  //               ),
  //             ],
  //           );
  //         }).toList(),
  //         TextButton(
  //           onPressed: () {},
  //           child: const Text("Add Member",
  //               style:
  //                   TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildMembersList(String stokvelId) {
    return StreamBuilder<QuerySnapshot>(
      stream: fetchStokvelMembers(stokvelId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var members = snapshot.data!.docs;

        if (members.isEmpty) {
          return const Center(child: Text("No members yet."));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: members.length,
          itemBuilder: (context, index) {
            var member = members[index];
            String fullName = "${member['firstName']} ${member['lastName']}";
            String phone = member['phone'];
            String status = member['status'] ?? "Pending"; // Default status

            return ListTile(
              title:
                  Text(fullName, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(phone),
              trailing: Text(status, style: TextStyle(color: Colors.blue)),
            );
          },
        );
      },
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

  Stream<QuerySnapshot> fetchStokvelMembers(String stokvelId) {
    return FirebaseFirestore.instance
        .collection('stokvels')
        .doc(stokvelId)
        .collection('members')
        .snapshots();
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
          buildStep("Tax & Domicilium", Colors.blue.shade900),
          buildStep("Banking Details", Colors.blue.shade900),
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
}
