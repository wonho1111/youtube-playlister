import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const API_KEY = 'AIzaSyCuLa-SZiVQNZ2E7V_6Z6FopgsLHhSIwpg';
const BASE_URL = 'https://www.googleapis.com/youtube/v3/search';

class TagSearch extends StatefulWidget {
  //final String API_KEY, BASE_URL;

  const TagSearch({super.key});

  @override
  State<TagSearch> createState() => _TagSearchState();
}

class _TagSearchState extends State<TagSearch> {
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
