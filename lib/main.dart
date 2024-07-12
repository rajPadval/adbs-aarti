import 'package:adbs_aarti/screens/AartiScreen.dart';
import 'package:adbs_aarti/screens/BhajanScreen.dart';
import 'package:adbs_aarti/screens/HomeScreen.dart';
import 'package:adbs_aarti/screens/JakhadiScreen.dart';
import 'package:adbs_aarti/screens/SearchScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ADBS Aarti',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const HomeScreen(),
          '/search': (context) => SearchScreen(),
          '/aarti': (context) => const AartiScreen(),
          '/bhajan': (context) => const BhajanScreen(),
          '/jakhadi': (context) => const JakhadiScreen(),
        });
  }
}
