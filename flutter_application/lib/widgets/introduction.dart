import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

class Introduction extends StatefulWidget {
  String _outline; // お店の概要
  Map<String, dynamic> _image; // 写真
  Map<String, dynamic> _review; // レビュー情報
  Introduction(this._outline, this._image, this._review, {Key? key})
      : super(key: key);
  @override
  _Introduction createState() => _Introduction();
}

class _Introduction extends State<Introduction> {
  ScrollController _scrollController = ScrollController();
  final FlutterTts tts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    final _pages = [
      page1Overview(),
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.6,
      child: PageView.builder(
        itemBuilder: (context, index) {
          return _pages[index];
        },
        itemCount: _pages.length,
      ),
    );
  }

  Widget page1Overview() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
        child: Column(
          children: <Widget>[
            Container(
              // width: double.maxFinite,
              alignment: Alignment.centerLeft,
              child: Text(
                "お店の紹介文",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[900],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              // width: double.maxFinite,
              alignment: Alignment.centerLeft,
              child: Text(
                widget._outline,
                style: TextStyle(fontSize: 15, color: Colors.grey[900]),
              ),
            ),
            SizedBox(height: 10),
            Container(
              // width: double.maxFinite,
              alignment: Alignment.centerLeft,
              child: Text(
                "声レビュー",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[900],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                thickness: 8,
                hoverThickness: 16,
                radius: Radius.circular(16),
                child: ListView(
                  shrinkWrap: true,
                  controller: _scrollController,
                  children: [
                    for (String key in widget._review.keys) ...{
                      _voiceListTile(key)
                    }
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _voiceListTile(String key) {
    return ListTile(
      leading: Icon(Icons.record_voice_over_sharp),
      title: Text(widget._review[key]["user"]),
      trailing: Icon(Icons.recommend_outlined),
      subtitle: Text(widget._review[key]["time"]),
      // selected: true,
      onTap: () async {
        int num = Random().nextInt(4);
        List mode = [
          'ja-jp-x-jab-local',
          'ja-jp-x-jad-local',
          'ja-jp-x-jac-local',
          'ja-jp-x-htm-local'
        ];
        await tts.setVoice({'name': mode[num], 'locale': 'ja-JP'});
        print("TTS:${tts}");
        await tts.speak(widget._review[key]["text"]);
      },
    );
  }
}
