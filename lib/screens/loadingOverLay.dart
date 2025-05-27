import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverLay extends StatelessWidget {
  const LoadingOverLay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5), // Transparent dark overlay
        child: Center(
          child: Lottie.asset(
            'assets/animations/loader.json', // path to your Lottie file
            width: 150,
            height: 150,
            repeat: true,
          ),
        ),
      ),
    );
  }
}
