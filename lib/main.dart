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
  final recommendedVideos = [];

  Future<void> _searchYoutube(String tag) async {
    var url =
        '$BASE_URL?part=snippet&q=$tag+playlist&key=$API_KEY&type=video&regionCode=KR&videoCategoryId=10&videoDuration=any&maxResults=7';
    var response = await http.get(Uri.parse(url));
    var jsonResponse = json.decode(response.body);
    setState(() {
      //videos =
      //jsonResponse['items'].map((item) => Video.fromJson(item)).toList();
      var hashtag = "#" + tag;
      print(hashtag);
      videos = jsonResponse['items'];
      for (final video in videos) {
        if ((video['snippet']['description'].contains(hashtag))) {
          recommendedVideos.add(video);
        }
      }

      for (final video in videos) {
        if ((!video['snippet']['description'].contains(hashtag))) {
          recommendedVideos.add(video);
        }
      }
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
                onSubmitted: (value) {
                  _searchYoutube(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recommendedVideos.length,
                itemBuilder: (BuildContext context, int index) {
                  var video = recommendedVideos[index];
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

/*
class Video {
  String title;
  String channelId;
  String description;
  List<String> tags = [];
  List<String> comments = [];

  Video(
      {required this.title,
      required this.channelId,
      required this.description});

  factory Video.fromJson(Map<String, dynamic> json) {
    final video = Video(
      title: json['snippet']['title'],
      channelId: json['snippet']['channelId'],
      description: json['snippet']['description'],
    );
    if (json['snippet']['tags'] != null) {
      video.tags = List<String>.from(json['snippet']['tags']);
    }
    if (json['comments'] != null) {
      video.comments =
          json['comments'].map<String>((comment) => comment['text']).toList();
    }
    return video;
  }
}
*/