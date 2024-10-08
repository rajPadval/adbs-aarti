import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../constants/article.dart'; // Assuming Article class is defined in article.dart
import 'DetailsScreen.dart';

class AartiScreen extends StatefulWidget {
  const AartiScreen({super.key});

  @override
  State<AartiScreen> createState() => _AartiScreenState();
}

class _AartiScreenState extends State<AartiScreen> {
  List<Article> articles = []; // List to hold Article objects

  @override
  void initState() {
    super.initState();
    loadAartis(); // Load Aarti data when the screen initializes
  }

  Future<void> loadAartis() async {
    try {
      // Load JSON data from assets/aarti_data.json
      String jsonData = await rootBundle.loadString('assets/aarti_data.json');

      // Parse JSON string into a List of Maps
      List<dynamic> jsonList = json.decode(jsonData);

      // Convert List of Maps into List of Article objects
      List<Article> loadedArticles =
          jsonList.map((json) => Article.fromJson(json)).toList();

      // Update state with loaded articles
      setState(() {
        articles = loadedArticles;
      });
    } catch (e) {
      print('Error loading Aartis: $e');
      // Handle error loading data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background for AppBar
          Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // AppBar with transparent background
          AppBar(
            title: const Text('List of Aartis',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actionsIconTheme: const IconThemeData(color: Colors.white),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.only(
                top: kToolbarHeight + MediaQuery.of(context).padding.top),
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.menu_book_rounded),
                  title: Text(articles[index].title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsScreen(article: articles[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
