import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/header.dart';
import 'package:flutter_application/widgets/mode_button.dart';

// モード選択
class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  // ignore: non_constant_identifier_names
  String normal_explanation = '現在地に近い3つの隠れた魅力を表示します。';
  // ignore: non_constant_identifier_names
  String recommend_explanation =
      '散策時間に合うあなたに最適な目的地を推薦し、道中の隠れた魅力をチェックポイントとして表示します。';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarHeder(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/town.png'), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ModeButton(
                    'お散歩モード', 'AdobeStock_440190456.png', normal_explanation),
                ModeButton(
                    '推薦モード', 'AdobeStock_422744355.png', recommend_explanation),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
