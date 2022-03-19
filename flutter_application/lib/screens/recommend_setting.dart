import 'package:flutter/material.dart';
import 'package:flutter_application/screens/recommend_map.dart';
import 'package:flutter_application/widgets/header.dart';
import 'package:flutter_application/widgets/kind_checkboxlist.dart';
import 'package:flutter_application/widgets/time_textfield.dart';

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
  return ElevatedButton(
    child: const Text("OK",
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold)),
    style: ElevatedButton.styleFrom(
      primary: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: () {
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
