import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/header.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// モード選択
class RecommendMap extends StatefulWidget {
  const RecommendMap({Key? key}) : super(key: key);
  @override
  _RecommendMap createState() => _RecommendMap();
}

class _RecommendMap extends State<RecommendMap> {
  //
  final Completer<GoogleMapController> _controller = Completer();
  final Location _locationService = Location();

  // 現在位置
  LocationData? _currentLocation;
  // 現在位置の監視状況
  StreamSubscription? _locationChangedListen;

  @override
  void initState() {
    super.initState();
    // 現在位置の取得
    _getLocation();
    // 現在位置の変化を監視
    _locationChangedListen =
        _locationService.onLocationChanged.listen((LocationData result) async {
      setState(() {
        _currentLocation = result;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 監視を終了
    _locationChangedListen?.cancel();
  }

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
          _googleMapUI(),
          // Container(複数のWidgetを一括で中心にまとめる)
          Center(
            child: Container(
              height: _screenSize.height * 0.9, // 高さの指定
              width: _screenSize.width * 0.9, // 幅の指定
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 25, bottom: 10),
              child: Text('Hello'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleMapUI() {
    if (_currentLocation == null) {
      //  現在位置が取れるまではローディング中
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentLocation?.latitude as double,
                    _currentLocation?.longitude as double),
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {},
            ),
          ),
        ],
      );
    }
  }

  // 現在地の取得
  void _getLocation() async {
    _currentLocation = await _locationService.getLocation();
  }
}
