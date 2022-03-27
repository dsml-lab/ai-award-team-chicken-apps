// 目的地とスポットまでの時間を表示する
import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/introduction.dart';
import 'package:flutter_application/widgets/loading_widght.dart';

// お店の紹介情報をマップのヘッダー部分にボタンとして表示する
Widget headerButton(
    {required BuildContext context,
    required Map<String, dynamic> response,
    required int target,
    required Widget view_spots_distance,
    required Future<Map<String, dynamic>> get_target_spots}) {
  return Padding(
    padding: EdgeInsets.only(top: 1, right: 1, bottom: 1, left: 1),
    child: ElevatedButton(
      child: Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.add_business, color: Colors.grey[700], size: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  response[target.toString()]["name"],
                  style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                ),
              ),
            ),
            Center(child: view_spots_distance),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.orangeAccent[100],
        onPrimary: Colors.grey[700],
        elevation: 20,
        side: BorderSide(
            color: Colors.grey, //枠線!
            width: 3),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        showProgressDialog(context);
        Map<String, dynamic> data = await get_target_spots;
        Navigator.of(context).pop();
        await spotShowDialog(
            context: context, data: data, response: response, target: target);
      },
    ),
  );
}

// 目的地の情報を表示する
Future spotShowDialog({
  required BuildContext context,
  required Map<String, dynamic> data,
  required Map<String, dynamic> response,
  required int target,
}) {
  // F
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        scrollable: true,
        backgroundColor: Colors.orangeAccent[100],
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey, //枠線の色
            width: 3, //枠線の太さ
          ),
        ),
        elevation: 10,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            response[target.toString()]["name"],
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.grey[700]),
          ),
        ),
        content: Introduction(data["outline"], data["image"], data["reviews"]),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10, bottom: 10, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text(
                    "※Googleマップの口コミから\nデータを収集(2022/03/21)",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Icon(Icons.arrow_back_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
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
    },
  );
}
