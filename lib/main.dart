import 'package:flutter/material.dart';
import 'package:playlister/palette_search.dart';
import 'package:playlister/tag_search.dart';

const API_KEY = 'AIzaSyCuLa-SZiVQNZ2E7V_6Z6FopgsLHhSIwpg';
const BASE_URL = 'https://www.googleapis.com/youtube/v3/search';
//?key=AIzaSyCuLa-SZiVQNZ2E7V_6Z6FopgsLHhSIwpg&q=NewJeans&type=video&part=snippet

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
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.explore),
              label: '태그 검색',
            ),
            NavigationDestination(
              icon: Icon(Icons.commute),
              label: '팔레트 검색',
            ),
          ],
        ),
        body: <Widget>[
          TagSearch(),
          PaletteSearch(),
        ][currentPageIndex],
      ),
    );
  }
}
