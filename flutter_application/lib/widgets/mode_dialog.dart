import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/screens/recommend_setting.dart';
import 'package:flutter_application/screens/stroll_map.dart';
import 'package:flutter_application/screens/sign_in_screen.dart';
import 'package:flutter_application/utils/request_api.dart';
import 'package:flutter_application/widgets/loading_widght.dart';
import 'package:location/location.dart';

// ignore: must_be_immutable
class ModeDialog extends StatefulWidget {
  String title;
  String content;
  String path;
  ModeDialog(this.title, this.path, this.content, {Key? key}) : super(key: key);
  @override
  _ModeDialog createState() => _ModeDialog();
}

class _ModeDialog extends State<ModeDialog> {
  Route<dynamic> _routeToMapScreen(String title) {
    if (title == "推薦モード") {
      return MaterialPageRoute(
        builder: (context) {
          return const RecommendSettingScreen();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          return const SignInScreen();
        },
      );
    }
  }

  Future<String> _pushAPI() async {
    // 現在地を取得
    Location _locationService = Location();
    LocationData _currentLocation = await _locationService.getLocation();
    double _latitude = _currentLocation.latitude as double;
    double _longitude = _currentLocation.longitude as double;
    var requestBody = json.encode({
      "latitude": _currentLocation.latitude,
      "longitude": _currentLocation.longitude
    });
    return requestAPI(api: 'stroll', requestBody: requestBody);
    ;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(children: <Widget>[
        Text(widget.title),
        Image(
          image: AssetImage("images/${widget.path}"),
          height: 50,
          fit: BoxFit.fitHeight,
        ),
      ]),
      content: Text(widget.content),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // キャンセルボタン
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              // OKボタン
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () async {
                  if (widget.title == "お散歩モード") {
                    showProgressDialog(context);
                    String result = await _pushAPI();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return StrollMap(result);
                        },
                      ),
                    );
                  } else {
                    Navigator.of(context).push(_routeToMapScreen(widget.title));
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
