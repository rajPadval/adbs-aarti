import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ADBS Aarti',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.manage_search_sharp,
              size: 28,
            ), // Example icon, replace with your desired icon
            onPressed: () {
              // Implement your action here
              Navigator.pushNamed(context, "/search");
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: AnimateList(
            interval: 400.ms,
            effects: [
              const FadeEffect(
                begin: 0.0,
                end: 1.0,
                delay: Duration(milliseconds: 500),
                duration: Duration(milliseconds: 1500),
                curve: Curves.easeInOut,
              ),
              const SlideEffect(
                begin: Offset(-4, -2),
                end: Offset(0.0, 0.0),
                // delay: Duration(milliseconds: 100),
                duration: Duration(milliseconds: 1000),
                curve: Curves.fastEaseInToSlowEaseOut,
              )
            ],
            children: [
              const ItemCard(
                title: "Aarti",
                startColor: Colors.orange,
                endColor: Colors.pink,
              ),
              const ItemCard(
                title: "Bhajan",
                startColor: Colors.pinkAccent,
                endColor: Colors.orange,
              ),
              const ItemCard(
                  title: "Jakhadi",
                  startColor: Colors.orangeAccent,
                  endColor: Colors.pinkAccent),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.title,
    required this.startColor,
    required this.endColor,
  });

  final String title;
  final Color startColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(context, '/${title.toLowerCase()}');
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // color: Colors.deepPurpleAccent,
        elevation: 1.2,
        child: Container(
          width: 320, // Set the desired width
          height: 120, // Set the desired height
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
