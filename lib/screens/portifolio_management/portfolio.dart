import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});
  

   @override
  // ignore: library_private_types_in_public_api
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  

  Future<void> _launchUrl() async {
  final Uri _url = Uri.parse('https://satrix.co.za/products');
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

String? stokvelName;

@override
void initState() {
  super.initState();
  _fetchStokvelName().then((name) {
    setState(() {
      stokvelName = name;
    });
  });
}


Future<String?> _fetchStokvelName() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final snapshot = await FirebaseDatabase.instance.ref('stokvels').get();

  if (snapshot.exists) {
    final stokvels = snapshot.value as Map<dynamic, dynamic>;

    final entry = stokvels.entries.firstWhere(
      (e) => e.value is Map && e.value['createdBy'] == user.uid,
    
    );

    final stokvelData = entry.value as Map;
    return stokvelData['stokvelName'];
    }

  return null;
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:  Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Portfolio",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Summary Card (Removed Expanded)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Investment Summary",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darBlue),
                    ),
                    const SizedBox(height: 20),
                    _buildPortfolioRow("Investment Number", "MDKCDCK"),
                    _buildPortfolioRow("Investment Club", stokvelName ?? " N/A"),
                    _buildPortfolioRow("Current Portfolio value", "ZAR 5000"),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Center(
                  child: ElevatedButton(
                onPressed: _launchUrl,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.beige, // Gold color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                
                child: Text(
                  "More Stats",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )),
              const SizedBox(height: 20),
              // Portfolio Make-up
              const Center( child:  Text(
                "Portfolio Make-up",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darBlue),
              )
              ),
               Container(
              width: 20, // Adjust line width as needed
              height: 1, // Adjust thickness
              color: AppColors.darBlue, // Use your background color
            ),
              const SizedBox(height: 20),

              // Pie Chart
      Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 3,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      // Title
      title: const Text(
        "Investment ID",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.darBlue
        ),
      ),

      // Subtitle
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 4),
          Text(
            "Current Value",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Text(
            "Profits / Losses Value",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),

      // Trailing
      trailing: const Text(
        "Updated: ",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ),
)

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortfolioRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: AppColors.darBlue)),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.beige)),
        ],
      ),
    );
  }
}
