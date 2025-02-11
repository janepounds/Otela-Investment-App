import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otela_investment_club_app/colors.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Congratulations",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'poppins',
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.menu,
                  color: Colors.white, size: 30), // Menu Icon
              onPressed: () {
                showSignOutDialog(context, () {
                  // 🔹 Perform Sign Out Logic (e.g., Firebase sign out)
                  print("User signed out!");
                });
              },
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
                    SizedBox(height: 16),
                    Center(
                        child: Text(
                            'Your payment was successful. An email with transaction details has been shared.',
                            style: TextStyle(
                                fontSize: 20, color: AppColors.darBlue))),
                    SizedBox(height: 16),
                    SvgPicture.asset("assets/icons/envelope_send.svg",
                        width: 300, height: 300),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/main'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.beige,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 40),
                      ),
                      child: Text(
                        "Done",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ]))),
    );
  }
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
