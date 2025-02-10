import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/upload_document_screen.dart';

class StokvelDetailsScreen extends StatefulWidget {
  const StokvelDetailsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StokvelDetailsScreenState createState() => _StokvelDetailsScreenState();
}

class _StokvelDetailsScreenState extends State<StokvelDetailsScreen> {
  List<TextEditingController> stokvelNameController = [];
  List<TextEditingController> stokvelRegistrationController = [];
  List<TextEditingController> stokvelAdminController = [];
  final TextEditingController phoneController =
      TextEditingController(text: "123456789");
  Map<String, String> adminCache = {}; // 🔥 Cache Admin Names

  List<String> adminNames = [];
  List<String> stokvelIds = []; // 🔥 Store Stokvel IDs

  String selectedCountryCode = "+27"; // Default country code
  final List<String> members = List.generate(10, (index) => "Item $index");

  Stream<QuerySnapshot> fetchUserStokvels() {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    var query = FirebaseFirestore.instance
        .collection('stokvels')
        .where('createdBy', isEqualTo: currentUserId);

    // 🔹 Listen once and print documents (for debugging)
    query.snapshots().listen((snapshot) {
      print("🔥 Fetching stokvels for user: $currentUserId");
      if (snapshot.docs.isEmpty) {
        print("🚨 No stokvels found.");
      } else {
        for (var doc in snapshot.docs) {
          print("📌 Stokvel ID: ${doc.id}");
          print("📌 Data: ${doc.data()}");
        }
      }
    }, onError: (e) {
      print("❌ Firestore error: $e");
    });

    // ✅ Return the original stream for UI
    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(color: AppColors.beige),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stokvel",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'poppins',
                  ),
                ),
                SizedBox(height: 5),
                Text("Finish setting up your stokvel",
                    style: TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const ProgressStepper(),
              const SizedBox(height: 20),
              _buildSectionTitle("Stokvel Details"),
              SizedBox(height: 30),

              // 🔄 Firestore Data Section
              StreamBuilder<QuerySnapshot>(
                stream: fetchUserStokvels(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("🚨 No Stokvels Found"));
                  }

                  var stokvels = snapshot.data!.docs;
                  return Column(
                    children: stokvels.map((stokvelDoc) {
                      var stokvelData =
                          stokvelDoc.data() as Map<String, dynamic>;
                      String stokvelId = stokvelDoc.id;
                      String createdBy = stokvelData['createdBy'];

                      return FutureBuilder<String>(
                        future: getAdminName(createdBy),
                        builder: (context, adminSnapshot) {
                          String adminName =
                              adminSnapshot.data ?? "Fetching...";

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextField(
                                    "Stokvel Name",
                                    TextEditingController(
                                        text: stokvelData['stokvelName'] ??
                                            "N/A")),
                                SizedBox(height: 10),
                                _buildTextField(
                                    "Registration Number",
                                    TextEditingController(
                                        text: stokvelData['stokvelNumber'] ??
                                            "N/A")),
                                SizedBox(height: 10),
                                _buildTextField("Stokvel Admin",
                                    TextEditingController(text: adminName)),
                                SizedBox(height: 10),
                                _buildPhoneNumberField(),
                                SizedBox(height: 20),
                                _buildSectionTitle("Members"),
                                SizedBox(height: 10),
                                _buildMembersList(stokvelId),
                                SizedBox(height: 20),
                                _buildSaveButton(),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔍 Efficiently Fetch Admin Name with Caching
  Future<String> getAdminName(String userId) async {
    if (adminCache.containsKey(userId)) {
      return adminCache[userId]!;
    }

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      String firstName = userDoc['firstName'] ?? "";
      String lastName = userDoc['lastName'] ?? "";
      String phone = userDoc['phone'] ?? "123456789";
      String fullName = "$firstName $lastName";
      adminCache[userId] = fullName; // 🔥 Cache the name
      return fullName;
    }

    return "Unknown Admin";
  }

  Stream<QuerySnapshot> fetchStokvelMembers(String stokvelId) {
    return FirebaseFirestore.instance
        .collection('stokvels')
        .doc(stokvelId)
        .collection('members')
        .snapshots();
  }

  Widget _buildSectionTitle(String title) {
    return Center(
        child: Text(
      title,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darBlue),
    ));
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: DropdownButton<String>(
            value: selectedCountryCode,
            onChanged: (newValue) {
              setState(() {
                selectedCountryCode = newValue!;
              });
            },
            items: ["+27", "+254", "+256", "+233"].map((code) {
              return DropdownMenuItem(
                child: Text(code),
                value: code,
              );
            }).toList(),
            underline: SizedBox(),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Phone Number",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersList(String stokvelId) {
    return StreamBuilder<QuerySnapshot>(
        stream: fetchStokvelMembers(stokvelId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var members = snapshot.data!.docs;

          if (members.isEmpty) {}
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
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    var member = members[index];
                    String fullName =
                        "${member['firstName']} ${member['lastName']}";
                    String phone = member['phone'];
                    String status = member['status'] ?? "Pending";
                    return ListTile(
                      title: Text(fullName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(phone),
                      trailing: Text(status,
                          style: TextStyle(color: AppColors.darBlue)),
                    );
                    // return Text(members[index], style: TextStyle(fontSize: 16));
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // members.add("Item ${members.length}");
                    });
                  },
                  child: Text(
                    "Add Member",
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.darBlue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle save action

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UploadDocumentScreen()),
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
          "Save & Continue",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
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
            buildStep("Tax & Domicilium", AppColors.darBlue, true),
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
              color: selectedColor, size: 20),
          SizedBox(width: 4),
          Text(title, style: TextStyle(fontSize: 12, color: AppColors.darBlue)),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
