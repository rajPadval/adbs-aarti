import 'package:flutter/material.dart';
import '../constants/article.dart'; // Assuming Article class is defined in article.dart

class DetailsScreen extends StatelessWidget {
  final Article article; // Received Article object

  const DetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(article.title), // Display article title in app bar
          title: Text("Read It Along")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title, // Display article title at the top of details
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                article.lyrics, // Display article lyrics
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
