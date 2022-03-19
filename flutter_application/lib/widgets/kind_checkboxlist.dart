// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class KindCheckBoxList extends StatefulWidget {
  const KindCheckBoxList({Key? key}) : super(key: key);

  @override
  _KindCheckBoxList createState() => _KindCheckBoxList();
}

class _KindCheckBoxList extends State<KindCheckBoxList> {
  final Map _checklist = {
    0: {'title': '観光地', 'state': false, 'path': 'tourist_spot.png'},
    1: {'title': 'フォトスポット', 'state': false, 'path': 'photo_spot.png'},
    2: {'title': '地元グルメ', 'state': false, 'path': 'gourmand.png'},
    3: {'title': 'カフェ', 'state': false, 'path': 'cafe.png'},
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
    return SizedBox(
      height: 300,
      child: Material(
        elevation: 20.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int key in _checklist.keys) ...{
                _checkBoxListTile(key),
              }
            ],
          ),
        ),
      ),
    );
  }
}

class Int {}
