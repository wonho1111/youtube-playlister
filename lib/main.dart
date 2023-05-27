import 'package:flutter/material.dart';
import 'package:playlister/palette_search.dart';
import 'package:playlister/search.dart';
import 'package:playlister/tag_search.dart';

const API_KEY = 'AIzaSyCuLa-SZiVQNZ2E7V_6Z6FopgsLHhSIwpg';
const BASE_URL = 'https://www.googleapis.com/youtube/v3/search';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Search(),
      ),
    );
  }
}
