import 'dart:convert';
import 'dart:math';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:playlister/random_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html_unescape/html_unescape.dart';

import 'model/record.dart';
import 'api/api.dart';

const API_KEY = 'AIzaSyCuLa-SZiVQNZ2E7V_6Z6FopgsLHhSIwpg';
const BASE_URL = 'https://www.googleapis.com/youtube/v3/search';

class VideoRecommend {
  dynamic video;
  int viewCount;

  VideoRecommend(this.video, this.viewCount);
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic> videos = [];
  List<VideoRecommend> priorityChannel = [];
  final recommendedVideos = [];
  final TextEditingController textController = new TextEditingController();
  var unescape = HtmlUnescape();

  String colorToString = "aaa";
  Color currentColor = const Color(0xFFF0B80F);
  void changeColor(Color color) => setState(() {
        currentColor = color;
        textController.text =
            _getKeywordForHue(HSVColor.fromColor(currentColor).hue);
      });

  final Map<double, List> _colorKeywordMap = {
    0: RandomString().red,
    30: RandomString().orange,
    60: RandomString().yellow,
    90: RandomString().yellowgreen,
    120: RandomString().yellowgreen,
    150: RandomString().green,
    180: RandomString().skyblue,
    210: RandomString().blue,
    240: RandomString().blue,
    270: RandomString().purple,
    300: RandomString().pink,
    330: RandomString().red,
  };

  Future<void> _searchYoutube(String tag) async {
    var url =
        '$BASE_URL?part=snippet&q=$tag+playlist&key=$API_KEY&type=video&regionCode=KR&videoCategoryId=10&videoDuration=any&maxResults=15';
    var response = await http.get(Uri.parse(url));
    var jsonResponse = json.decode(response.body);

    var hashtag = "#" + tag;
    var resVideoList = jsonResponse['items'];

    for (final video in resVideoList) {
      var response = await http.post(Uri.parse(API.get_history),
          body: {'channel_name': video['snippet']['channelTitle']});
      if (response.statusCode == 200) {
        var resRecord = jsonDecode(response.body);

        priorityChannel.add(VideoRecommend(video, resRecord['num']));
      }
    }

    priorityChannel.sort((a, b) => a.viewCount.compareTo(b.viewCount));
    List<VideoRecommend> temp = List.from(priorityChannel.reversed);
    //List<VideoRecommend> temp = List.from(priorityChannel);
    for (final tempVideo in temp) {
      videos.add(tempVideo.video);
    }

    setState(() {
      recommendedVideos.clear();

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
  
  recordHistory(String channel, String video) async {
    Record recordModel = Record(channel, video);

    try {
      var response =
          await http.post(Uri.parse(API.record), body: recordModel.toJson());

      if (response.statusCode == 200) {
        var resRecord = jsonDecode(response.body);
        if (resRecord['save'] == true) {
          // success Message
        } else {
          // fail Message
        }
      }
    } catch (e) {
      // error Message
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Colors.black87,
            //     Colors.black54,
            //   ],
            // ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                //padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                        onSubmitted: (text) {
                          _searchYoutube(text);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FilledButton(
                      onPressed: () {
                        _searchYoutube(textController.text);
                      },
                      child: const Text("검색"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: recommendedVideos.length,
                  itemBuilder: (BuildContext context, int index) {
                    var video = recommendedVideos[index];
                    var videoId = video['id']['videoId'];
                    Uri listUrl =
                        Uri.parse("https://www.youtube.com/watch?v=${videoId}");

                    return ListTile(
                      leading: Image.network(
                          video['snippet']['thumbnails']['default']['url']),
                      title: Text(unescape.convert(video['snippet']['title'])),
                      subtitle: Text(
                          unescape.convert(video['snippet']['channelTitle'])),
                      onTap: () async {
                        if (!await launchUrl(listUrl)) {
                          throw Exception('Could not launch $listUrl');
                        } else {
                          recordHistory(video['snippet']['channelTitle'],
                              video['snippet']['title']);
                        }
                      },
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 30, 50),
                child: FloatingActionButton(
                  onPressed: () {
                    _showColorPicker(context);
                  },
                  child: const Icon(Icons.palette),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getKeywordForHue(double hue) {
    for (var i = 0; i < _colorKeywordMap.length - 1; i++) {
      var startHue = _colorKeywordMap.keys.elementAt(i);
      var endHue = _colorKeywordMap.keys.elementAt(i + 1);
      if (hue >= startHue && hue < endHue) {
        return _colorKeywordMap[startHue]![Random().nextInt(10)];
      }
    }
    return _colorKeywordMap[330]![Random().nextInt(10)];
  }

  void _showColorPicker(BuildContext context) {
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
    // .then((colorToString) {
    //   if (colorToString == null) {
    //     print(colorToString);
    //     return;
    //   }
    //   textController.text = colorToString;
    //   print("success");
    // }
    //);
  }
}
