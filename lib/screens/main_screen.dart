import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentCarouselIndex = 0;

  final List<Map<String, String>> featuredInvestments = [
    {"title": "Growth", "image": "assets/images/money_tree_bg.png"},
    {"title": "Wealth", "image": "assets/images/money_tree_bg.png"},
    {"title": "Savings", "image": "assets/images/money_tree_bg.png"},
  ];

  final List<Map<String, String>> recommendedInvestments = [
    {"title": "Bonds", "image": "assets/images/money_tree_bg.png"},
    {"title": "Strategic", "image": "assets/images/money_tree_bg.png"},
    {"title": "Stocks", "image": "assets/images/money_tree_bg.png"},
  ];

  final List<Map<String, String>> tailoredInvestments = [
    {"title": "Lifestyle", "image": "assets/images/money_tree_bg.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17468A),
        title: Row(
          children: [
            Image.asset("assets/images/logo_no_text.png", height: 24),
            const Spacer(),
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/images/logo_no_text.png"),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.menu, color: Colors.white),
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Featured Investment Carousel
            CarouselSlider(
              items: featuredInvestments.map((investment) {
                return buildInvestmentCard(investment["title"]!, investment["image"]!);
              }).toList(),
              options: CarouselOptions(
                height: 180,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
              ),
            ),

            // Carousel Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                featuredInvestments.length,
                (index) => buildIndicator(index == _currentCarouselIndex),
              ),
            ),

            const SizedBox(height: 16),

            // Recommended Investments
            buildSectionTitle("Recommended"),
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
                    recommendedInvestments[index]["image"]!,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Tailored Investments
            buildSectionTitle("Tailored"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: buildInvestmentCard(
                tailoredInvestments.first["title"]!,
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Invest"),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: "Goals"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: "Portfolio"),
          BottomNavigationBarItem(icon: Icon(Icons.remove_red_eye), label: "Watchlist"),
        ],
      ),
    );
  }

  // 🔹 Investment Card Widget
  Widget buildInvestmentCard(String title, String image) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ),
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {},
            child: const Text("Invest"),
          ),
        ),
      ],
    );
  }

  // 🔹 Section Title Widget
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        "$title >",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
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
}
