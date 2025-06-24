
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

Future<String> _getUserId() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw FirebaseAuthException(message: "User not found", code: "401");
    }

    return user.uid;
  } catch (e) {
    Fluttertoast.showToast(
      msg: e.toString(),
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );

    // Return an empty string or rethrow depending on your use case
    return ''; // or you can `rethrow;` if you want the caller to handle it
  }
}


  // Future<String?> _getUserId() async =>
  //     (await SharedPreferences.getInstance()).getString('userId');

    
      final DatabaseReference db = FirebaseDatabase.instance.ref();

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

Future<String> _getAdminName(String stokvelId) async {
  final ref = FirebaseDatabase.instance.ref('stokvels/$stokvelId/members');
  final snapshot = await ref.once();

  if (snapshot.snapshot.exists) {
    final membersMap = Map<String, dynamic>.from(snapshot.snapshot.value as Map);

    for (final entry in membersMap.entries) {
      final member = Map<String, dynamic>.from(entry.value);
      if (member['role'] == 'admin') {
        final firstName = member['firstName'] ?? '';
        final lastName = member['lastName'] ?? '';
        return '$firstName $lastName';
      }
    }
  }

  return "Unknown Admin";
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

              return
               SafeArea(
                 child: LayoutBuilder(
               builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _readOnly("Stokvel Name",
                              stokvel['stokvelName'] ?? "N/A"),
                          const SizedBox(height: 10),
                          _readOnly("Registration Number",
                              stokvel['stokvelNumber'] ?? "N/A"),
                          const SizedBox(height: 10),
                          _adminName(stokvelId),
                          const SizedBox(height: 10),
                          _buildPhoneNumberField(),
                          const SizedBox(height: 20),
                          _membersList(stokvelId),
                          const SizedBox(height: 30),
                          _saveButton(),
                        ],
                      ),
                  


        
 
                );
                },
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
              children:  [
                Text("Stokvel",
                    style: Theme.of(context).textTheme.displayLarge),
                SizedBox(height: 5),
                Text("Finish setting up your stokvel",
                    style: Theme.of(context).textTheme.titleLarge),
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
          style: Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(
            labelText: label,
            hintStyle: Theme.of(context).textTheme.labelSmall,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      );


Widget _adminName(String stokvelId) => StreamBuilder<DatabaseEvent>(
  stream: _stokvelMembersStream(stokvelId),
  builder: (context, snap) {
    if (!snap.hasData || snap.data!.snapshot.value == null) {
      return const Text("No members yet.");
    }

    final membersMap = Map<String, dynamic>.from(snap.data!.snapshot.value as Map);

    // Look for admin member
    final adminEntry = membersMap.entries.firstWhere(
      (entry) {
        final memberData = Map<String, dynamic>.from(entry.value);
        return memberData['role'] == 'admin';
      },
      orElse: () => MapEntry('', null),
    );

    if (adminEntry.value == null) {
      return const Text("No admin found.");
    }

    final admin = Map<String, dynamic>.from(adminEntry.value);
    final fullName = "${admin['firstName'] ?? ''} ${admin['lastName'] ?? ''}";
   

    return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: TextFormField(
          readOnly: true,
          initialValue: fullName,
          style: Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(
            labelText: "Stokvel Admin",
            hintStyle: Theme.of(context).textTheme.labelSmall,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      );
  },
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
                  style:  Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
             style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                labelText: "Phone Number",
                hintStyle: Theme.of(context).textTheme.labelSmall,
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

    final members = Map<String, dynamic>.from(snap.data!.snapshot.value as Map);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Members",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.darBlue,
            ),
          ),
          ...members.entries.map((e) {
            final m = Map<String, dynamic>.from(e.value);
            final name = "${m['firstName']} ${m['lastName']}";
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              subtitle: Text(
                m['phone'] ?? '',
                style: const TextStyle(fontSize: 10),
              ),
              trailing: Text(
                m['status'] ?? 'Pending',
                style: const TextStyle(
                  color: AppColors.darBlue,
                  fontSize: 11,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  },
);

  Widget _sectionTitle(String t) => Center(
        child: Text(t,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darBlue)),
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
          child:  Text("Save & Continue",
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      );
}
