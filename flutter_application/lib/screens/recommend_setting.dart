import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/res/custom_text.dart';
import 'package:flutter_application/screens/recommend_map.dart';
import 'package:flutter_application/widgets/header.dart';
import 'package:flutter_application/widgets/kind_checkboxlist.dart';
import 'package:flutter_application/widgets/time_textfield.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

// モード選択
class RecommendSettingScreen extends StatefulWidget {
  const RecommendSettingScreen({Key? key}) : super(key: key);
  @override
  _RecommendSettingScreen createState() => _RecommendSettingScreen();
}

class _RecommendSettingScreen extends State<RecommendSettingScreen> {
  @override
  Widget build(BuildContext context) {
    // 画面のサイズを取得
    var _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const AppBarHeder(),
      // Stack(2つのContainerを重ねる)
      body: Stack(
        children: <Widget>[
          // Container(背景指定のみ)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/map.png'), fit: BoxFit.cover),
            ),
          ),
          // Container(複数のWidgetを一括で中心にまとめる)
          Center(
            child: Container(
              height: _screenSize.height * 0.9, // 高さの指定
              width: _screenSize.width * 0.9, // 幅の指定
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 25, bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TimeTextField(),
                    SizedBox(height: 40),
                    KindCheckBoxList(),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.topRight,
                      child: SubmitNextScreen(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 次の画面に移動するためのボタン
// ignore: non_constant_identifier_names
ElevatedButton SubmitNextScreen(BuildContext context) {
  // Firebaseのインスタンスを作成
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final Map _genreOfDestination = CustomText.genreOfDestination; // 目的地のジャンル
  int? _place_time; // 目的地までの時間
  int? _detour_time; // 寄り道にかける所要時間
  Map<String, bool> genre = {};
  String _userUid;

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i in _genreOfDestination.keys) {
      genre[_genreOfDestination[i]['title']] = _genreOfDestination[i]['state'];
    }
    _place_time = prefs.getInt('place_time') as int;
    _detour_time = prefs.getInt('detour_time') as int;
    _userUid = prefs.getString('userUid') as String;

    DocumentSnapshot doc =
        await _db.collection('recommend').doc(_userUid).get();
    Object fields =
        doc.data() ?? {'genre': '', 'place_time': 0, 'detour_time': 0};

    await _db.collection('recommend').doc(_userUid).set({
      'genre': genre,
      'place_time': _place_time,
      'detour_time': _detour_time
    });
    // 現在地の取得
    Location _locationService = Location();
    LocationData _currentLocation = await _locationService.getLocation();
    double _latitude = _currentLocation.latitude as double;
    double _longitude = _currentLocation.longitude as double;
    Uri url = Uri.parse('http://10.0.2.2:5000/recommend');
    var headers = {"Content-Type": "application/json"};
    var requestBody = json.encode(
        {"user": _userUid, "latitude": _latitude, "longitude": _longitude});
    var response = await http.post(url, headers: headers, body: requestBody);
  }

  return ElevatedButton(
    child: const Text("Submit",
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold)),
    style: ElevatedButton.styleFrom(
      elevation: 20,
      primary: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: () {
      _getPrefItems();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const RecommendMap();
          },
        ),
      );
    },
  );
}
