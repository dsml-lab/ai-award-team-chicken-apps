import 'package:flutter/material.dart';

// Googleのサインボタン
class TimeTextField extends StatefulWidget {
  const TimeTextField({Key? key}) : super(key: key);

  @override
  _TimeTextField createState() => _TimeTextField();
}

class _TimeTextField extends State<TimeTextField> {
  String? time;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20.0,
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '目的地までの時間(分)を入力してください',
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
            SizedBox(height: 5),
            TextField(
              // enabled: true,
              // 入力数
              maxLength: 3,
              style: TextStyle(color: Colors.black, fontSize: 20),
              maxLines: 1,
              decoration: const InputDecoration(
                icon: Icon(Icons.face),
                border: InputBorder.none,
                labelText: '時間(分) *',
                hintText: '000',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: Colors.grey),
                ),
              ),
              onChanged: (text) {
                time = text;
                print("Time:$time");
              },
              // autofocus: true,
            ),
          ],
        ),
      ),
    );
  }
}
