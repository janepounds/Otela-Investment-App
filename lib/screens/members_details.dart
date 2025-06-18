import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/invite_members_screen.dart';

class MembersListScreen extends StatefulWidget {
  final String stokvelId;

  const MembersListScreen({super.key, required this.stokvelId});

  @override
  _MembersListScreenState createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darBlue, // AppBar background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              "Members",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 4),
            Text(
              "Stokvel Members Details",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), // Curved top-right
          ),
        ),
        child: Column(
          children: [
            // Search Bar at the TOP of the body
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() => searchQuery = value.toLowerCase());
                },
                decoration: InputDecoration(
                  hintText: "Search members...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: Theme.of(context).textTheme.labelMedium,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Fully rounded corners
                    borderSide:
                        const BorderSide(color: Colors.grey), // Gray border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Fully rounded corners
                    borderSide:
                        const BorderSide(color: Colors.grey), // Gray border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Fully rounded corners
                    borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.5), // Slightly thicker when focused
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('stokvels')
                      .doc(widget.stokvelId)
                      .collection('members')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var members = snapshot.data!.docs.where((member) {
                      String name =
                          (member['firstName'] ?? "Unknown").toLowerCase();
                      return name.contains(searchQuery);
                    }).toList();

                    if (members.isEmpty) {
                      return const Center(
                        child: Text(
                          "No members found.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        var member = members[index];
                        String firstName = member['firstName'] ?? "Unknown";
                        String status = member['status'];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),

                            // Display First Name
                            title: Text(
                              firstName,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),

                            // Display Additional Info Below Name
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4), // Small spacing

                                // Robo Advisor Status
                                Text(
                                  "Robo Advisor: ${(member['roboAdvisor'] ?? false) ? 'Yes' : 'No'}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),

                                // Amount Paid
                                Text(
                                  "Amount Paid: \$${(member['amountPaid'] ?? 0).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),

                            // Status Badge (Trailing)
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: status == "invited"
                                    ? Colors.orange.shade100
                                    : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    status == "invited"
                                        ? Icons.hourglass_empty
                                        : Icons.check_circle,
                                    color: status == "invited"
                                        ? Colors.orange
                                        : Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    status == "invited" ? "Invited" : "Joined",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: status == "invited"
                                          ? Colors.orange
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 160, // Adjust width for rounded button
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(25), // Rounded at both ends
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InviteMembersScreen(stokvelId: widget.stokvelId)),
            );
          },
          backgroundColor: Colors.transparent,
        
          label:  Row(
            children: [
              Icon(Icons.add, color: Colors.white), // Plus icon at the start
              SizedBox(width: 5),
              Text("Invite", style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
