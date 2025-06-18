import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/investing/fund_details_screen.dart';
import 'package:otela_investment_club_app/screens/members_details.dart';
import 'package:otela_investment_club_app/screens/portifolio_management/portfolio.dart';
import 'package:otela_investment_club_app/screens/robo_advisor_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late DatabaseReference groupsRef;
  List<Map<String, dynamic>> etfGroups = [];
  List<Map<String, dynamic>> unitTrustGroups = [];
  bool isLoading = true;

  int _selectedIndex = 0; // Track the selected index

  @override
  void initState() {
    super.initState();
    _fetchStokvelId();
    groupsRef = FirebaseDatabase.instance.ref('products');
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    final snapshot = await FirebaseDatabase.instance.ref('products').get();

    if (snapshot.exists) {
      final productsData = Map<String, dynamic>.from(snapshot.value as Map);

      // Extract ETF products
      final etfData = Map<String, dynamic>.from(productsData['ETF'] ?? {});
      final unitTrustData =
          Map<String, dynamic>.from(productsData['UNIT_TRUST'] ?? {});

      List<Map<String, dynamic>> parseProducts(Map<String, dynamic> dataMap) {
        return dataMap.entries.map((e) {
          final product = Map<String, dynamic>.from(e.value);
          product['id'] = e.key;
          return product;
        }).toList();
      }

      setState(() {
        etfGroups = parseProducts(etfData);
        unitTrustGroups = parseProducts(unitTrustData);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

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

  Future<void> _fetchStokvelId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final snapshot = await FirebaseDatabase.instance.ref('stokvels').get();

      if (snapshot.exists) {
        final stokvels = snapshot.value as Map<dynamic, dynamic>;
        final entry = stokvels.entries.firstWhere(
          (e) => e.value['createdBy'] == userId,
          orElse: () => MapEntry(null, null),
        );

        if (entry.key != null) {
          setState(() {
            stokvelId = entry.key.toString();
          });
        }
      }
    }
  }

  Stream<DatabaseEvent> fetchMembersStream() {
    if (stokvelId == null) return const Stream.empty();
    return FirebaseDatabase.instance.ref('stokvels/$stokvelId/members').onValue;
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
                  width: 70,
                  height: 70,
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
            SizedBox(
              height: 150,
              child: Padding(
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                SvgPicture.asset("assets/icons/members.svg",
                                    color: AppColors.darBlue,
                                    height: 14,
                                    width: 14),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Large Number
                            StreamBuilder<DatabaseEvent>(
                              stream: fetchMembersStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.snapshot.value == null) {
                                  return const Text("No Members");
                                }

                                final data = snapshot.data!.snapshot.value
                                    as Map<dynamic, dynamic>;

                                final members = data.values
                                    .whereType<
                                        Map>() // This filters out any unexpected non-map values
                                    .toList();

                                int total = members.length;
                                int invited = members
                                    .where((m) => m['status'] == 'invited')
                                    .length;
                                int joined = members
                                    .where((m) => m['status'] == 'joined')
                                    .length;

                                return Column(
                                  children: [
                                    Text("$total",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                    Text("Invited = $invited",
                                        style: TextStyle(
                                            color: AppColors.darBlue,
                                            fontSize: 10)),
                                    Text("Signed Up = $joined",
                                        style: TextStyle(
                                            color: AppColors.darBlue,
                                            fontSize: 10)),
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
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darBlue,
                                        fontFamily: 'poppins'),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: SvgPicture.asset(
                                      'assets/icons/contribution.svg',
                                      height: 14,
                                      width: 14,
                                      color: AppColors.darBlue,
                                      alignment: Alignment.topRight,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                            // Large Number
                            Text(
                              "155,000", // Replace with actual data
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Smaller Stats
                            Text("Target = 500,000",
                                style: TextStyle(
                                    fontSize: 10, color: AppColors.darBlue)),
                            Text("Unpaid = 345,000",
                                style: TextStyle(
                                    fontSize: 10, color: AppColors.darBlue)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            buildGroupSection("Exchange Traded Funds", etfGroups),
            buildGroupSection("Unit Trusts", unitTrustGroups),

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
              width: 20, // Adjust size as needed
              height: 20,
              child: SvgPicture.asset("assets/icons/home.svg"),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset("assets/icons/investment.svg"),
            ),
            label: "Invest",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset("assets/icons/goals.svg"),
            ),
            label: "Goals",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset("assets/icons/portfolio.svg"),
            ),
            label: "Portfolio",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 20,
              height: 20,
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RoboAdvisorScreen()),
          );
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
 width: 160,
 height: 160,
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [AppColors.brighterBeige, Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _launchUrl,
              child: const Text('Invest',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _launchUrl() async {
  final Uri _url = Uri.parse('https://satrix.co.za/products');
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
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

Widget buildGroupSection(String title, List<Map<String, dynamic>> groupList) {
  const imageAsset = 'assets/images/money_tree_bg.png';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 24),
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), // Add horizontal space
        child: Text(
          "$title >",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.darBlue,
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        height: 160,
        child: groupList.isEmpty
            ? const Center(child: Text("No products available" ,
            style: TextStyle(fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darBlue)))
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  final group = groupList[index];
                  final groupName = group['name'] ?? 'N/A';
                  final description = group['description'] ?? 'No description';
                  return buildInvestmentCard(
                      groupName, description, imageAsset);
                },
              ),
      ),
    ],
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
            Icon(Icons.exit_to_app,
                size: 50, color: Colors.red), // Sign-out icon
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
            child:
                const Text("Sign Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
