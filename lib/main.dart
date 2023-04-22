import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  // This widget is the root of your application.

  List<dynamic> videos = [];

  Future<void> _searchYoutube(String tag) async {
    var url =
        '$BASE_URL?part=snippet&q=$tag+playlist&key=$API_KEY&type=video&regionCode=KR&videoCategoryId=10&videoDuration=any';
    var response = await http.get(Uri.parse(url));
    var jsonResponse = json.decode(response.body);
    setState(() {
      videos = jsonResponse['items'];
    });
  }

  @override
  Widget build(BuildContext context) {
    //   return MaterialApp(
    //     title: 'Flutter Demo',
    //     theme: ThemeData(
    //       // This is the theme of your application.
    //       //
    //       // Try running your application with "flutter run". You'll see the
    //       // application has a blue toolbar. Then, without quitting the app, try
    //       // changing the primarySwatch below to Colors.green and then invoke
    //       // "hot reload" (press "r" in the console where you ran "flutter run",
    //       // or simply save your changes to "hot reload" in a Flutter IDE).
    //       // Notice that the counter didn't reset back to zero; the application
    //       // is not restarted.
    //       primarySwatch: Colors.blue,
    //     ),
    //     home: const MyHomePage(title: 'Flutter Demo Home Page'),
    //   );
    // }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search Youtube by Tag'),
        ),
        body: Column(
          children: [
            TextField(
              onSubmitted: (value) {
                _searchYoutube(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (BuildContext context, int index) {
                  var video = videos[index];
                  return ListTile(
                    leading: Image.network(
                        video['snippet']['thumbnails']['default']['url']),
                    title: Text(video['snippet']['title']),
                    subtitle: Text(video['snippet']['channelTitle']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
