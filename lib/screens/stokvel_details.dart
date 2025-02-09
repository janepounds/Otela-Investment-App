import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';

class StokvelDetailsScreen extends StatefulWidget {
  const StokvelDetailsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StokvelDetailsScreenState createState() => _StokvelDetailsScreenState();
}

class _StokvelDetailsScreenState extends State<StokvelDetailsScreen> {
  final TextEditingController stokvelNameController =
      TextEditingController(text: "My Stokvel");
  final TextEditingController stokvelRegistrationController =
      TextEditingController(text: "12345");
  final TextEditingController stokvelAdminController =
      TextEditingController(text: "John Doe");
  final TextEditingController phoneController =
      TextEditingController(text: "123456789");

  String selectedCountryCode = "+27"; // Default country code
  // final List<String> members = List.generate(10, (index) => "Item $index");

  Stream<QuerySnapshot> fetchUserStokvels() {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('stokvels')
        .where(Filter.or(
            Filter("admin", isEqualTo: currentUserId), // If user is an admin
            Filter("members",
                arrayContains: currentUserId) // If user is in members list
            ))
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: Color(
              0xFFD4AF37, // Gold color
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Stokvel",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 5),
                Text("Finish setting up your stokvel",
                    style: TextStyle(fontSize: 14, color: Colors.white70)),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ProgressStepper(),
            _buildSectionTitle("Stokvel Details"),
            SizedBox(height: 10),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: fetchUserStokvels(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var stokvelDocs = snapshot.data!.docs;

                if (stokvelDocs.isEmpty) {
                  return ListView.builder(
                    itemCount: 1, // Only one item (default result)
                    itemBuilder: (context, index) {
                      // Default data to display

                      var stokvel = stokvelDocs[index];
                      String stokvelId = stokvel.id;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildTextField("Stokvel Name",
                                stokvel['stokvelName'] ?? "N/A"),
                            SizedBox(height: 10),
                            _buildTextField("Registration Number",
                                stokvel['stokvelNumber'] ?? "N/A"),
                            SizedBox(height: 10),
                            _buildTextField(
                                "Stokvel Admin", stokvelAdminController),
                            SizedBox(height: 10),
                            _buildPhoneNumberField(),
                            SizedBox(height: 20),
                            _buildSectionTitle("Members"),
                            _buildMembersList(stokvelId),
                            SizedBox(height: 20),
                            _buildSaveButton(),
                          ],
                        ),
                      );
                    },
                  );
                }

                //if not empty
                return ListView.builder(
                    itemCount: 1, // Only one item (default result)
                    itemBuilder: (context, index) {
                      // Default data to display

                      var stokvel = stokvelDocs[index];
                      String stokvelId = stokvel.id;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildTextField("Stokvel Name",
                                stokvel['stokvelName'] ?? "N/A"),
                            SizedBox(height: 10),
                            _buildTextField("Registration Number",
                                stokvel['stokvelNumber'] ?? "N/A"),
                            SizedBox(height: 10),
                            _buildTextField(
                                "Stokvel Admin", stokvelAdminController),
                            SizedBox(height: 10),
                            _buildPhoneNumberField(),
                            SizedBox(height: 20),
                            _buildSectionTitle("Members"),
                            _buildMembersList(stokvelId),
                            SizedBox(height: 20),
                            _buildSaveButton(),
                          ],
                        ),
                      );
                    },
                  );
              },
            ))
          ],
        ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]),
    );
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

          if (members.isEmpty) {
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
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
                        //members.add("Item ${members.length}");
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
          }

          //if not empty
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
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
                        //members.add("Item ${members.length}");
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
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.beige, // Gold color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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
            buildStep("Stokvel", Colors.amber.shade600, true),
            buildStep("Tax & Domicilium", Colors.blue.shade900, true),
            buildStep("Banking Details", Colors.blue.shade900, true),
          ],
        ));
  }

  Widget buildStep(String title, Color color, bool isChecked) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
              color: AppColors.darBlue, size: 20),
          SizedBox(width: 4),
          Text(title, style: TextStyle(fontSize: 12, color: AppColors.darBlue)),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
