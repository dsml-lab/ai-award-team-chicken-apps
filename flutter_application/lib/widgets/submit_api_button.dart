import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/res/custom_text.dart';
import 'package:flutter_application/screens/recommend_map.dart';
import 'package:flutter_application/widgets/loading_widght.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

// 次の画面に移動するためのボタン
// ignore: non_constant_identifier_names
ElevatedButton SubmitNextScreen(BuildContext context) {
  // Firebaseのインスタンスを作成
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final Map _genreOfDestination = CustomText.genreOfDestination; // 目的地のジャンル
  int? _place_time; // 目的地までの時間
  int? _detour_time; // 寄り道にかける所要時間
  Map<String, bool> genre = {}; // 目的地のジャンル結果を格納
  String _userUid; // ユーザのID
  String result;

  // APIに選択した情報を送り目的地とスポットを取得する
  Future<String> _pushAPI() async {
    // Firestoreのユーザのドキュメントを取得する
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userUid = prefs.getString('userUid') as String;
    DocumentSnapshot doc =
        await _db.collection('recommend').doc(_userUid).get();

    // 目的地までの時間と寄り道の時間を取得する
    _place_time = prefs.getInt('place_time') as int;
    _detour_time = prefs.getInt('detour_time') as int;
    // 目的地のジャンルを取得する
    for (int i in _genreOfDestination.keys) {
      genre[_genreOfDestination[i]['title']] = _genreOfDestination[i]['state'];
    }
    // Firestoreにユーザが選択した情報を追加する
    await _db.collection('recommend').doc(_userUid).set({
      'genre': genre,
      'place_time': _place_time,
      'detour_time': _detour_time
    });
    // 現在地を取得
    Location _locationService = Location();
    LocationData _currentLocation = await _locationService.getLocation();
    double _latitude = _currentLocation.latitude as double;
    double _longitude = _currentLocation.longitude as double;
    // サーバーにデータを送り目的地と道中のスポットを取得する
    Uri url = Uri.parse('http://10.0.2.2:5000/recommend');
    var headers = {"Content-Type": "application/json", "charset": "utf8"};
    var requestBody = json.encode(
        {"user": _userUid, "latitude": _latitude, "longitude": _longitude});
    http.Response response =
        await http.post(url, headers: headers, body: requestBody);
    String _content;
    if (response.statusCode != 200) {
      int statusCode = response.statusCode;
      _content = "Failed to post $statusCode";
    } else {
      _content = response.body;
    }
    return _content;
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
    onPressed: () async {
      showProgressDialog(context);
      result = await _pushAPI();
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return RecommendMap(result);
          },
        ),
      );
    },
  );
}
