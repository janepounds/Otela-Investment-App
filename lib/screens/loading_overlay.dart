import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink(); // If not loading, return empty

    return Stack(
      children: [
        ModalBarrier(
          color: Colors.black.withOpacity(0.2), // Transparent background
          dismissible: false,
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Colors.cyan, // Match your UI
              ),
              const SizedBox(height: 10),
              const Text(
                "Loading...",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
