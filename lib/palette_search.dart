import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

const API_KEY = 'AIzaSyCuLa-SZiVQNZ2E7V_6Z6FopgsLHhSIwpg';
const BASE_URL = 'https://www.googleapis.com/youtube/v3/search';

class PaletteSearch extends StatefulWidget {
  @override
  State<PaletteSearch> createState() => _PaletteSearch();
}

class _PaletteSearch extends State<PaletteSearch> {
  double _hueAngle = 0;
  String value = '';

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

  Color currentColor = Colors.amber;
  void changeColor(Color color) => setState(() => currentColor = color);
  // void changeColor(Color color) {
  //   setState(() {
  //     currentColor = color;
  //     _searchYoutube(_getKeywordForHue(HSVColor.fromColor(currentColor).hue));
  //   });
  // }

  HSVColor hsvColor = HSVColor.fromAHSV(1, 150, 1, 1);
  int aaa = HSVColor.fromAHSV(1, 150, 1, 1).hue.toInt();

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
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Text(
                value = _getKeywordForHue(HSVColor.fromColor(currentColor).hue),
                style: TextStyle(fontSize: 24),
                //HSVColor.fromColor(currentColor).hue.toString(),
              ),
            ),
            //buildThis(),
            //FilledButton(onPressed: onPressed, child: child),
            SizedBox(
              height: 50,
            ),
            HueRingPicker(
              pickerColor: currentColor,
              onColorChanged: changeColor,
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
}
