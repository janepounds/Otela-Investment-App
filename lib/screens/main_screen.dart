import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/investing/fund_details_screen.dart';
import 'package:otela_investment_club_app/screens/members_details.dart';
import 'package:otela_investment_club_app/screens/portifolio_management/portfolio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, String>> featuredInvestments = [
    {
      "title": "Satrix \nS&P 500",
      "subtitle":
          "The Satrix \nS&P 500 Feeder ETF is an index tracking fund registered as a Collective Investment Scheme",
      "image": "assets/images/money_tree_bg.png"
    },
    {
      "title": "Satrix \nS&P 500",
      "subtitle":
          "The Satrix \nS&P 500 Feeder ETF is an index tracking fund registered as a Collective Investment Scheme",
      "image": "assets/images/money_tree_bg.png"
    },
    {
      "title": "Satrix \nS&P 500",
      "subtitle":
          "The Satrix \nS&P 500 Feeder ETF is an index tracking fund registered as a Collective Investment Scheme",
      "image": "assets/images/money_tree_bg.png"
    },
  ];

  final List<Map<String, String>> recommendedInvestments = [
    {
      "title": "Satrix \nS&P 500",
      "subtitle":
          "The Satrix \nS&P 500 Feeder ETF is an index tracking fund registered as a Collective Investment Scheme",
      "image": "assets/images/money_tree_bg.png"
    },
    {
      "title": "Satrix \nS&P 500",
      "subtitle":
          "The Satrix \nS&P 500 Feeder ETF is an index tracking fund registered as a Collective Investment Scheme",
      "image": "assets/images/money_tree_bg.png"
    },
    {
      "title": "Satrix \nS&P 500",
      "subtitle":
          "The Satrix \nS&P 500 Feeder ETF is an index tracking fund registered as a Collective Investment Scheme",
      "image": "assets/images/money_tree_bg.png"
    },
  ];

  final List<Map<String, String>> tailoredInvestments = [
    {
      "title": "Lifestyle",
      "image": "assets/images/fund_bg_final.png",
      "subtitle": ""
    },
  ];

  int _selectedIndex = 0; // Track the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
     if (index == 2) {
      // If "Invest" tab is tapped

      // Navigate or perform any action
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FundDetailsScreen()),
      );
     }

    if (index == 3) {
      // If "Invest" tab is tapped

      // Navigate or perform any action
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PortfolioScreen()),
      );
    }
  }

  String? stokvelId;

  @override
  void initState() {
    super.initState();
    _fetchStokvelId();
  }

  Future<void> _fetchStokvelId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot stokvelsQuery = await FirebaseFirestore.instance
          .collection('stokvels')
          .where('createdBy', isEqualTo: user.uid)
          .get();

      if (stokvelsQuery.docs.isNotEmpty) {
        setState(() {
          stokvelId = stokvelsQuery.docs.first.id; // Use first stokvel ID found
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17468A),
        title: Stack(
          alignment: Alignment.center, // Centers the avatar
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  "assets/icons/logo_beige.svg",
                  width: 60,
                  height: 60,
                ),
                const Icon(Icons.menu, color: Colors.white),
              ],
            ),
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/images/logo_no_text.png"),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Members Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Members",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darBlue),
                              ),
                              SvgPicture.asset("assets/icons/members.svg",
                                  color: AppColors.darBlue),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Large Number
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('stokvels')
                                .doc(stokvelId)
                                .collection('members')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              // Get all members
                              var members = snapshot.data!.docs;

                              // Count total members
                              int totalMembers = members.length;

                              // Count members who were invited
                              int invitedCount = members
                                  .where((doc) => doc['status'] == 'invited')
                                  .length;

                              // Count members who signed up
                              int signedUpCount = members
                                  .where((doc) => doc['status'] == 'joined')
                                  .length;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "$totalMembers", // Display total members dynamically
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Smaller Stats
                                  Text("Invited = $invitedCount",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.darBlue)),
                                  Text("Signed Up = $signedUpCount",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.darBlue)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Contribution Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Icon

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                // Your row widgets here
                                Text(
                                  "Contribution (ZAR)",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darBlue),
                                ),

                                SvgPicture.asset(
                                  'assets/icons/contribution.svg',
                                  color: AppColors.darBlue,
                                  alignment: Alignment.topRight,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),
                          // Large Number
                          Text(
                            "155,000", // Replace with actual data
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Smaller Stats
                          Text("Target = 500,000",
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.darBlue)),
                          Text("Unpaid = 345,000",
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.darBlue)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to details screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MembersListScreen(stokvelId: stokvelId!)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.black54),
                  ),
                ),
                child: Center(
                  child: Text(
                    "DETAILS",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darBlue),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Recommended Investments
            buildSectionTitle("Exchange Traded Funds"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recommendedInvestments.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  return buildInvestmentCard(
                    recommendedInvestments[index]["title"]!,
                    recommendedInvestments[index]["subtitle"]!,
                    recommendedInvestments[index]["image"]!,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Tailored Investments
            buildSectionTitle("Unit Trust Funds"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: buildInvestmentCard(
                tailoredInvestments.first["title"]!,
                tailoredInvestments.first["subtitle"]!,
                tailoredInvestments.first["image"]!,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF17468A),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Track the selected index
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24, // Adjust size as needed
              height: 24,
              child: SvgPicture.asset("assets/icons/home.svg"),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset("assets/icons/investment.svg"),
            ),
            label: "Invest",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset("assets/icons/goals.svg"),
            ),
            label: "Goals",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset("assets/icons/portfolio.svg"),
            ),
            label: "Portfolio",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset("assets/icons/watchlist.svg"),
            ),
            label: "Watchlist",
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define your action here
        },
        backgroundColor: AppColors.darBlue, // Set your FAB color
        shape: const CircleBorder(),
        child: SvgPicture.asset(
          'assets/icons/user_robot.svg',
          width: 40,
          height: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Widget buildInvestmentCard(String title, String subtitle, String image) {
  return Container(
    width: double.infinity,
    height: 160,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
    ),
    child: Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [AppColors.brighterBeige, Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
                height: 16), // Add some space between subtitle and button
            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                child: const Text("Invest"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// 🔹 Section Title Widget
Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      "$title >",
      style: const TextStyle(
          fontSize: 18, color: AppColors.darBlue, fontFamily: 'poppins'),
    ),
  );
}

// 🔹 Carousel Indicator Widget
Widget buildIndicator(bool isActive) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: isActive ? 12 : 8,
    height: 8,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isActive ? Colors.blue : Colors.grey.shade400,
    ),
  );
}


Future<void> showSignOutDialog(BuildContext context, VoidCallback onSignOut) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Column(
          children: [
            Icon(Icons.exit_to_app, size: 50, color: Colors.red), // Sign-out icon
            const SizedBox(height: 10),
            const Text(
              "Sign Out",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to sign out?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              onSignOut(); // Perform sign-out action
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Sign Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

