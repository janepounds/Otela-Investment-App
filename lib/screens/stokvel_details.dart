import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/upload_document_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StokvelDetailsScreen extends StatefulWidget {
  const StokvelDetailsScreen({super.key});

  @override
  State<StokvelDetailsScreen> createState() => _StokvelDetailsScreenState();
}

class _StokvelDetailsScreenState extends State<StokvelDetailsScreen> {
  final TextEditingController phoneController =
      TextEditingController(text: "123456789");

  String selectedCountryCode = "+27";
  final Map<String, String> adminCache = {};

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Query fetchUserStokvels(String userId) {
    return FirebaseDatabase.instance
        .ref('stokvels')
        .orderByChild('createdBy')
        .equalTo(userId);
  }

  Stream<DatabaseEvent> fetchStokvelMembers(String stokvelId) {
    return FirebaseDatabase.instance.ref('stokvels/$stokvelId/members').onValue;
  }

  Future<Map?> getUserById(String userId) async {
    final snapshot =
        await FirebaseDatabase.instance.ref('users/$userId').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  Future<String> getAdminName(String userId) async {
    if (adminCache.containsKey(userId)) return adminCache[userId]!;

    final user = await getUserById(userId);
    if (user != null) {
      String fullName = "${user['firstName']} ${user['lastName']}";
      adminCache[userId] = fullName;
      return fullName;
    }
    return "Unknown Admin";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FutureBuilder<String?>(
        future: getUserId(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final userId = snapshot.data!;
          return StreamBuilder<DatabaseEvent>(
            stream: fetchUserStokvels(userId).onValue,
            builder: (context, event) {
              if (!event.hasData || event.data!.snapshot.value == null) {
                return const Center(child: Text("🚨 No Stokvels Found"));
              }

              final data = Map<String, dynamic>.from(
                  event.data!.snapshot.value as Map);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.entries.map((entry) {
                    final stokvelId = entry.key;
                    final stokvelData =
                        Map<String, dynamic>.from(entry.value as Map);

                    return FutureBuilder<String>(
                      future: getAdminName(stokvelData['createdBy']),
                      builder: (context, adminSnapshot) {
                        String adminName = adminSnapshot.data ?? "Fetching...";

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              _buildTextField("Stokvel Name",
                                  stokvelData['stokvelName'] ?? "N/A"),
                              const SizedBox(height: 10),
                              _buildTextField("Registration Number",
                                  stokvelData['stokvelNumber'] ?? "N/A"),
                              const SizedBox(height: 10),
                              _buildTextField("Stokvel Admin", adminName),
                              const SizedBox(height: 10),
                              _buildPhoneNumberField(),
                              const SizedBox(height: 20),
                              _buildSectionTitle("Members"),
                              const SizedBox(height: 10),
                              _buildMembersList(stokvelId),
                              const SizedBox(height: 30),
                              _buildSaveButton(),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        decoration: const BoxDecoration(color: AppColors.beige),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Stokvel",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'poppins')),
              SizedBox(height: 5),
              Text("Finish setting up your stokvel",
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return TextFormField(
      readOnly: true,
      initialValue: value,
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                value: code,
                child: Text(code),
              );
            }).toList(),
            underline: const SizedBox(),
          ),
        ),
        const SizedBox(width: 10),
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
    return StreamBuilder<DatabaseEvent>(
      stream: fetchStokvelMembers(stokvelId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Text("No members yet.");
        }

        final members = Map<String, dynamic>.from(
            snapshot.data!.snapshot.value as Map);

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: members.entries.map((entry) {
              final memberData =
                  Map<String, dynamic>.from(entry.value as Map);
              final fullName =
                  "${memberData['firstName']} ${memberData['lastName']}";
              final phone = memberData['phone'];
              final status = memberData['status'] ?? "Pending";

              return ListTile(
                title: Text(fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(phone),
                trailing:
                    Text(status, style: const TextStyle(color: AppColors.darBlue)),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
        child: Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darBlue)));
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const UploadDocumentScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.beige,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        child: const Text(
          "Save & Continue",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
