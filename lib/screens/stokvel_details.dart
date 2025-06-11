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

  /* ---------------- helpers ---------------- */

  Future<String?> _getUserId() async =>
      (await SharedPreferences.getInstance()).getString('userId');

  Query _queryUserStokvels(String userId) => FirebaseDatabase.instance
      .ref('stokvels')
      .orderByChild('createdBy')
      .equalTo(userId);

  Stream<DatabaseEvent> _stokvelMembersStream(String stokvelId) =>
      FirebaseDatabase.instance.ref('stokvels/$stokvelId/members').onValue;

  Future<Map?> _getUserById(String userId) async {
    final snap = await FirebaseDatabase.instance.ref('users/$userId').get();
    return snap.exists ? Map<String, dynamic>.from(snap.value as Map) : null;
  }

  Future<String> _getAdminName(String userId) async {
    if (adminCache.containsKey(userId)) return adminCache[userId]!;
    final user = await _getUserById(userId);
    final name =
        user == null ? "Unknown Admin" : "${user['firstName']} ${user['lastName']}";
    adminCache[userId] = name;
    return name;
  }

  /* ---------------- UI ---------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: FutureBuilder<String?>(
        future: _getUserId(),
        builder: (context, idSnap) {
          if (!idSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userId = idSnap.data!;
          return StreamBuilder<DatabaseEvent>(
            stream: _queryUserStokvels(userId).onValue,
            builder: (context, eventSnap) {
              if (!eventSnap.hasData ||
                  eventSnap.data!.snapshot.value == null) {
                return const Center(child: Text("🚨 No Stokvels Found"));
              }

              /* ---------- pick most-recent stokvel ---------- */
              final raw = Map<String, dynamic>.from(
                  eventSnap.data!.snapshot.value as Map);
              final latestEntry = (raw.entries.toList()
                    ..sort((a, b) {
                      final aDate =
                          DateTime.tryParse(a.value['createdAt'] ?? '') ??
                              DateTime(2000);
                      final bDate =
                          DateTime.tryParse(b.value['createdAt'] ?? '') ??
                              DateTime(2000);
                      return bDate.compareTo(aDate); // newest first
                    }))
                  .first;

              final stokvelId = latestEntry.key;
              final stokvel = Map<String, dynamic>.from(latestEntry.value);

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: FutureBuilder<String>(
                    future: _getAdminName(stokvel['createdBy']),
                    builder: (context, adminSnap) {
                      final adminName = adminSnap.data ?? "Fetching...";
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _readOnly("Stokvel Name",
                              stokvel['stokvelName'] ?? "N/A"),
                          const SizedBox(height: 10),
                          _readOnly("Registration Number",
                              stokvel['stokvelNumber'] ?? "N/A"),
                          const SizedBox(height: 10),
                          _readOnly("Stokvel Admin", adminName),
                          const SizedBox(height: 10),
                          _buildPhoneNumberField(),
                          const SizedBox(height: 20),
                          _sectionTitle("Members"),
                          const SizedBox(height: 10),
                          _membersList(stokvelId),
                          const SizedBox(height: 30),
                          _saveButton(),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /* ---------- widgets ---------- */

  PreferredSizeWidget _buildAppBar() => PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          color: AppColors.beige,
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

  Widget _readOnly(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: TextFormField(
          readOnly: true,
          initialValue: value,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      );

  Widget _buildPhoneNumberField() => Row(
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
              underline: const SizedBox(),
              onChanged: (v) => setState(() => selectedCountryCode = v!),
              items: ["+27", "+254", "+256", "+233"]
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
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

  Widget _membersList(String stokvelId) => StreamBuilder<DatabaseEvent>(
        stream: _stokvelMembersStream(stokvelId),
        builder: (context, snap) {
          if (!snap.hasData || snap.data!.snapshot.value == null) {
            return const Text("No members yet.");
          }
          final members =
              Map<String, dynamic>.from(snap.data!.snapshot.value as Map);

          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: members.entries.map((e) {
                final m = Map<String, dynamic>.from(e.value);
                final name = "${m['firstName']} ${m['lastName']}";
                return ListTile(
                  title:
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(m['phone'] ?? ''),
                  trailing: Text(m['status'] ?? 'Pending',
                      style: const TextStyle(color: AppColors.darBlue)),
                );
              }).toList(),
            ),
          );
        },
      );

  Widget _sectionTitle(String t) => Center(
        child: Text(t,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darBlue)),
      );

  Widget _saveButton() => Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const UploadDocumentScreen(),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.beige,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: const Text("Save & Continue",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      );
}
