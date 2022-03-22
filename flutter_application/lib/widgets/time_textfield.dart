import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Googleのサインボタン
class TimeTextField extends StatefulWidget {
  const TimeTextField({Key? key}) : super(key: key);

  @override
  _TimeTextField createState() => _TimeTextField();
}

class _TimeTextField extends State<TimeTextField> {
  // ignore: non_constant_identifier_names
  int _place_time = 0; // 目的地までの時間
  // ignore: non_constant_identifier_names
  int _detour_time = 0; // 寄り道にかける所要時間
  List<DropdownMenuItem<int>> menuItems = []; // 時間の間隔

  _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('place_time', _place_time);
    prefs.setInt('detour_time', _detour_time);
  }

  @override
  void initState() {
    super.initState();
    _dropdownlist();
  }

  void _dropdownlist() {
    menuItems = [];
    for (var i = 0; i <= 60; i += 10) {
      menuItems.add(DropdownMenuItem(
          alignment: Alignment.center,
          child: Text(
            i.toString(),
          ),
          value: i));
    }
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
        // 高さの指定
        width: _screenSize.width * 0.9, // 幅の指定
        child: Padding(
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
                      '散策時間を設定します',
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "目的地の時間(分)",
                          labelStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold),
                        ),
                        isExpanded: true,
                        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                        value: _place_time,
                        items: menuItems,
                        onChanged: (newValue) async {
                          setState(
                            () {
                              _place_time = newValue as int;
                              _setPrefItems();
                            },
                          );
                        },
                      ),
                    ),
                    Icon(Icons.add, color: Colors.grey[700], size: 30),
                    SizedBox(
                      width: 100,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "寄り道の時間(分)",
                          labelStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold),
                        ),
                        isExpanded: true,
                        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                        value: _detour_time,
                        items: menuItems,
                        onChanged: (newValue) async {
                          setState(
                            () {
                              _detour_time = newValue as int;
                              _setPrefItems();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
