// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class KindCheckBoxList extends StatefulWidget {
  const KindCheckBoxList({Key? key}) : super(key: key);

  @override
  _KindCheckBoxList createState() => _KindCheckBoxList();
}

class _KindCheckBoxList extends State<KindCheckBoxList> {
  ScrollController _scrollController = ScrollController();

  final Map _checklist = {
    0: {'title': '観光地', 'state': false, 'path': 'tourist_spot.png'},
    1: {'title': 'フォトスポット', 'state': false, 'path': 'photo_spot.png'},
    2: {'title': '地元グルメ', 'state': false, 'path': 'gourmand.png'},
    3: {'title': 'カフェ', 'state': false, 'path': 'cafe.png'},
    4: {'title': '観光地', 'state': false, 'path': 'tourist_spot.png'},
    5: {'title': 'フォトスポット', 'state': false, 'path': 'photo_spot.png'},
    6: {'title': '地元グルメ', 'state': false, 'path': 'gourmand.png'},
    7: {'title': 'カフェ', 'state': false, 'path': 'cafe.png'},
  };

  CheckboxListTile _checkBoxListTile(int key) {
    return CheckboxListTile(
      activeColor: Colors.blue,
      title: Text(
        _checklist[key]['title'],
        style: TextStyle(fontSize: 20),
      ),
      secondary: Image(
          image: AssetImage("assets/${_checklist[key]["path"]}"),
          height: 25,
          fit: BoxFit.fitHeight),
      controlAffinity: ListTileControlAffinity.trailing,
      value: _checklist[key]["state"],
      onChanged: (e) {
        _handleCheckbox(key);
      },
    );
  }

  void _handleCheckbox(int i) {
    setState(() {
      _checklist[i]['state'] = !_checklist[i]['state'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // 画面のサイズを取得
    var _screenSize = MediaQuery.of(context).size;
    return Material(
      elevation: 20.0,
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
          height: _screenSize.height * 0.5,
          // 高さの指定
          width: _screenSize.width * 0.9, // 幅の指定
          padding:
              const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: 10),
                    Text(
                      '行きたい目的地のジャンルに ✔︎',
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
              ),
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
                      for (int key in _checklist.keys) ...{
                        _checkBoxListTile(key),
                      }
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
