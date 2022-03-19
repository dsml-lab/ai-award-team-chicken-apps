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
    return Scaffold(
      appBar: const AppBarHeder(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/map.png'), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 50, bottom: 50),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TimeTextField(),
                  SizedBox(height: 40),
                  KindCheckBoxList(),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 10, bottom: 10),
                    child: ElevatedButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const RecommendMap();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
