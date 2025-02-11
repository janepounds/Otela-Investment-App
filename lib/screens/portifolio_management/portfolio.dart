import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Portfolio",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'poppins',
            ),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darBlue),
                    ),
                    const SizedBox(height: 20),
                    _buildPortfolioRow("Total Investments", "R 50,000"),
                    _buildPortfolioRow("Growth", "+12.5%"),
                    _buildPortfolioRow("Risk Level", "Medium"),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Center(
                  child: ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.beige, // Gold color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  "More Stats",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )),
              const SizedBox(height: 20),
              // Portfolio Make-up
              const Center( child:  Text(
                "Portfolio Make-up",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darBlue),
              )
              ),
               Container(
              width: 20, // Adjust line width as needed
              height: 1, // Adjust thickness
              color: AppColors.darBlue, // Use your background color
            ),
              const SizedBox(height: 20),

              // Pie Chart
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      _buildPieChartSection(40, Colors.blue, "Stocks"),
                      _buildPieChartSection(30, Colors.green, "Bonds"),
                      _buildPieChartSection(20, Colors.orange, "Crypto"),
                      _buildPieChartSection(10, Colors.red, "Cash"),
                    ],
                  ),
                ),
              ),
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
              style: const TextStyle(fontSize: 16, color: AppColors.darBlue)),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darBlue)),
        ],
      ),
    );
  }

  PieChartSectionData _buildPieChartSection(
      double percentage, Color color, String title) {
    return PieChartSectionData(
      value: percentage,
      color: color,
      title: title,
      radius: 50,
      titleStyle: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
