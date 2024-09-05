import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/article.dart'; // Assuming Article class is defined in article.dart
import "package:flutter/animation.dart";

class DetailsScreen extends StatelessWidget {
  final Article article; // Received Article object

  const DetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(article.title), // Display article title in app bar
        title: Text(article.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   article.title, // Display article title at the top of details
              //   style:
              //       const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ).animate().fadeIn().slideX(
              //       curve: Curves.easeInOutCirc,
              //       duration: const Duration(milliseconds: 1000),
              //     ),
              const SizedBox(height: 16),
              Text(
                article.lyrics, // Display article lyrics
                style: const TextStyle(fontSize: 18),
              ).animate().move(
                    duration: Duration(seconds: 2),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
