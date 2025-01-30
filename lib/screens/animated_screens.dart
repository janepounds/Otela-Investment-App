import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class AnimatedScreens extends StatefulWidget {
  const AnimatedScreens({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedScreensState createState() => _AnimatedScreensState();
}

class _AnimatedScreensState extends State<AnimatedScreens> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Automatically move to the next page every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < 2) { // Change 2 to pages.length - 1 dynamically
        _currentIndex++;
      } else {
        _currentIndex = 0; // Loop back to the first page
      }

      _controller.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildPage(
        imagePath: 'assets/images/pre_login_1_curved.png',
        title: 'Home of Stokvels\nand Investment Clubs.',
      ),
      _buildPage(
        imagePath: 'assets/images/pre_login_2_curved.png',
        title: 'Your Certified\nInvestment Partner.',
      ),
      _buildPage(
        imagePath: 'assets/images/pre_login_3_curved.png',
        title: 'AI Powered\nRoboadvisory Services.',
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return pages[index];
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: _currentIndex == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? Color(0xFF113293) : Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'GET STARTED',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({required String imagePath, required String title}) {
    return Column(
      children: [
        // Banner image at the top
        Image.asset(
          imagePath,
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
        ),
        // Center the text below the image
        Expanded(
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF113293),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
