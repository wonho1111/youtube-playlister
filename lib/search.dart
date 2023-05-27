import 'dart:convert';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const API_KEY = 'AIzaSyCuLa-SZiVQNZ2E7V_6Z6FopgsLHhSIwpg';
const BASE_URL = 'https://www.googleapis.com/youtube/v3/search';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic> videos = [];
  final recommendedVideos = [];
  final TextEditingController _textController = new TextEditingController();

  Color currentColor = Colors.amber;
  void changeColor(Color color) => setState(() {
        currentColor = color;
        _textController.text =
            _getKeywordForHue(HSVColor.fromColor(currentColor).hue);
      });
  final Map<double, String> _colorKeywordMap = {
    0: "적극적인",
    30: "열정적인",
    60: "활기찬",
    90: "위험한",
    120: "행복한",
    150: "평화로운",
    180: "진지한",
    210: "청량한",
    240: "시원한",
    270: "우아한",
    300: "우수한",
    330: "귀여운",
  };

  Future<void> _searchYoutube(String tag) async {
    var url =
        '$BASE_URL?part=snippet&q=$tag+playlist&key=$API_KEY&type=video&regionCode=KR&videoCategoryId=10&videoDuration=any&maxResults=5';
    var response = await http.get(Uri.parse(url));
    var jsonResponse = json.decode(response.body);
    setState(() {
      recommendedVideos.clear();

      var hashtag = "#" + tag;
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
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term',
                      ),
                      onSubmitted: (text) {
                        _searchYoutube(text);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FilledButton(
                    onPressed: () {
                      _searchYoutube(_textController.text);
                    },
                    child: Text("검색"),
                  ),
                ],
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
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.fromLTRB(0, 0, 30, 50),
              child: FloatingActionButton(
                onPressed: () {
                  showColorPicker(context);
                },
                child: Icon(Icons.palette),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getKeywordForHue(double hue) {
    for (var i = 0; i < _colorKeywordMap.length - 1; i++) {
      var startHue = _colorKeywordMap.keys.elementAt(i);
      var endHue = _colorKeywordMap.keys.elementAt(i + 1);
      if (hue >= startHue && hue < endHue) {
        return _colorKeywordMap[startHue]!;
      }
    }
    return _colorKeywordMap[330]!;
  }

  void showColorPicker(BuildContext context) {
    var alert = AlertDialog(
      content: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.circular(20)
        ),
        child: Transform.scale(
          child: Center(
            child: Wrap(
              children: [
                HueRingPicker(
                  pickerColor: currentColor,
                  onColorChanged: changeColor,
                ),
              ],
            ),
          ),
          scale: 1,
        ),
        height: 280,
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
